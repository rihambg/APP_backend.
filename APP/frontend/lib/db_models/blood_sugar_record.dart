class BloodSugarRecord {
  dynamic idRecord;
  dynamic idAccountPatient;
  dynamic dateTime;
  dynamic level;
  dynamic recordType;

  BloodSugarRecord({
    this.idRecord,
    this.idAccountPatient,
    this.dateTime,
    this.level,
    this.recordType,
  });

  factory BloodSugarRecord.fromJson(Map<String, dynamic> json) {
    return BloodSugarRecord(
      idRecord: json['id_record'],
      idAccountPatient: json['id_account_patient'],
      dateTime: json['date_time'],
      level: json['level'],
      recordType: json['record_type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_record': idRecord,
      'id_account_patient': idAccountPatient,
      'date_time': dateTime,
      'level': level,
      'record_type': recordType,
    };
  }
}
