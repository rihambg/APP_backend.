class DoctorSignupModel {
  String? gender;
  String? dateOfBirth;
  String? speciality;
  String? location;
  String? phoneNumber;
  String? experience;
  String? professionalId;
  String? documentName;

  DoctorSignupModel({
    this.gender,
    this.dateOfBirth,
    this.speciality,
    this.location,
    this.phoneNumber,
    this.experience,
    this.professionalId,
    this.documentName,
  });

  /// Factory to initialize from step 1 (basic info)
  factory DoctorSignupModel.fromStep1({
    required String gender,
    required String dateOfBirth,
    required String speciality,
    required String location,
  }) {
    return DoctorSignupModel(
      gender: gender,
      dateOfBirth: dateOfBirth,
      speciality: speciality,
      location: location,
    );
  }

  /// Update model with step 2 (final step data)
  void updateFromStep2({
    required String phoneNumber,
    required String experience,
    required String professionalId,
    required String documentName,
  }) {
    this.phoneNumber = phoneNumber;
    this.experience = experience;
    this.professionalId = professionalId;
    this.documentName = documentName;
  }

  Map<String, dynamic> toJson() {
    return {
      'gender': gender,
      'date_of_birth': dateOfBirth,
      'speciality': speciality,
      'location': location,
      'phone_number': phoneNumber,
      'experience': experience,
      'professional_id': professionalId,
      'document_name': documentName,
    };
  }
}
