import urllib.request
import numpy as np
from tensorflow.keras.preprocessing.image import load_img, img_to_array
from io import BytesIO


class ImagePreprocessor:
    def __init__(self, target_size=(450, 600)):
        self.target_size = target_size

    def preprocess_image(self, image_url):
        with urllib.request.urlopen(image_url) as url:
            img = load_img(BytesIO(url.read()), target_size=self.target_size)
            img = img_to_array(img)
            img = np.expand_dims(img, axis=0) / 255.0
        return img
