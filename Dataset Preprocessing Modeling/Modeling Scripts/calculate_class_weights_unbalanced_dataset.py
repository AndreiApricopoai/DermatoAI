import numpy as np
from sklearn.utils.class_weight import compute_class_weight


def calculate_class_weights(class_labels, class_counts):
    classes = np.array(list(class_labels.values()))
    counts = np.array(list(class_counts.values()))
    weights = compute_class_weight(class_weight='balanced', classes=classes, y=counts)
    return {class_labels[label]: weight for label, weight in zip(class_labels.keys(), weights)}


def main():
    class_labels = {
        'actinic keratosis': 0,
        'basal cell carcinoma': 1,
        'dermatofibroma': 2,
        'melanoma': 3,
        'nevus': 4,
        'pigmented benign keratosis': 5,
        'squamous cell carcinoma': 6,
        'vascular lesion': 7
    }

    class_counts = {
        'vascular lesion': 3060,
        'squamous cell carcinoma': 3206,
        'pigmented benign keratosis': 4014,
        'nevus': 7737,
        'melanoma': 3915,
        'dermatofibroma': 3040,
        'basal cell carcinoma': 3110,
        'actinic keratosis': 3129
    }

    class_weights = calculate_class_weights(class_labels, class_counts)
    print("Class weights:", class_weights)
    # model.fit(x_train, y_train, class_weight=class_weights, ...)


if __name__ == '__main__':
    main()
