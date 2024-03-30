import csv
import os
import math
from PIL import Image
from tensorflow.keras.preprocessing.image import save_img, img_to_array
from tensorflow.keras.preprocessing.image import ImageDataGenerator


def augment_image(image, save_dir, csv_writer, diagnosis_label, augmentation_index, data_gen):
    image_array = img_to_array(image)  # Convert image to numpy array
    image_array = image_array.reshape((1,) + image_array.shape)  # Reshape image to 4D array
    for batch in data_gen.flow(image_array, batch_size=1):  # Generate batches of augmented images
        augmented_image_name = f"aug_{diagnosis_label}_{augmentation_index}.JPG"  # Name of augmented image
        augmented_image_path = os.path.join(save_dir, augmented_image_name)  # Path to save augmented image
        save_img(augmented_image_path, batch[0])  # Save augmented image
        csv_writer.writerow(
            [augmented_image_name] + [''] * 5 + [diagnosis_label] + [''] * 4)  # Write image name and label to CSV
        break


def process_folder(original_folder, target_folder, csv_writer, diagnosis_label, num_augmentations, data_gen):
    images = os.listdir(original_folder)  # Get list of images in folder
    augmentation_index = 0  # Index for augmented images
    for image_name in images:  # Iterate through images
        image_path = os.path.join(original_folder, image_name)  # Path to image
        image = Image.open(image_path)  # Open image
        for _ in range(num_augmentations):  # Augment image multiple times
            augment_image(image, target_folder, csv_writer, diagnosis_label, augmentation_index,
                          data_gen)  # Augment image
            augmentation_index += 1  # Increment index


def main():
    label_to_folder_map = {
        'nevus': '/path',
        'melanoma': '/path',
        'basal cell carcinoma': '/path',
        'squamous cell carcinoma': '/path',
        'actinic keratosis': '/path',
        'vascular lesion': '/path',
        'dermatofibroma': '/path',
        'pigmented benign keratosis': '/path'
    }

    # Mapping of diagnosis labels to augmented folder paths
    label_to_augmented_folder_map = {
        'nevus': '/path',
        'melanoma': '/path',
        'basal cell carcinoma': '/path',
        'squamous cell carcinoma': '/path',
        'actinic keratosis': '/path',
        'vascular lesion': '/path',
        'dermatofibroma': '/path',
        'pigmented benign keratosis': '/path'
    }

    initial_image_counts = {
        'vascular lesion': 180,
        'squamous cell carcinoma': 229,
        'pigmented benign keratosis': 1338,
        'nevus': 7737,  # No augmentation needed
        'melanoma': 1305,
        'dermatofibroma': 160,
        'basal cell carcinoma': 622,
        'actinic keratosis': 149
    }

    target_count = 1304

    additional_needed = {label: target_count - count for label, count in initial_image_counts.items() if
                         count < target_count}  # Calculate additional images needed
    augmentations_per_image = {label: math.ceil(additional / initial_image_counts[label]) for label, additional in
                               additional_needed.items()}  # Calculate augmentations per image

    data_gen = ImageDataGenerator(
        rotation_range=40,
        brightness_range=[0.7, 1.2],
        width_shift_range=0.12,
        height_shift_range=0.12,
        shear_range=0.1,
        zoom_range=0.2,
        horizontal_flip=True,
        vertical_flip=True,
        fill_mode='reflect',
    )  # Data augmentation parameters

    with open('/path_to_csv', 'a', newline='') as file:  # Open CSV file
        csv_writer = csv.writer(file)  # Create CSV writer
        for diagnosis_label, original_folder in label_to_folder_map.items():  # Iterate through label-folder mapping
            target_folder = label_to_augmented_folder_map[diagnosis_label]  # Get target folder for augmented images
            num_augmentations = augmentations_per_image.get(diagnosis_label, 0)  # Get number of augmentations needed
            process_folder(original_folder, target_folder, csv_writer, diagnosis_label, num_augmentations,
                           data_gen)  # Process folder

    print("Augmentation and CSV update complete.")  # Print completion message


if __name__ == '__main__':
    main()
