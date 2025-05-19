class Perspection {
  dynamic idPerspection;
  dynamic idAccountDoctor;
  dynamic idAppointement;
  dynamic idAccountPatient;
  dynamic description;
  dynamic code;
  dynamic dateTime;

  Perspection({
    this.idPerspection,
    this.idAccountDoctor,
    this.idAppointement,
    this.idAccountPatient,
    this.description,
    this.code,
    this.dateTime,
  });

  factory Perspection.fromJson(Map<String, dynamic> json) {
    return Perspection(
      idPerspection: json['id_perspection'],
      idAccountDoctor: json['id_account_doctor'],
      idAppointement: json['id_appointement'],
      idAccountPatient: json['id_account_patient'],
      description: json['description'],
      code: json['code'],
      dateTime: json['date_time'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_perspection': idPerspection,
      'id_account_doctor': idAccountDoctor,
      'id_appointement': idAppointement,
      'id_account_patient': idAccountPatient,
      'description': description,
      'code': code,
      'date_time': dateTime,
    };
  }
}
