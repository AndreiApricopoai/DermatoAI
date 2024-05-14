import requests
import json
import base64
from multiprocessing import current_process
from . import ImagePreprocessor, HealthStatusPredictor, SkinConditionPredictor
from .constants import *


class Worker:
    def __init__(
            self,
            process_queue,  # This is the queue that holds the messages to be processed
            healthy_unhealthy_model_path,
            skin_condition_models_paths,
            sas_token,
            receiver_server_endpoint,
    ):
        self.process_queue = process_queue
        self.healthy_unhealthy_model_path = healthy_unhealthy_model_path
        self.skin_condition_models_paths = skin_condition_models_paths
        self.sas_token = sas_token
        self.receiver_server_endpoint = receiver_server_endpoint

        # Initialize the image preprocessor, health status predictor, and skin condition predictor
        self.image_preprocessor = ImagePreprocessor()
        self.health_status_predictor = HealthStatusPredictor(healthy_unhealthy_model_path)
        self.skin_condition_predictor = SkinConditionPredictor(skin_condition_models_paths)

    @staticmethod
    def send_prediction_response_to_server(server_endpoint, prediction_id, payload):
        response = requests.patch(server_endpoint, json=payload)
        if response.status_code == 200:
            print(f'Prediction with id {prediction_id} processed: ', response.status_code)
        else:
            print(f'Failed to process prediction with id {prediction_id}: ', response.status_code)

    @staticmethod
    def send_prediction_error_response_to_server(server_endpoint, prediction_id, error_payload):
        response = requests.patch(server_endpoint, json=error_payload)
        if response.status_code == 200:
            print(f'Prediction with id {prediction_id} updated with FAILED status', response.status_code)
        else:
            print(f'Could not update the status of prediction with id {prediction_id} to FAILED :',
                  response.status_code)

    def process_message(self, message):
        try:
            # Deserialize the message data from JSON to a Python dictionary
            decoded_message = base64.b64decode(message)
            data = json.loads(decoded_message)
            print(data)

            image_url = data['imageUrl'] + '?' + self.sas_token  # Get the image URL and append the SAS token
            prediction_id = data['predictionId']
            user_id = data['userId']
            worker_token = data['workerToken']

            server_endpoint = self.receiver_server_endpoint + prediction_id

            # Log which process is handling the current message
            print(f"{current_process().name} processing message for prediction ID {prediction_id}")

            # MODEL PROCESSING --------------------------------------------------------------------
            image = self.image_preprocessor.preprocess_image(image_url)

            # Check if the image is healthy or not
            payload = {}
            is_healthy, health_confidence = self.health_status_predictor.predict_health_status(image)
            if not is_healthy:
                diagnosis_name, diagnosis_code, confidence_level, decision_found \
                    = self.skin_condition_predictor.predict_condition(image)
                if decision_found:
                    payload = {
                        'userId': user_id,
                        'workerToken': worker_token,
                        'isHealthy': False,
                        'diagnosisName': diagnosis_name,
                        'diagnosisCode': diagnosis_code,
                        'diagnosisType': UNHEALTHY_DIAGNOSIS_INFO[diagnosis_code]['type'],
                        'confidenceLevel': confidence_level,
                        'status': PredictionStatus.PROCESSED
                    }
                # If the skin condition is not found, report the image as unhealthy
                else:
                    payload = {
                        'userId': user_id,
                        'workerToken': worker_token,
                        'isHealthy': False,
                        'diagnosisName': UNKNOWN_DIAGNOSIS_INFO['name'],
                        'diagnosisCode': UNKNOWN_DIAGNOSIS_INFO['code'],
                        'diagnosisType': UNKNOWN_DIAGNOSIS_INFO['type'],
                        'confidenceLevel': UNKNOWN_DIAGNOSIS_INFO['confidenceLevel'],
                        'status': PredictionStatus.PROCESSED
                    }
            # If the image is healthy, report the image as healthy
            else:
                payload = {
                    'userId': user_id,
                    'workerToken': worker_token,
                    'isHealthy': True,
                    'diagnosisName': HEALTHY_DIAGNOSIS_INFO['name'],
                    'diagnosisCode': HEALTHY_DIAGNOSIS_INFO['code'],
                    'diagnosisType': HEALTHY_DIAGNOSIS_INFO['type'],
                    'confidenceLevel': health_confidence,
                    'status': PredictionStatus.PROCESSED
                }

            # Send the prediction response to the server
            print(f"Payload: {payload}")
            Worker.send_prediction_response_to_server(server_endpoint, prediction_id, payload)

        except Exception as e:
            try:
                print(f"Error processing message: {e}")

                # Deserialize the message data from JSON to a Python dictionary
                decoded_message = base64.b64decode(message)
                data = json.loads(decoded_message)
                print(data)

                prediction_id = data['predictionId']
                user_id = data['userId']
                worker_token = data['workerToken']

                server_endpoint = self.receiver_server_endpoint + prediction_id

                error_payload = {
                    'userId': user_id,
                    'workerToken': worker_token,
                    'status': PredictionStatus.FAILED
                }
                print(f"ERROR Payload: {error_payload}")
                Worker.send_prediction_error_response_to_server(server_endpoint, prediction_id, error_payload)
            except Exception as send_error:
                print(f"Could not send error response: {send_error}")

    def start_processing(self):
        while True:
            message = self.process_queue.get()
            if message is None:
                print(f"{current_process().name} received shutdown signal. Exiting...")
                break
            self.process_message(message)
