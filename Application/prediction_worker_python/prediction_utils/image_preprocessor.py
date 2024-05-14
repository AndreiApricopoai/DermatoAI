import numpy as np
import urllib.request
from io import BytesIO
from tensorflow.keras.preprocessing.image import load_img, img_to_array


class ImagePreprocessor:
    def __init__(self, target_size=(450, 600)):
        self.target_size = target_size

    def preprocess_image(self, image_url):
        with urllib.request.urlopen(image_url) as url:
            img = load_img(BytesIO(url.read()), target_size=self.target_size)
            img = img_to_array(img)
            img = np.expand_dims(img, axis=0) / 255.0  # Normalize the image with values between 0 and 1
        return img
