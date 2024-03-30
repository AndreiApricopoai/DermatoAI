import pandas as pd


def count_diagnosis_types(csv_file):
    data = pd.read_csv(csv_file)  # read the csv file
    diagnosis_counts = data['diagnosis'].value_counts()  # count the number of each diagnosis
    return diagnosis_counts  # return the counts


def main():
    csv_file_path = '/path'  # path to the csv file
    result = count_diagnosis_types(csv_file_path)  # call the function and store the result

    print("Diagnosis Counts:")
    print(result)  # print the result


if __name__ == '__main__':
    main()
