class ChallengeParticipant {
  dynamic idChallenge;
  dynamic idAccountPatient;

  ChallengeParticipant({
    this.idChallenge,
    this.idAccountPatient,
  });

  factory ChallengeParticipant.fromJson(Map<String, dynamic> json) {
    return ChallengeParticipant(
      idChallenge: json['id_challenge'],
      idAccountPatient: json['id_account_patient'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_challenge': idChallenge,
      'id_account_patient': idAccountPatient,
    };
  }
}
