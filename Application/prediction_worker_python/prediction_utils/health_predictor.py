from tensorflow.keras.models import load_model


class HealthPredictor:
    def __init__(self, model_path):
        self.model = load_model(model_path.strip('"'))

    def predict_health_status(self, image):
        prediction = self.model.predict(image)
        is_healthy = prediction[0][0] < 0.5
        unhealthy_probability = prediction[0][0]
        healthy_probability = 1 - unhealthy_probability

        if is_healthy:
            print(f'Healthy with probability: {healthy_probability:.2f}')
            return True, healthy_probability
        else:
            print(f'Unhealthy with probability: {unhealthy_probability:.2f}')
            return False, unhealthy_probability
