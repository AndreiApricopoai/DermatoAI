import numpy as np
from tensorflow.keras.models import load_model
from collections import Counter


class SkinConditionPredictor:
    def __init__(self, models_paths):
        self.models = [load_model(path.strip('"')) for path in models_paths]

    def predict_condition(self, image):
        predictions = []
        all_confidences = []

        for model in self.models:
            probabilities = model.predict(image)[0]
            predicted_class = np.argmax(probabilities)
            predictions.append(predicted_class)
            all_confidences.append(probabilities[predicted_class])

        most_common, num_most_common = Counter(predictions).most_common(1)[0]
        if num_most_common >= 2:
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

            max_confidence = -1
            for i, prediction in enumerate(predictions):
                if prediction == most_common:
                    if all_confidences[i] > max_confidence:
                        max_confidence = all_confidences[i]
            print(class_names[most_common], max_confidence, most_common)
            return class_names[most_common], max_confidence, True
        else:
            return None, None, False
