class Disease {
  final String name;
  final String description;
  final String origin;
  final String severity;
  final String treatment;
  final String lifestyleUpgrades;

  Disease({
    required this.name,
    required this.description,
    required this.origin,
    required this.severity,
    required this.treatment,
    required this.lifestyleUpgrades,
  });
}

final List<Disease> diseases = [
  Disease(
    name: 'Vascular Lesion',
    description: 'Vascular lesions are abnormal growths or malformations of blood vessels. These can include conditions like hemangiomas, port-wine stains, and spider veins.',
    origin: 'They are often congenital (present at birth) but can also develop later in life due to factors like sun exposure or aging.',
    severity: 'They can be benign (non-cancerous) but sometimes may indicate or turn into cancer.',
    treatment: 'Treatments include laser therapy, sclerotherapy, and, in some cases, surgical removal.',
    lifestyleUpgrades: 'Avoid excessive sun exposure, maintain a healthy weight, and consider regular check-ups with a dermatologist.',
  ),
  Disease(
    name: 'Squamous Cell Carcinoma',
    description: 'Squamous cell carcinoma (SCC) is a type of skin cancer that arises from squamous cells in the epidermis.',
    origin: 'It is commonly caused by prolonged exposure to ultraviolet (UV) radiation from the sun or tanning beds.',
    severity: 'SCC is malignant and can spread to other parts of the body if not treated promptly.',
    treatment: 'Treatments include surgical excision, Mohs surgery, radiation therapy, and topical or systemic chemotherapy.',
    lifestyleUpgrades: 'Regular use of sunscreen, wearing protective clothing, and avoiding tanning beds can reduce risk. Regular skin checks are essential.',
  ),
  Disease(
    name: 'Pigmented Benign Keratosis',
    description: 'Also known as seborrheic keratosis, these are non-cancerous growths that appear as brown, black, or light tan spots on the skin.',
    origin: 'The exact cause is unknown, but they tend to run in families and increase with age.',
    severity: 'These are benign and generally harmless.',
    treatment: 'Treatment is often not necessary but can include cryotherapy, curettage, or laser treatment for cosmetic reasons.',
    lifestyleUpgrades: 'Maintain good skin hygiene and avoid scratching or picking at the lesions.',
  ),
  Disease(
    name: 'Nevus (Mole)',
    description: 'A nevus is a benign growth on the skin formed by a cluster of melanocytes, the cells that produce pigment.',
    origin: 'Moles can be congenital or develop over time, often due to genetic factors and sun exposure.',
    severity: 'Most moles are benign, but changes in their appearance can sometimes indicate melanoma, a type of skin cancer.',
    treatment: 'Monitoring for changes, surgical removal if there are suspicious changes.',
    lifestyleUpgrades: 'Regular skin self-exams and professional check-ups, using sunscreen to protect skin from UV damage.',
  ),
  Disease(
    name: 'Melanoma',
    description: 'Melanoma is a serious form of skin cancer that originates in the melanocytes.',
    origin: 'It is strongly linked to UV radiation exposure from the sun or tanning beds.',
    severity: 'Highly malignant and can spread rapidly to other parts of the body.',
    treatment: 'Treatment includes surgical removal, immunotherapy, targeted therapy, chemotherapy, and radiation therapy.',
    lifestyleUpgrades: 'Avoid excessive sun exposure, use broad-spectrum sunscreen, wear protective clothing, and perform regular skin self-exams.',
  ),
  Disease(
    name: 'Dermatofibroma',
    description: 'Dermatofibromas are benign, fibrous nodules that usually occur on the skin of the lower legs.',
    origin: 'The exact cause is unknown, but they may develop in response to minor skin injuries or insect bites.',
    severity: 'Benign and generally harmless.',
    treatment: 'Often no treatment is necessary, but options include cryotherapy, laser treatment, or surgical excision for cosmetic reasons or if they are bothersome.',
    lifestyleUpgrades: 'Maintain good skin care and avoid scratching or injuring the skin.',
  ),
  Disease(
    name: 'Basal Cell Carcinoma',
    description: 'Basal cell carcinoma (BCC) is a common form of skin cancer that arises from the basal cells in the epidermis.',
    origin: 'Mainly caused by prolonged UV exposure.',
    severity: 'It is malignant but typically grows slowly and is less likely to spread compared to other skin cancers.',
    treatment: 'Treatments include surgical excision, Mohs surgery, cryotherapy, and topical treatments.',
    lifestyleUpgrades: 'Regular use of sunscreen, avoiding peak sun hours, wearing protective clothing, and regular skin checks.',
  ),
  Disease(
    name: 'Actinic Keratosis',
    description: 'Actinic keratosis (AK) is a rough, scaly patch on the skin caused by years of sun exposure.',
    origin: 'Caused by long-term exposure to UV radiation.',
    severity: 'Benign but can potentially turn into squamous cell carcinoma over time.',
    treatment: 'Treatments include cryotherapy, topical medications, photodynamic therapy, and laser therapy.',
    lifestyleUpgrades: 'Use sunscreen daily, wear protective clothing, and avoid tanning beds.',
  ),
];
