class Challenge {
  dynamic idChallenge;
  dynamic idAccountDoctor;
  dynamic title;
  dynamic description;
  dynamic startDate;
  dynamic endDate;

  Challenge({
    this.idChallenge,
    this.idAccountDoctor,
    this.title,
    this.description,
    this.startDate,
    this.endDate,
  });

  factory Challenge.fromJson(Map<String, dynamic> json) {
    return Challenge(
      idChallenge: json['id_challenge'],
      idAccountDoctor: json['id_account_doctor'],
      title: json['title'],
      description: json['description'],
      startDate: json['start_date'],
      endDate: json['end_date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_challenge': idChallenge,
      'id_account_doctor': idAccountDoctor,
      'title': title,
      'description': description,
      'start_date': startDate,
      'end_date': endDate,
    };
  }
}
