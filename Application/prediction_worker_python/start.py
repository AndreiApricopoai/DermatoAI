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
from prediction_utils import *

def main(num_workers):
    config = configparser.RawConfigParser()
    config.read('config.ini')

    storage_account_connection_string = config.get('AZURE', 'StorageAccountConnectionString')
    queue_name = config.get('AZURE', 'QueueName')
    blob_container_sas_token = config.get('AZURE', 'BlobContainerSASToken')

    image_preprocessor = ImagePreprocessor()
    health_status_predictor = HealthPredictor(config.get('MODELS', 'Healthy_Unhealthy_Path'))
    skin_condition_predictor = SkinConditionPredictor([
        config.get('MODELS', 'DenseNet169_Path'),
        config.get('MODELS', 'DenseNet201_Path'),
        config.get('MODELS', 'InceptionResNetV2_Path')
    ])

    connection_string = 'your_connection_string_here'
    queue_name = 'your_queue_name_here'
    queue_client = QueueClient.from_connection_string(connection_string, queue_name)
    process_queue = Queue()

    processes = [Process(target=Worker(process_queue, {
        'health_status': health_status_predictor,
        'skin_condition': skin_condition_predictor
    }, image_preprocessor).start_processing) for _ in range(num_workers)]
    for p in processes:
        p.start()

    try:
        while True:
            messages = queue_client.receive_messages(messages_per_page=32)
            for message in messages:
                process_queue.put(message.content)
                queue_client.delete_message(message)
            if not messages:
                time.sleep(10)
    except KeyboardInterrupt:
        print("Shutting down gracefully...")
    finally:
        for _ in range(num_workers):
            process_queue.put(None)
        for p in processes:
            p.join()

if __name__ == "__main__":
    num_workers = 4
    main(num_workers)

#predict_condition(multiclass_models, preprocess_image(
 #   f'https://imagesdermatoai.blob.core.windows.net/meidical1images/825b359a-9ba4-4b2a-b4de-ebde05f955dfprediction-1714917866374.jpg?{blob_container_sas_token}'))
