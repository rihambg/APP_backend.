class Hospital {
  dynamic idHospital;
  dynamic nameHospital;
  dynamic postalCode;
  dynamic street;
  dynamic idLocation;

  Hospital({
    this.idHospital,
    this.nameHospital,
    this.postalCode,
    this.street,
    this.idLocation,
  });

  factory Hospital.fromJson(Map<String, dynamic> json) {
    return Hospital(
      idHospital: json['id_hospital'],
      nameHospital: json['name_hospital'],
      postalCode: json['postal_code'],
      street: json['street'],
      idLocation: json['id_location'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_hospital': idHospital,
      'name_hospital': nameHospital,
      'postal_code': postalCode,
      'street': street,
      'id_location': idLocation,
    };
  }
}
