import tensorflow as tf
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from tensorflow.keras.preprocessing.image import ImageDataGenerator
from tensorflow.keras.models import Model
from tensorflow.keras.applications import DenseNet169
from tensorflow.keras.layers import GlobalAveragePooling2D, Dense, BatchNormalization, Dropout
from tensorflow.keras.losses import CategoricalCrossentropy
from tensorflow.keras.optimizers import Adam
from tensorflow.keras.callbacks import EarlyStopping, ReduceLROnPlateau
from sklearn.metrics import confusion_matrix, classification_report


class F1Score(tf.keras.metrics.Metric):  # Custom F1 Score metric
    def __init__(self, name='f1_score', **kwargs):
        super(F1Score, self).__init__(name=name, **kwargs)
        self.precision = tf.keras.metrics.Precision()  # this is the precision metric
        self.recall = tf.keras.metrics.Recall()  # this is the recall metric

    def update_state(self, y_true, y_pred, sample_weight=None):
        self.precision.update_state(y_true, y_pred, sample_weight)  # computes the precision
        self.recall.update_state(y_true, y_pred, sample_weight)  # computes the recall

    def result(self):
        precision = self.precision.result()  # gets the precision result
        recall = self.recall.result()  # gets the precision and recall results
        return 2 * ((precision * recall) / (precision + recall + tf.keras.backend.epsilon()))  # returns the f1 score

    def reset_states(self):
        self.precision.reset_states()  # resets the state of the metric
        self.recall.reset_states()  # resets the state of the metric


def create_model(target_size, num_classes):  # Function to create the model
    base_model = DenseNet169(include_top=False, weights='imagenet', input_shape=(target_size[0], target_size[1], 3))
    for layer in base_model.layers[:-40]:  # Freeze the layers
        layer.trainable = False
    x = GlobalAveragePooling2D()(base_model.output)  # Add the pooling layer
    x = Dense(512, activation='relu')(x)
    x = BatchNormalization()(x)
    x = Dropout(0.8)(x)
    x = Dense(256, activation='relu')(x)
    x = BatchNormalization()(x)
    x = Dropout(0.7)(x)
    predictions = Dense(num_classes, activation='softmax')(x)  # Add the output layer
    model = Model(inputs=base_model.input, outputs=predictions)  # Create the model
    return model  # Return the model


def compile_and_fit_model(model, train_generator, validation_generator,
                          epochs):  # Function to compile and fit the model
    model.compile(optimizer=Adam(learning_rate=0.00007), loss=CategoricalCrossentropy(),  # Compile the model
                  metrics=['accuracy', tf.keras.metrics.Precision(), tf.keras.metrics.Recall(),
                           F1Score()])  # Add the custom F1 Score metric
    callbacks = [ReduceLROnPlateau(monitor='val_loss', factor=0.1, patience=3, verbose=1, min_lr=1e-6),
                 # Add the ReduceLROnPlateau callback
                 EarlyStopping(monitor='val_loss', min_delta=0.001, patience=4, verbose=1,
                               restore_best_weights=True)]  # Add the EarlyStopping callback
    history = model.fit(train_generator, steps_per_epoch=train_generator.n // train_generator.batch_size,
                        # Fit the model
                        validation_data=validation_generator,
                        validation_steps=validation_generator.n // validation_generator.batch_size,
                        epochs=epochs, callbacks=callbacks)
    return history  # Return the history


def plot_loss(history):  # Function to plot the loss
    plt.plot(history.history['loss'])  # Plot the loss
    plt.plot(history.history['val_loss'])  # Plot the validation loss
    plt.title('Model loss')  # Set the title
    plt.ylabel('Loss')  # Set the y-axis label
    plt.xlabel('Epoch')  # Set the x-axis label
    plt.legend(['Train', 'Validation'], loc='upper left')  # Set the legend
    plt.show()  # Show the plot


def evaluate_and_display_results(validation_generator, model):  # Function to evaluate and display the results
    validation_generator.reset()  # Reset the generator
    predictions = model.predict(validation_generator, steps=np.ceil(
        validation_generator.n / validation_generator.batch_size))  # Predict the validation set
    predicted_classes = np.argmax(predictions, axis=1)  # Get the predicted classes
    true_classes = validation_generator.classes  # Get the true classes
    conf_matrix = confusion_matrix(true_classes, predicted_classes)  # Get the confusion matrix
    plt.figure(figsize=(10, 10))  # Set the figure size
    sns.heatmap(conf_matrix, annot=True, fmt='g', cmap='Blues', xticklabels=validation_generator.class_indices.keys(),
                yticklabels=validation_generator.class_indices.keys())
    plt.xlabel('Predicted')  # Set the x-axis label
    plt.ylabel('True')  # Set the y-axis label
    plt.title('Confusion Matrix')  # Set the title
    plt.show()  # Show the plot
    print(classification_report(true_classes, predicted_classes, target_names=list(
        validation_generator.class_indices.keys())))  # Print the classification report


def main():
    np.random.seed(42)  # Set the seed
    target_size = (450, 600)  # Set the target size
    batch = 16  # Set the batch size
    epochs = 20  # Set the number of epochs
    image_directory = '/path'  # Set the image directory

    datagen = ImageDataGenerator(rescale=1. / 255, validation_split=0.3)  # Create the ImageDataGenerator
    train_generator = datagen.flow_from_directory(directory=image_directory, target_size=target_size, batch_size=batch,
                                                  class_mode='categorical', subset='training', seed=42)
    validation_generator = datagen.flow_from_directory(directory=image_directory, target_size=target_size,
                                                       batch_size=batch,
                                                       class_mode='categorical', subset='validation', seed=42)

    model = create_model(target_size, len(train_generator.class_indices))  # Create the model
    model.summary()  # Print the model summary
    history = compile_and_fit_model(model, train_generator, validation_generator, epochs)  # Here we pass epochs
    plot_loss(history)  # Plot the loss
    evaluate_and_display_results(validation_generator, model)  # Evaluate and display the results
    model.save('/path/model.h5')  # Save the model


if __name__ == '__main__':
    main()
