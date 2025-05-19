class User {
  dynamic idProfile;
  dynamic idAccount;
  dynamic firstName;
  dynamic lastName;
  dynamic middleName;
  dynamic sex;
  dynamic publicPhoneNumber;
  dynamic publicEmail;
  dynamic bloodType;
  dynamic dateBirth;
  dynamic weight;
  dynamic height;
  dynamic diabeteType;
  dynamic speciality;
  dynamic locationId;
  dynamic bio;
  dynamic idHospital;
  dynamic professionalId;

  User({
    this.idProfile,
    this.idAccount,
    this.firstName,
    this.lastName,
    this.middleName,
    this.sex,
    this.publicPhoneNumber,
    this.publicEmail,
    this.bloodType,
    this.dateBirth,
    this.weight,
    this.height,
    this.diabeteType,
    this.speciality,
    this.locationId,
    this.bio,
    this.idHospital,
    this.professionalId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      idProfile: json['id_profile'],
      idAccount: json['id_account'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      middleName: json['middle_name'],
      sex: json['sex'],
      publicPhoneNumber: json['public_phone_number'],
      publicEmail: json['public_email'],
      bloodType: json['blood_type'],
      dateBirth: json['date_birth'],
      weight: json['weight'],
      height: json['height'],
      diabeteType: json['diabete_type'],
      speciality: json['speciality'],
      locationId: json['location_id'],
      bio: json['bio'],
      idHospital: json['id_hospital'],
      professionalId: json['professional_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_profile': idProfile,
      'id_account': idAccount,
      'first_name': firstName,
      'last_name': lastName,
      'middle_name': middleName,
      'sex': sex,
      'public_phone_number': publicPhoneNumber,
      'public_email': publicEmail,
      'blood_type': bloodType,
      'date_birth': dateBirth,
      'weight': weight,
      'height': height,
      'diabete_type': diabeteType,
      'speciality': speciality,
      'location_id': locationId,
      'bio': bio,
      'id_hospital': idHospital,
      'professional_id': professionalId,
    };
  }
}
