import os
import random
import shutil


def get_all_files(source_directory):
    all_files = []
    for f in os.listdir(source_directory):
        full_path = os.path.join(source_directory, f)
        if os.path.isfile(full_path):
            all_files.append(f)
    return all_files


def filter_image_files(files):
    image_extensions = ['.jpg', '.png', '.jpeg']
    image_files = []
    for f in files:
        if any(f.lower().endswith(ext) for ext in image_extensions):
            image_files.append(f)
    return image_files


def select_random_files(files, number_of_images):
    number_to_select = min(number_of_images, len(files))
    return random.sample(files, number_to_select)


def copy_files_to_destination(selected_files, source_directory, destination_directory):
    for i, filename in enumerate(selected_files, start=1):
        file_extension = os.path.splitext(filename)[1]
        new_name = f"copy_{i}{file_extension}"
        shutil.copy(os.path.join(source_directory, filename), os.path.join(destination_directory, new_name))
        print(f"Copied {filename} to {new_name}")


def copy_random_images(source_directory, destination_directory, number_of_images):
    all_files = get_all_files(source_directory)
    image_files = filter_image_files(all_files)
    selected_files = select_random_files(image_files, number_of_images)
    copy_files_to_destination(selected_files, source_directory, destination_directory)


if __name__ == '__main__':
    # Replace these paths with the paths to your directories
    source_directory_path = '/path/to/source/directory'
    destination_directory_path = '/path/to/destination/directory'

    # Specify the number of images you want to copy
    number_of_images_to_copy = 100

    # Call the function
    copy_random_images(source_directory_path, destination_directory_path, number_of_images_to_copy)
