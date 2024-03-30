import pandas as pd


def load_and_modify_csv(csv_file):
    # Load the CSV file
    df = pd.read_csv(csv_file)
    # Modify the 'isic_id' column
    df['isic_id'] = df['isic_id'].apply(lambda x: x + '.JPG')
    return df


def save_csv(df, csv_file):
    # Save the changes to the same CSV file
    df.to_csv(csv_file, index=False)


def main():
    csv_file = '/'  # Specify the path to your CSV file here
    df = load_and_modify_csv(csv_file)  # Load and modify the CSV file
    save_csv(df, csv_file)  # Save the modified CSV file


if __name__ == '__main__':
    main()
