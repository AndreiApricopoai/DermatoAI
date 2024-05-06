class PredictionStatus:
    PENDING = "pending"
    PROCESSED = "processed"
    FAILED = "failed"


class DiagnosisType:
    CANCER = "cancer"
    NOT_CANCER = "not_cancer"
    POTENTIALLY_CANCER = "potentially_cancer"


CLASS_INDICES_NAMES = {
    0: 'actinic keratosis',
    1: 'basal cell carcinoma',
    2: 'dermatofibroma',
    3: 'melanoma',
    4: 'nevus',
    5: 'pigmented benign keratosis',
    6: 'squamous cell carcinoma',
    7: 'vascular lesion'
}


UNHEALTHY_DIAGNOSIS_INFO = [
    {
        'name': CLASS_INDICES_NAMES[0],
        'code': 0,
        'type': DiagnosisType.POTENTIALLY_CANCER
    },
    {
        'name': CLASS_INDICES_NAMES[1],
        'code': 1,
        'type': DiagnosisType.CANCER
    },
    {
        'name': CLASS_INDICES_NAMES[2],
        'code': 2,
        'type': DiagnosisType.NOT_CANCER
    },
    {
        'name': CLASS_INDICES_NAMES[3],
        'code': 3,
        'type': DiagnosisType.CANCER
    },
    {
        'name': CLASS_INDICES_NAMES[4],
        'code': 4,
        'type': DiagnosisType.NOT_CANCER
    },
    {
        'name': CLASS_INDICES_NAMES[5],
        'code': 5,
        'type': DiagnosisType.NOT_CANCER
    },
    {
        'name': CLASS_INDICES_NAMES[6],
        'code': 6,
        'type': DiagnosisType.CANCER
    },
    {
        'name': CLASS_INDICES_NAMES[7],
        'code': 7,
        'type': DiagnosisType.POTENTIALLY_CANCER
    }
]


HEALTHY_DIAGNOSIS_INFO = {
    'name': 'healthy',
    'code': 8,
    'type': DiagnosisType.NOT_CANCER
}
