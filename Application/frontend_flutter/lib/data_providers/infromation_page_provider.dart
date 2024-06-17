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
    description:
        'Vascular lesions are abnormal growths or malformations of blood vessels. These can include conditions like hemangiomas, port-wine stains, and spider veins. Vascular lesions can vary greatly in size and appearance, and can occur anywhere on the body. They may be present at birth or develop later in life.',
    origin:
        'Vascular lesions are often congenital, meaning they are present at birth. However, they can also develop later in life due to factors such as sun exposure, aging, or hormonal changes.',
    severity:
        'Most vascular lesions are benign (non-cancerous), but some types can indicate or turn into cancer. It is important to monitor any changes in size, color, or shape, and consult a healthcare provider if any changes are observed.',
    treatment:
        'Treatments for vascular lesions can vary based on the type and severity of the lesion. Options include laser therapy to reduce the appearance of the lesion, sclerotherapy to shrink the lesion, and surgical removal for more severe cases.',
    lifestyleUpgrades:
        'To manage vascular lesions, avoid excessive sun exposure, maintain a healthy weight, and consider regular check-ups with a dermatologist. Protecting the skin from the sun and avoiding trauma to the area can also help prevent the development of new lesions.',
  ),
  Disease(
    name: 'Squamous Cell Carcinoma',
    description:
        'Squamous cell carcinoma (SCC) is a type of skin cancer that arises from squamous cells in the epidermis. It is the second most common form of skin cancer. SCC often appears as a red, scaly patch, open sore, or wart-like growth that may crust or bleed.',
    origin:
        'SCC is commonly caused by prolonged exposure to ultraviolet (UV) radiation from the sun or tanning beds. Other risk factors include a weakened immune system, exposure to certain chemicals, and a history of skin injuries or burns.',
    severity:
        'SCC is malignant and can spread to other parts of the body if not treated promptly. Early detection and treatment are crucial to prevent metastasis. SCC can invade local tissues and organs, leading to significant health issues.',
    treatment:
        'Treatments for SCC include surgical excision to remove the cancerous tissue, Mohs surgery for precise removal, radiation therapy for advanced cases, and topical or systemic chemotherapy. Follow-up care is essential to monitor for recurrence.',
    lifestyleUpgrades:
        'To reduce the risk of SCC, use sunscreen regularly, wear protective clothing, and avoid tanning beds. Conduct regular skin self-exams and schedule professional skin checks. Avoid peak sun hours and seek shade when outdoors.',
  ),
  Disease(
    name: 'Pigmented Benign Keratosis',
    description:
        'Also known as seborrheic keratosis, these are non-cancerous growths that appear as brown, black, or light tan spots on the skin. They are often slightly raised and have a waxy or scaly appearance. These growths are common in older adults.',
    origin:
        'The exact cause of pigmented benign keratosis is unknown, but they tend to run in families and increase with age. They are not caused by sun exposure but may appear more frequently in sun-exposed areas.',
    severity:
        'These growths are benign and generally harmless. They do not turn into cancer and usually do not require treatment unless they become irritated or are cosmetically undesirable.',
    treatment:
        'Treatment is often not necessary but can include cryotherapy (freezing the growth), curettage (scraping it off), or laser treatment for cosmetic reasons. It is important to have any new or changing growths evaluated by a healthcare provider.',
    lifestyleUpgrades:
        'Maintain good skin hygiene and avoid scratching or picking at the lesions to prevent irritation. Regular skin exams can help distinguish seborrheic keratosis from other skin conditions that may require treatment.',
  ),
  Disease(
    name: 'Nevus (Mole)',
    description:
        'A nevus is a benign growth on the skin formed by a cluster of melanocytes, the cells that produce pigment. Moles can vary in color from flesh-toned to dark brown or black and can be flat or raised.',
    origin:
        'Moles can be congenital (present at birth) or develop over time, often due to genetic factors and sun exposure. Most people have between 10 and 40 moles, which may change in appearance over the years.',
    severity:
        'Most moles are benign, but changes in their appearance can sometimes indicate melanoma, a type of skin cancer. Warning signs include asymmetry, irregular borders, multiple colors, and changes in size or shape.',
    treatment:
        'Monitoring for changes is essential. If a mole shows suspicious changes, a healthcare provider may perform a biopsy or surgical removal. Regular skin exams can help detect melanoma early when it is most treatable.',
    lifestyleUpgrades:
        'Regular skin self-exams and professional check-ups are important. Use sunscreen to protect skin from UV damage, and avoid tanning beds. Report any changes in moles to a healthcare provider promptly.',
  ),
  Disease(
    name: 'Melanoma',
    description:
        'Melanoma is a serious form of skin cancer that originates in the melanocytes. It is the most dangerous form of skin cancer because it is more likely to spread to other parts of the body if not detected early.',
    origin:
        'Melanoma is strongly linked to UV radiation exposure from the sun or tanning beds. Genetic factors and a history of severe sunburns also increase the risk of developing melanoma.',
    severity:
        'Melanoma is highly malignant and can spread rapidly to other parts of the body. Early detection and treatment are crucial. Symptoms include new, unusual growths or changes in existing moles, such as asymmetry, irregular borders, multiple colors, and a diameter larger than 6mm.',
    treatment:
        'Treatment includes surgical removal, immunotherapy to boost the body’s immune response, targeted therapy to attack specific cancer cells, chemotherapy, and radiation therapy. Follow-up care is essential to monitor for recurrence and manage any side effects of treatment.',
    lifestyleUpgrades:
        'Avoid excessive sun exposure, use broad-spectrum sunscreen with an SPF of 30 or higher, wear protective clothing, and perform regular skin self-exams. Seek shade during peak sun hours and avoid tanning beds.',
  ),
  Disease(
    name: 'Dermatofibroma',
    description:
        'Dermatofibromas are benign, fibrous nodules that usually occur on the skin of the lower legs. They are firm, raised, and often feel like a small button under the skin.',
    origin:
        'The exact cause of dermatofibromas is unknown, but they may develop in response to minor skin injuries, insect bites, or other trauma. They are more common in women than men.',
    severity:
        'Dermatofibromas are benign and generally harmless. They do not turn into cancer and usually do not require treatment unless they become irritated or cosmetically undesirable.',
    treatment:
        'Often no treatment is necessary, but options include cryotherapy, laser treatment, or surgical excision for cosmetic reasons or if they are bothersome. It is important to have any new or changing growths evaluated by a healthcare provider.',
    lifestyleUpgrades:
        'Maintain good skin care and avoid scratching or injuring the skin. Regular skin exams can help distinguish dermatofibromas from other skin conditions that may require treatment.',
  ),
  Disease(
    name: 'Basal Cell Carcinoma',
    description:
        'Basal cell carcinoma (BCC) is a common form of skin cancer that arises from the basal cells in the epidermis. It often appears as a pearly or waxy bump, a flat, flesh-colored or brown scar-like lesion, or a bleeding or scabbing sore that heals and returns.',
    origin:
        'BCC is mainly caused by prolonged UV exposure from the sun or tanning beds. It is more common in fair-skinned individuals who burn easily.',
    severity:
        'BCC is malignant but typically grows slowly and is less likely to spread compared to other skin cancers. However, it can cause significant local damage and disfigurement if not treated promptly.',
    treatment:
        'Treatments include surgical excision, Mohs surgery for precise removal, cryotherapy, topical treatments, and radiation therapy for advanced cases. Follow-up care is essential to monitor for recurrence.',
    lifestyleUpgrades:
        'Regular use of sunscreen, avoiding peak sun hours, wearing protective clothing, and regular skin checks are important preventive measures. Avoiding tanning beds can also reduce the risk of developing BCC.',
  ),
  Disease(
    name: 'Actinic Keratosis',
    description:
        'Actinic keratosis (AK) is a rough, scaly patch on the skin caused by years of sun exposure. AK is considered a precancerous condition because it can potentially develop into squamous cell carcinoma if left untreated.',
    origin:
        'AK is caused by long-term exposure to UV radiation from the sun or tanning beds. It is more common in fair-skinned individuals and those with a history of sunburns.',
    severity:
        'AK is benign but can potentially turn into squamous cell carcinoma over time. It is important to monitor and treat AK to prevent progression to skin cancer.',
    treatment:
        'Treatments include cryotherapy to freeze the lesion, topical medications to destroy the abnormal cells, photodynamic therapy to use light and a photosensitizing agent to kill the cells, and laser therapy. Regular follow-up is important to monitor for new lesions.',
    lifestyleUpgrades:
        'Use sunscreen daily, wear protective clothing, and avoid tanning beds. Regular skin exams can help detect and treat AK early. Protecting the skin from further sun damage is crucial.',
  ),
];
