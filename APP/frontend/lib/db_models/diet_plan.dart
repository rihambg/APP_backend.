class DietPlan {
  dynamic idPlan;
  dynamic idAccountDoctor;
  dynamic idAccountPatient;
  dynamic title;
  dynamic description;
  dynamic startDate;
  dynamic endDate;
  dynamic idChallenge;

  DietPlan({
    this.idPlan,
    this.idAccountDoctor,
    this.idAccountPatient,
    this.title,
    this.description,
    this.startDate,
    this.endDate,
    this.idChallenge,
  });

  factory DietPlan.fromJson(Map<String, dynamic> json) {
    return DietPlan(
      idPlan: json['id_plan'],
      idAccountDoctor: json['id_account_doctor'],
      idAccountPatient: json['id_account_patient'],
      title: json['title'],
      description: json['description'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      idChallenge: json['id_challenge'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_plan': idPlan,
      'id_account_doctor': idAccountDoctor,
      'id_account_patient': idAccountPatient,
      'title': title,
      'description': description,
      'start_date': startDate,
      'end_date': endDate,
      'id_challenge': idChallenge,
    };
  }
}
