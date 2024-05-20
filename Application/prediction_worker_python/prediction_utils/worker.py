import requests
import json
import base64
from multiprocessing import current_process
from prediction_utils import ImagePreprocessor, HealthStatusPredictor, SkinConditionPredictor
from .constants import *
from .numpy_datatypes_converter import NumpyEncoder


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

        self.image_preprocessor = ImagePreprocessor()
        self.health_status_predictor = HealthStatusPredictor(healthy_unhealthy_model_path)
        self.skin_condition_predictor = SkinConditionPredictor(skin_condition_models_paths)

    @staticmethod
    def send_prediction_response_to_server(server_endpoint, prediction_id, payload):
        json_payload = json.dumps(payload, cls=NumpyEncoder)
        response = requests.patch(server_endpoint, data=json_payload, headers={'Content-Type': 'application/json'})
        if response.status_code == 200:
            print(f'Prediction {prediction_id} processed with status: ', response.status_code, '\n')
        else:
            print(f'Failed to process prediction {prediction_id} with status: ', response.status_code, '\n')

    @staticmethod
    def send_prediction_error_response_to_server(server_endpoint, prediction_id, error_payload):
        json_payload = json.dumps(error_payload, cls=NumpyEncoder)
        response = requests.patch(server_endpoint, data=json_payload, headers={'Content-Type': 'application/json'})
        if response.status_code == 200:
            print(f'Prediction {prediction_id} updated with FAILED status', response.status_code, '\n')
        else:
            print(f'Could not update prediction at all(inconsistent state)', response.status_code, '\n')

    def process_message(self, message):
        try:
            decoded_message = base64.b64decode(message)
            data = json.loads(decoded_message)

            image_url = data['imageUrl'] + '?' + self.sas_token
            prediction_id = data['predictionId']
            user_id = data['userId']
            worker_token = data['workerToken']

            server_endpoint = self.receiver_server_endpoint + prediction_id

            # Log which process is handling the current message
            print(f"{current_process().name} processing message for prediction ID {prediction_id}\n")

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
                decoded_message = base64.b64decode(message)
                data = json.loads(decoded_message)

                prediction_id = data['predictionId']
                user_id = data['userId']
                worker_token = data['workerToken']

                server_endpoint = self.receiver_server_endpoint + prediction_id

                error_payload = {
                    'userId': user_id,
                    'workerToken': worker_token,
                    'status': PredictionStatus.FAILED
                }
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
