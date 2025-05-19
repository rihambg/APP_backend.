class Medicals {
  dynamic idMedical;
  dynamic medicalType;
  dynamic medicalDose;
  dynamic medicalName;
  dynamic medicalDescription;

  Medicals({
    this.idMedical,
    this.medicalType,
    this.medicalDose,
    this.medicalName,
    this.medicalDescription,
  });

  factory Medicals.fromJson(Map<String, dynamic> json) {
    return Medicals(
      idMedical: json['id_medical'],
      medicalType: json['medical_type'],
      medicalDose: json['medical_dose'],
      medicalName: json['medical_name'],
      medicalDescription: json['medical_description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_medical': idMedical,
      'medical_type': medicalType,
      'medical_dose': medicalDose,
      'medical_name': medicalName,
      'medical_description': medicalDescription,
    };
  }
}
