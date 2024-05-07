from tensorflow.keras.models import load_model


class HealthStatusPredictor:
    def __init__(self, model_path):
        self.model = load_model(model_path)

    def predict_health_status(self, image):
        prediction = self.model.predict(image)  # Predict the health status of the image
        is_healthy = prediction[0][0] < 0.5  # Check if the image is healthy or not, closer to 0 means healthy
        unhealthy_probability = prediction[0][0]  # Get the probability of being unhealthy
        healthy_probability = 1 - unhealthy_probability  # Get the probability of being healthy

        # Return the health status(true means healthy) and the probability of the prediction
        if is_healthy:
            return True, healthy_probability
        else:
            return False, unhealthy_probability
