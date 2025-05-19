class PerspectionMedical {
  dynamic idPerspection;
  dynamic idMedical;
  dynamic frequency;
  dynamic dateStart;
  dynamic dateEnd;

  PerspectionMedical({
    this.idPerspection,
    this.idMedical,
    this.frequency,
    this.dateStart,
    this.dateEnd,
  });

  factory PerspectionMedical.fromJson(Map<String, dynamic> json) {
    return PerspectionMedical(
      idPerspection: json['id_perspection'],
      idMedical: json['id_medical'],
      frequency: json['frequency'],
      dateStart: json['date_start'],
      dateEnd: json['date_end'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_perspection': idPerspection,
      'id_medical': idMedical,
      'frequency': frequency,
      'date_start': dateStart,
      'date_end': dateEnd,
    };
  }
}
