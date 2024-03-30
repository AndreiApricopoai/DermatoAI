import os
import numpy as np
import pandas as pd
from tensorflow.keras.models import load_model
from tensorflow.keras.preprocessing import image


def load_and_preprocess_image(image_path, image_height, image_width):
    img = image.load_img(image_path, target_size=(image_height, image_width))  # this will be the size of the images
    img_array = image.img_to_array(img)  # convert image to numpy array
    img_array = np.expand_dims(img_array, axis=0) / 255.0  # expand the dimensions of the image
    return img_array  # return the image array


def get_class_directory(class_name, data_dir):
    return os.path.join(data_dir, class_name)  # return the path to the class directory


def get_image_predictions(img_array, models):
    return [model.predict(img_array) for model in models]  # return the predictions for the image


def update_confusion_matrices(class_index, predicted_classes, model_paths, conf_matrices):
    for model_path, predicted_class in zip(model_paths,
                                           predicted_classes):  # iterate through the model paths and predicted classes
        conf_matrices[model_path][class_index, predicted_class] += 1  # update the confusion matrix


def calculate_majority_vote(predicted_classes):
    votes_count = {predicted_class: predicted_classes.count(predicted_class) for predicted_class in
                   set(predicted_classes)}  # count the votes for each class
    max_vote = max(votes_count.values())  # get the maximum vote

    if list(votes_count.values()).count(max_vote) > 1:  # if there are multiple classes with the maximum vote
        return max(votes_count, key=votes_count.get)  # return the class with the maximum vote
    return None


def print_confusion_matrix_and_accuracy(model_path, conf_matrix, class_names):
    accuracy = np.trace(conf_matrix) / np.sum(conf_matrix)  # calculate the accuracy
    print(f"Confusion matrix for {model_path}:")  # print the confusion matrix
    print(pd.DataFrame(conf_matrix, index=class_names.values(),
                       columns=class_names.values()))  # print the confusion matrix
    print(f"Accuracy for {model_path}: {accuracy * 100:.2f}%\n")  # print the accuracy


def main():
    IMAGE_HEIGHT = 450  # define the height of the images
    IMAGE_WIDTH = 600  # define the width of the images

    model_paths = [
        '/path/model.h5',
        '/path/model.h5',
        '/path/model.h5'
    ]
    models = [load_model(path) for path in model_paths]  # load the models

    data_dir = '/path'  # define the path to the data directory

    class_names = {
        0: 'actinic keratosis',
        1: 'basal cell carcinoma',
        2: 'dermatofibroma',
        3: 'melanoma',
        4: 'nevus',
        5: 'pigmented benign keratosis',
        6: 'squamous cell carcinoma',
        7: 'vascular lesion'
    }
    conf_matrices = {model_path: np.zeros((len(class_names), len(class_names))) for model_path in
                     model_paths}  # initialize the confusion matrices
    conf_matrix_ensemble = np.zeros(
        (len(class_names), len(class_names)))  # initialize the confusion matrix for the ensemble

    for class_index, class_name in class_names.items():  # iterate through the class names
        class_dir = get_class_directory(class_name, data_dir)  # get the class directory
        for img_name in os.listdir(class_dir):  # iterate through the images in the class directory
            img_path = os.path.join(class_dir, img_name)  # get the path to the image
            img_array = load_and_preprocess_image(img_path, IMAGE_HEIGHT, IMAGE_WIDTH)  # load and preprocess the image

            predictions = get_image_predictions(img_array, models)  # get the predictions for the image
            predicted_classes = [np.argmax(pred, axis=1)[0] for pred in predictions]  # get the predicted classes

            update_confusion_matrices(class_index, predicted_classes, model_paths,
                                      conf_matrices)  # update the confusion matrices

            vote = calculate_majority_vote(predicted_classes)  # calculate the majority vote
            if vote is not None:
                conf_matrix_ensemble[class_index, vote] += 1  # update the confusion matrix for the ensemble

    pd.set_option('display.max_columns', None)  # Display all columns
    pd.set_option('display.max_rows', None)  # Display all rows

    for model_path, conf_matrix in conf_matrices.items():  # iterate through the model paths and confusion matrices
        print_confusion_matrix_and_accuracy(model_path, conf_matrix,
                                            class_names)  # print the confusion matrix and accuracy

    ensemble_accuracy = np.trace(conf_matrix_ensemble) / np.sum(
        conf_matrix_ensemble)  # calculate the accuracy for the ensemble
    print("Confusion matrix for ensemble:")  # print the confusion matrix for the ensemble
    print(pd.DataFrame(conf_matrix_ensemble, index=class_names.values(),
                       columns=class_names.values()))  # print the confusion matrix for the ensemble
    print(f"Ensemble accuracy: {ensemble_accuracy * 100:.2f}%")  # print the accuracy for the ensemble


if __name__ == '__main__':
    main()
