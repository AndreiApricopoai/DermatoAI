import os
import random
import pandas as pd


def delete_images(image_folder_path, number_of_images_to_delete):
    all_image_files = [f for f in os.listdir(image_folder_path) if f.endswith('.JPG')]
    images_to_delete = random.sample(all_image_files, number_of_images_to_delete)

    for image_file in images_to_delete:
        os.remove(os.path.join(image_folder_path, image_file))

    return images_to_delete


# def update_csv(csv_file_path, images_to_delete):
#     df = pd.read_csv(csv_file_path)
#     df['filename_without_ext'] = df['isic_id'].apply(lambda x: x.split('.')[0])
#     images_to_delete = [img.split('.')[0] for img in images_to_delete]
#     df = df[~df['filename_without_ext'].isin(images_to_delete)]
#     df.drop('filename_without_ext', axis=1, inplace=True)
#     df.to_csv(csv_file_path, index=False)

def main():
    image_folder_path = '/path'  # Set the path to the image folder
    number_of_images_to_delete = 100  # Set the number of images to delete

    images_deleted = delete_images(image_folder_path, number_of_images_to_delete)  # Call the function to delete images
    print(f"Deleted {len(images_deleted)} images.")  # Print the number of images deleted

    # csv_file_path = '/path'  # Set the path to your CSV file
    # update_csv(csv_file_path, images_deleted)
    # print(f"Updated the CSV file at {csv_file_path}.")


if __name__ == '__main__':
    main()
