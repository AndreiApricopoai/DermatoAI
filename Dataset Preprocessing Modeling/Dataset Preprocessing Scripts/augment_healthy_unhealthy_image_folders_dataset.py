from PIL import Image
from tensorflow.keras.preprocessing.image import save_img, img_to_array, ImageDataGenerator
import os
import math


def augment_image(image, save_dir, diagnosis_label, augmentation_index, data_gen):  # Augment image and save it
    img = image.resize((600, 450))  # Resize image to 600x450
    image_array = img_to_array(img)  # Convert image to array
    image_array = image_array.reshape((1,) + image_array.shape)  # Reshape image to (1, 600, 450, 3)

    for batch in data_gen.flow(image_array, batch_size=1):  # Generate augmented images
        augmented_image_name = f"aug_{diagnosis_label}_{augmentation_index}.JPG"  # Name of augmented image
        save_img(os.path.join(save_dir, augmented_image_name), batch[0])  # Save augmented image
        break


def process_folder(original_folder, target_folder, diagnosis_label, num_augmentations, data_gen):
    images = os.listdir(original_folder)  # Get list of images in folder
    augmentation_index = 0  # Index for augmented images
    for image_name in images:  # Augment each image
        image_path = os.path.join(original_folder, image_name)  # Path to image
        image = Image.open(image_path)  # Open image
        for _ in range(num_augmentations):  # Augment image num_augmentations times
            augment_image(image, target_folder, diagnosis_label, augmentation_index, data_gen)  # Augment image
            augmentation_index += 1  # Increment augmentation index


def main():
    label_to_folder_map = {'healthy': '/path'}  # Map of diagnosis labels to original image folders
    label_to_augmented_folder_map = {'healthy': '/path'}  # Map of diagnosis labels to augmented image folders
    initial_class_counts = {'healthy': 355}  # Initial class counts
    target_count = 2800  # Target class count

    additional_needed = {label: target_count - initial for label, initial in initial_class_counts.items() if
                         initial < target_count}  # Calculate additional images needed
    augmentations_per_image = {label: math.ceil(additional / initial_class_counts[label]) for label, additional in
                               additional_needed.items()}  # Calculate augmentations per image

    data_gen = ImageDataGenerator(
        rotation_range=20,
        brightness_range=[0.7, 1.2],
        width_shift_range=0.05,
        height_shift_range=0.05,
        zoom_range=0.2,
        horizontal_flip=True,
        vertical_flip=True,
        fill_mode='reflect'
    )  # Image data generator for augmentation

    for diagnosis_label, original_folder in label_to_folder_map.items():  # Augment images in each folder
        target_folder = label_to_augmented_folder_map[diagnosis_label]  # Get target folder
        num_augmentations = augmentations_per_image.get(diagnosis_label, 0)  # Get number of augmentations needed
        process_folder(original_folder, target_folder, diagnosis_label, num_augmentations, data_gen)  # Augment images

    print("Augmentation and CSV update complete.")  # Print completion message


if __name__ == '__main__':
    main()
