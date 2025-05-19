class WomanAdditionnalInfos {
  dynamic id;
  dynamic idPatient;
  dynamic lastDiagnosis;
  dynamic hasAllergies;
  dynamic otherChronicCondition;
  dynamic alreadyTakenMedicines;
  dynamic frequecySugarFood;
  dynamic diet;
  dynamic exerciseFrequency;
  dynamic smokingStatus;
  dynamic alcoholConsumption;
  dynamic goal;
  dynamic pregnancyStatus;

  WomanAdditionnalInfos({
    this.id,
    this.idPatient,
    this.lastDiagnosis,
    this.hasAllergies,
    this.otherChronicCondition,
    this.alreadyTakenMedicines,
    this.frequecySugarFood,
    this.diet,
    this.exerciseFrequency,
    this.smokingStatus,
    this.alcoholConsumption,
    this.goal,
    this.pregnancyStatus,
  });

  factory WomanAdditionnalInfos.fromJson(Map<String, dynamic> json) {
    return WomanAdditionnalInfos(
      id: json['id'],
      idPatient: json['id_patient'],
      lastDiagnosis: json['last_diagnosis'],
      hasAllergies: json['has_allergies'],
      otherChronicCondition: json['other_chronic_condition'],
      alreadyTakenMedicines: json['already_taken_medicines'],
      frequecySugarFood: json['frequecy_sugar_food'],
      diet: json['diet'],
      exerciseFrequency: json['exercise_frequency'],
      smokingStatus: json['smoking_status'],
      alcoholConsumption: json['alcohol_consumption'],
      goal: json['goal'],
      pregnancyStatus: json['pregnancy_status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_patient': idPatient,
      'last_diagnosis': lastDiagnosis,
      'has_allergies': hasAllergies,
      'other_chronic_condition': otherChronicCondition,
      'already_taken_medicines': alreadyTakenMedicines,
      'frequecy_sugar_food': frequecySugarFood,
      'diet': diet,
      'exercise_frequency': exerciseFrequency,
      'smoking_status': smokingStatus,
      'alcohol_consumption': alcoholConsumption,
      'goal': goal,
      'pregnancy_status': pregnancyStatus,
    };
  }
}
