import os
import time
import matplotlib.pyplot as plt
import urllib.request
from PIL import Image
import requests
import configparser
import numpy as np
from azure.storage.queue import QueueClient
from multiprocessing import Process, Queue
import json
from tensorflow.keras.models import load_model
from tensorflow.keras.preprocessing.image import load_img, img_to_array
from collections import Counter
from io import BytesIO

class Worker:
    def __init__(self, process_queue, models, image_preprocessor):
        self.process_queue = process_queue
        self.models = models
        self.image_preprocessor = image_preprocessor

    def process_message(self, message):
        try:
            data = json.loads(message)
            image_url = data['imageUrl']
            prediction_id = data['predictionId']
            user_id = data['userId']
            worker_token = data['workerToken']
            image = self.image_preprocessor.preprocess_image(image_url)

            is_healthy, health_confidence = self.models['health_status'].predict_health_status(image)

            if not is_healthy:
                condition, confidence, consensus = self.models['skin_condition'].predict_condition(image)
                if consensus:
                    payload = {
                        'predictionId': prediction_id,
                        'userId': user_id,
                        'workerToken': worker_token,
                        'isHealthy': is_healthy,
                        'diagnosisName': condition,
                        'diagnosisCode': '',
                        'diagnosisType': condition,
                        'confidenceLevel': confidence,
                        'status': 'processed'
                    }
                    response = requests.put(f'http://api.yourserver.com/update_prediction/{prediction_id}',
                                            json=payload, headers={'Authorization': f'Bearer {worker_token}'})
                    print('Update response:', response.status_code, response.text)
                else:
                    print('No consensus reached among models.')
            else:
                print('Image is healthy, no further processing.')
        except Exception as e:
            print(f"Error processing message: {e}")

    def start_processing(self):
        while True:
            message = self.process_queue.get()
            if message is None:
                self.process_queue.task_done()
                break
            self.process_message(message)
            self.process_queue.task_done()