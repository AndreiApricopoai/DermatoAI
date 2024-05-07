"""
This package provides classes for working with medical models, images and azure queue and blob.

It includes: - `ImagePreprocessor`: A class for getting the image from the blob URL and preprocessing it. -
`HealthStatusPredictor`: A class that uses a binary medical model to check if the there is a disease or not. -
`SkinConditionPredictor`: A class that uses 3 multiclass models to diagnose an image. - `Worker`: A class that
represents a worker that runs blob images trough medical models and sends the response to the main server."""

from .health_status_predictor import HealthStatusPredictor
from .image_preprocessor import ImagePreprocessor
from .skin_condition_predictor import SkinConditionPredictor
from .worker import Worker

__all__ = ['HealthStatusPredictor', 'ImagePreprocessor', 'SkinConditionPredictor', 'Worker']
