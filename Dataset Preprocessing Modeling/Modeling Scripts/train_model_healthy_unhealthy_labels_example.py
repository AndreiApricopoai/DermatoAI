import numpy as np
import tensorflow as tf
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Conv2D, MaxPooling2D, Flatten, Dense, Dropout, BatchNormalization
from tensorflow.keras.preprocessing.image import ImageDataGenerator
from tensorflow.keras.optimizers import Adam
from tensorflow.keras.losses import BinaryCrossentropy
from tensorflow.keras.callbacks import EarlyStopping
from sklearn.metrics import confusion_matrix, classification_report
from keras import backend as K


class F1Score(tf.keras.metrics.Metric):  # This class is used to calculate the F1 score
    def __init__(self, name='f1_score', **kwargs):
        super().__init__(name=name, **kwargs)
        self.precision = tf.keras.metrics.Precision()  # Precision metric
        self.recall = tf.keras.metrics.Recall()  # Recall metric

    def update_state(self, y_true, y_pred, sample_weight=None):  # Update the state of the metrics
        self.precision.update_state(y_true, y_pred, sample_weight)  # Update the precision metric
        self.recall.update_state(y_true, y_pred, sample_weight)  # Update the recall metric

    def result(self):
        p = self.precision.result()  # Get the precision
        r = self.recall.result()  # Get the recall
        return 2 * ((p * r) / (p + r + K.epsilon()))  # Calculate the F1 score

    def reset_states(self):
        self.precision.reset_states()  # Reset the precision metric
        self.recall.reset_states()  # Reset the recall metric


def create_model(target_size):  # Create the model
    model = Sequential([
        Conv2D(16, (3, 3), activation='relu', input_shape=(target_size[0], target_size[1], 3), padding='same'),
        BatchNormalization(),
        MaxPooling2D((2, 2)),
        Conv2D(32, (3, 3), activation='relu', padding='same'),
        BatchNormalization(),
        MaxPooling2D((2, 2)),
        Flatten(),
        Dense(64, activation='relu'),
        Dropout(0.5),
        BatchNormalization(),
        Dense(1, activation='sigmoid')  # Sigmoid activation function for binary classification
    ])
    return model


def train_model(model, train_generator, validation_generator, batch, epochs):  # Train the model
    early_stopping = EarlyStopping(
        monitor='val_loss',
        min_delta=0.001,
        patience=2,
        mode='min',
        verbose=1,
        restore_best_weights=True
    )  # Early stopping callback

    model.fit(
        train_generator,
        steps_per_epoch=train_generator.n // batch,
        validation_data=validation_generator,
        validation_steps=validation_generator.n // batch,
        epochs=epochs,
        callbacks=[early_stopping]
    )  # Fit the model


def predict_and_evaluate(model, validation_generator, batch, train_generator):  # Predict and evaluate the model
    validation_generator.reset()  # Reset the validation generator
    predictions = model.predict(validation_generator, steps=np.ceil(validation_generator.n / batch), verbose=1)
    predicted_classes = np.where(predictions > 0.5, 1, 0).flatten()  # Get the predicted classes
    true_labels = validation_generator.classes  # Get the true labels
    conf_matrix = confusion_matrix(true_labels, predicted_classes[:len(true_labels)])  # Generate the confusion matrix
    print("Confusion Matrix:")  # Print the confusion matrix
    print(conf_matrix)
    print("\nClassification Report:")  # Print the classification report
    print(
        classification_report(true_labels, predicted_classes, target_names=list(train_generator.class_indices.keys())))


def main():
    np.random.seed(42)  # Set the random seed
    target_size = (450, 600)  # Set the target size
    batch = 16  # Set the batch size
    epochs = 10  # Set the number of epochs
    image_directory = '/path'  # Set the path to the images
    model_path_save = '/path/model.h5'  # Set the path to save the model

    datagen = ImageDataGenerator(rescale=1. / 255, validation_split=0.3)
    train_generator = datagen.flow_from_directory(
        directory=image_directory,
        target_size=target_size,
        batch_size=batch,
        shuffle=True,
        class_mode='binary',
        subset='training',
        seed=42
    )  # Create the training generator
    validation_generator = datagen.flow_from_directory(
        directory=image_directory,
        target_size=target_size,
        batch_size=batch,
        shuffle=False,
        class_mode='binary',
        subset='validation',
        seed=42
    )  # Create the validation generator
    print(train_generator.class_indices)  # Print the class indices

    model = create_model(target_size)  # Create the model
    model.compile(optimizer=Adam(learning_rate=0.0005),
                  loss=BinaryCrossentropy(),
                  metrics=['accuracy', tf.keras.metrics.Precision(), tf.keras.metrics.Recall(), F1Score()])
    model.summary()  # Print the model summary
    train_model(model, train_generator, validation_generator, batch, epochs)  # Train the model
    predict_and_evaluate(model, validation_generator, batch, train_generator)  # Predict and evaluate the model
    model.save(model_path_save)  # Save the model


if __name__ == '__main__':
    main()
