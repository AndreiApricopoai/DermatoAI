import sys
import time
import configparser
from azure.storage.queue import QueueClient
from multiprocessing import Process, Queue
from prediction_utils import *


def main(number_of_workers):
    # Load configuration from 'config.ini' file
    config = configparser.RawConfigParser()
    config.read('config.ini')

    # Receiver server endpoint configuration, this is where the worker will send the processed results
    server_endpoint = config.get('SERVER', 'Endpoint').strip('"')

    # Storage account, queue and blob container configuration
    storage_account_connection_string = config.get('AZURE', 'StorageAccountConnectionString')
    queue_name = config.get('AZURE', 'QueueName')
    blob_container_sas_token = config.get('AZURE', 'BlobContainerSASToken')

    # Models path configuration
    healthy_unhealthy_model_path = config.get('MODELS', 'Healthy_Unhealthy_Path').strip('"')
    skin_condition_models_paths = [
        config.get('MODELS', 'DenseNet169_Path').strip('"'),
        config.get('MODELS', 'DenseNet201_Path').strip('"'),
        config.get('MODELS', 'InceptionResNetV2_Path').strip('"')
    ]

    # Initialize the queue client which will be used to receive messages from the azure queue service
    queue_client = QueueClient.from_connection_string(storage_account_connection_string, queue_name)

    # Initialize the process queue which will be used to communicate between the main process and the workers
    process_queue = Queue()

    # Initialize the worker processes with the necessary parameters and models to process the messages, Image
    # preprocessor, health status predictor, skin condition predictor and the blob container sas token will be
    # provided to the worker
    processes = []
    try:
        for _ in range(number_of_workers):
            worker = Worker(
                process_queue=process_queue,
                healthy_unhealthy_model_path=healthy_unhealthy_model_path,
                skin_condition_models_paths=skin_condition_models_paths,
                sas_token=blob_container_sas_token,
                receiver_server_endpoint=server_endpoint
            )  # Create a new worker instance
            process = Process(target=worker.start_processing)  # Create a new process that runs the worker method
            processes.append(process)  # Add the process to the processes list

        # Start the worker processes
        for process in processes:
            process.start()

    except Exception as e:
        print(f"Error starting worker processes: {e}")
        # If an error occurs while starting the worker processes, terminate all processes and exit the program
        for p in processes:
            if p.is_alive():
                p.terminate()  # Send termination request
                p.join()  # Wait for process to terminate
        sys.exit(1)  # Exit the whole program

    try:
        while True:
            # Receive messages from the azure queue service
            messages = queue_client.receive_messages(messages_per_page=5)
            for message in messages:
                print(f"Received message: {message}")
                process_queue.put(message['content'])  # Put the message content inside the shared process queue
                try:
                    queue_client.delete_message(message)
                except Exception as e:
                    print(f"Failed to delete azure queue message: {message} with exception {e}")

            if not messages:
                time.sleep(10)

    except KeyboardInterrupt:
        print("CTRL+C pressed, waiting for workers to terminate and exiting...")
    except Exception as e:
        print(f"Unexpected error occurred: {e}")
    finally:
        for _ in range(number_of_workers):
            process_queue.put(None)
        for process in processes:
            process.join()


if __name__ == "__main__":
    workers_count = 1
    main(workers_count)
