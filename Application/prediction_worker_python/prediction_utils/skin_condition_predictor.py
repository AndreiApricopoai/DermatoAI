import numpy as np
from tensorflow.keras.models import load_model
from collections import Counter
from .constants import CLASS_INDICES_NAMES


class SkinConditionPredictor:
    def __init__(self, models_paths):
        # Load all multiclass models in the list
        self.models = [load_model(path) for path in models_paths]

    def predict_condition(self, image):
        predictions = []  # List of predictions from all models as indices
        all_probabilities = []  # List of probabilities from all models for the predicted class as percentages

        for model in self.models:
            probabilities = model.predict(image)[0]  # Get the probabilities of the image being in each class
            predicted_class = np.argmax(probabilities)  # Get the class with the highest probability
            predictions.append(predicted_class)  # Add the predicted class to the list of predictions
            all_probabilities.append(probabilities[predicted_class])  # Add the probability of the predicted class to
            # the list of probabilities

        # Find the most common prediction and count how many times it appears
        most_common, num_most_common = Counter(predictions).most_common(1)[0]
        if num_most_common >= 2:
            max_probability = -1
            # Find the maximum probability of the most common prediction and that is the confidence level
            for i, prediction in enumerate(predictions):
                if prediction == most_common:
                    if all_probabilities[i] > max_probability:
                        max_probability = all_probabilities[i]
            return CLASS_INDICES_NAMES[most_common], most_common, max_probability, True
        else:
            return None, None, None, False
