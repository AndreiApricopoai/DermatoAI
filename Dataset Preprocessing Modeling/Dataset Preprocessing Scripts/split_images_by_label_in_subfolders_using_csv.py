import os
import pandas as pd
import shutil


def organize_images(csv_file, main_folder, subfolders):
    # Load the CSV file into a DataFrame
    data = pd.read_csv(csv_file)

    # Create a dictionary mapping image names to labels
    image_label_map = dict(zip(data['isic_id'], data['diagnosis']))

    # Initialize a counter for images without a match
    unmatched_images = 0

    # Iterate through all files in the main folder
    for filename in os.listdir(main_folder):
        print(filename)
        if filename.endswith(".JPG") or filename.endswith(".jpg") or filename.endswith(".png"):
            # Extract the image name without the extension
            image_name = filename.split('.')[0]

            # Check if the image name is in the CSV file
            if image_name in image_label_map:
                # Get the label for the image
                label = image_label_map[image_name]

                # Check if the label has a corresponding subfolder
                if label in subfolders:
                    # Copy the image to the corresponding subfolder
                    shutil.copy(os.path.join(main_folder, filename), os.path.join(subfolders[label], filename))
                    print(f"Copied {filename} to {subfolders[label]}")
                else:
                    # Increment the counter for unmatched images
                    unmatched_images += 1
                    print(f"No subfolder for label {label} of image {filename}")
            else:
                # Increment the counter for unmatched images
                unmatched_images += 1
                print(f"No CSV match for image {filename}")

    return unmatched_images


def main():
    csv_file_path = '/path'  # Replace with your CSV file path
    main_folder_path = '/path'  # Replace with your main folder path
    subfolders_paths = {
        'nevus': '/path_nevus',
        'melanoma': '/path_melanoma',
        'basal cell carcinoma': '/path_bcc',
        'squamous cell carcinoma': '/path_scc',
        'actinic keratosis': '/path_ak',
        'vascular lesion': '/path_vl',
        'dermatofibroma': '/path_df',
        'pigmented benign keratosis': '/path_pbk'
    }

    unmatched_count = organize_images(csv_file_path, main_folder_path, subfolders_paths)
    print(f"Number of unmatched images: {unmatched_count}")


if __name__ == '__main__':
    main()
