class Appointment {
  dynamic idAppointement;
  dynamic appointementType;
  dynamic dateTime;
  dynamic doctorId;
  dynamic patientId;
  dynamic appointementStatus;

  Appointment({
    this.idAppointement,
    this.appointementType,
    this.dateTime,
    this.doctorId,
    this.patientId,
    this.appointementStatus,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      idAppointement: json['id_appointement'],
      appointementType: json['appointement_type'],
      dateTime: json['date_time'],
      doctorId: json['doctor_id'],
      patientId: json['patient_id'],
      appointementStatus: json['appointement_status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_appointement': idAppointement,
      'appointement_type': appointementType,
      'date_time': dateTime,
      'doctor_id': doctorId,
      'patient_id': patientId,
      'appointement_status': appointementStatus,
    };
  }
}
