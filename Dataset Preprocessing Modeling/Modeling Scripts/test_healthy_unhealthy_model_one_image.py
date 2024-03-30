from tensorflow.keras.models import load_model
from tensorflow.keras.preprocessing import image
import numpy as np


def load_model_from_path(model_path):
    return load_model(model_path)  # Load model from path


def load_and_preprocess_image(image_path):
    img = image.load_img(image_path, target_size=(450, 600))  # Load image from path
    img_array = image.img_to_array(img)  # Convert image to array
    img_array = np.expand_dims(img_array, axis=0) / 255.0  # Normalize image
    return img_array  # Return image array


def predict_with_model(model, img_array):
    return model.predict(img_array)[0][0]  # Predict image with model


def get_prediction(probability, threshold=0.5):
    return 'healthy' if probability <= threshold else 'unhealthy'  # Get prediction


def print_prediction(probability, predicted_class):
    print(f"Probability of being healthy: {1 - probability}")  # Print probability
    print(f"Predicted class: {predicted_class}")  # Print prediction


def main():
    model_path = '/path/model.h5'
    image_path = '/path/image.jpg'

    model = load_model_from_path(model_path)  # Load model
    img_array = load_and_preprocess_image(image_path)  # Load and preprocess image

    probability = predict_with_model(model, img_array)  # Predict image with model
    predicted_class = get_prediction(probability)  # Get prediction

    print_prediction(probability, predicted_class)  # Print prediction


if __name__ == '__main__':
    main()
