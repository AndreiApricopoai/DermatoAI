import numpy as np
import os
import pandas as pd
from tensorflow.keras.models import load_model
from tensorflow.keras.preprocessing import image
from sklearn.metrics import accuracy_score


def load_model_from_path(model_path):
    return load_model(model_path)  # this will load the model from the path


def get_class_directory(data_dir, class_name):
    return os.path.join(data_dir, class_name)  # this will return the path to the class directory


def load_and_preprocess_image(image_path):
    img = image.load_img(image_path, target_size=(450, 600))  # this will load the image and resize it
    img_array = image.img_to_array(img)  # this will convert the image to an array
    img_array = np.expand_dims(img_array, axis=0) / 255.0  # this will normalize the image
    return img_array  # this will return the image array


def predict_class(model, img_array, threshold=0.5):  # this will predict the class of the image
    probability = model.predict(img_array)[0][0]  # this will get the probability of the image
    return 0 if probability <= threshold else 1  # this will return the class of the image


def update_confusion_matrix(conf_matrix, true_class, predicted_class):
    conf_matrix[true_class, predicted_class] += 1  # this will update the confusion matrix
    return conf_matrix  # this will return the updated confusion matrix


def print_results(conf_matrix, true_labels, predicted_labels):  # this will print the results
    print("Confusion matrix:")  # this will print the confusion matrix
    print(pd.DataFrame(conf_matrix, index=['healthy', 'unhealthy'], columns=['healthy', 'unhealthy']))
    accuracy = accuracy_score(true_labels, predicted_labels)  # this will calculate the accuracy
    print(f"Accuracy: {accuracy * 100:.2f}%")  # this will print the accuracy


def main():
    model_path = '/path/model.h5'  # this will be the path to the model
    data_dir = '/path'  # this will be the path to the data directory
    class_indices = {'healthy': 0, 'unhealthy': 1}  # this will be the class indices
    conf_matrix = np.zeros((2, 2))  # 2x2 for binary classification
    true_labels = []  # this will store the true labels
    predicted_labels = []  # this will store the predicted labels

    model = load_model_from_path(model_path)  # this will load the model

    for class_name in class_indices.keys():  # this will iterate over the class names
        class_dir = get_class_directory(data_dir, class_name)  # this will get the class directory
        for img_name in os.listdir(class_dir):  # this will iterate over the images in the class directory
            img_path = os.path.join(class_dir, img_name)  # this will get the path to the image
            img_array = load_and_preprocess_image(img_path)  # this will load and preprocess the image
            predicted_class = predict_class(model, img_array)  # this will predict the class of the image
            true_class = class_indices[class_name]  # this will get the true class of the image
            conf_matrix = update_confusion_matrix(conf_matrix, true_class,
                                                  predicted_class)  # this will update the confusion matrix
            true_labels.append(true_class)  # this will append the true class to the true labels
            predicted_labels.append(predicted_class)  # this will append the predicted class to the predicted labels

    print_results(conf_matrix, true_labels, predicted_labels)  # this will print the results


if __name__ == '__main__':
    main()
