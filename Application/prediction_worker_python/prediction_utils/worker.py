import requests
import jwt
import json
import base64
from multiprocessing import current_process
from . import ImagePreprocessor, HealthStatusPredictor, SkinConditionPredictor
from .constants import *


class Worker:
    def __init__(
            self,
            process_queue,
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

        # Here we create the ImagePreprocessor, HealthStatusPredictor, and SkinConditionPredictor instances. We
        # create them here because we want to save resources from the main process and create them only in the worker
        # process. If we created them in the main process, they would be duplicated in each worker process.

        # Initialize the image preprocessor which is used to preprocess the image before feeding it to the models
        self.image_preprocessor = ImagePreprocessor()

        # Initialize the health status predictor which is a binary classification model
        self.health_status_predictor = HealthStatusPredictor(healthy_unhealthy_model_path)

        # Initialize the skin condition predictor which is a multi-class classification model
        self.skin_condition_predictor = SkinConditionPredictor(skin_condition_models_paths)

    def process_message(self, message):
        print(f'The message is {message}')
        try:
            # Deserialize the message data from JSON to a Python dictionary
            decoded_message = base64.b64decode(message)
            print(decoded_message)
            data = json.loads(decoded_message)
            print(data)

            image_url = data['imageUrl'] + '?' + self.sas_token  # Get the image URL and append the SAS token
            prediction_id = data['predictionId']  # Get the prediction ID from the message data
            user_id = data['userId']  # Get the user ID from the message data
            worker_token = data['workerToken']  # Get the worker token from the message data

            # Update the server endpoint with the prediction ID appended to it
            server_endpoint = self.receiver_server_endpoint + prediction_id
            print(f"Server endpoint: {server_endpoint}")

            # Log which process is handling the current message
            print(f"{current_process().name} processing message for prediction ID {prediction_id}")

            # MODEL PROCESSING --------------------------------------------------------------------
            # Preprocess the image, divide by 255 to normalize the pixel values
            image = self.image_preprocessor.preprocess_image(image_url)

            # Check if the image is healthy or not
            is_healthy, health_confidence = self.health_status_predictor.predict_health_status(image)

            # If the image is not healthy, predict the skin condition
            if not is_healthy:
                diagnosis_name, diagnosis_code, confidence_level, decision_found = self.skin_condition_predictor.predict_condition(
                    image)
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
                    print(f"Payload: {payload}")
                    # response = requests.patch(server_endpoint, json=payload)
                    #
                    # if response.status_code == 200:
                    #     print(f'Prediction with id {prediction_id} processed:', response.status_code, response.text)
                    # else:
                    #     print(f'Failed to process prediction with id {prediction_id}:', response.status_code,
                    #           response.text)
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
                    print(f"Payload: {payload}")

                    # response = requests.patch(server_endpoint, json=payload)
                    #
                    # if response.status_code == 200:
                    #     print(f'Prediction with id {prediction_id} processed:', response.status_code, response.text)
                    # else:
                    #     print(f'Failed to process prediction with id {prediction_id}:', response.status_code,
                    #           response.text)
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
                print(f"Payload: {payload}")

                #response = requests.patch(server_endpoint, json=payload)

                # if response.status_code == 200:
                #     print(f'Prediction with id {prediction_id} processed:', response.status_code, response.text)
                # else:
                #     print(f'Failed to process prediction with id {prediction_id}:', response.status_code,
                #           response.text)
        except Exception as e:
            print(f"Error processing message: {e}")

            # Deserialize the message data from JSON to a Python dictionary
            decoded_message = base64.b64decode(message)
            print(decoded_message)
            data = json.loads(decoded_message)
            print(data)

            prediction_id = data['predictionId']  # Get the prediction ID from the message data
            user_id = data['userId']  # Get the user ID from the message data
            worker_token = data['workerToken']  # Get the worker token from the message data

            # Update the server endpoint with the prediction ID appended to it
            server_endpoint = self.receiver_server_endpoint + prediction_id

            # Send error payload back to server
            error_payload = {
                'userId': user_id,
                'workerToken': worker_token,
                'status': PredictionStatus.FAILED
            }
            print(f"ERROR Payload: {error_payload}")

            # response = requests.patch(server_endpoint, json=error_payload)
            #
            # print(f"Error reported: {response.status_code}")

    def start_processing(self):
        while True:
            message = self.process_queue.get()
            if message is None:
                print(f"{current_process().name} received shutdown signal.")
                break
            self.process_message(message)
