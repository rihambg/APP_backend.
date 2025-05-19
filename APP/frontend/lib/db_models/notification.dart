class Notification {
  dynamic idNotification;
  dynamic idUser;
  dynamic typeNotification;
  dynamic message;
  dynamic timestamp;

  Notification({
    this.idNotification,
    this.idUser,
    this.typeNotification,
    this.message,
    this.timestamp,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      idNotification: json['id_notification'],
      idUser: json['id_user'],
      typeNotification: json['type_notification'],
      message: json['message'],
      timestamp: json['timestamp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_notification': idNotification,
      'id_user': idUser,
      'type_notification': typeNotification,
      'message': message,
      'timestamp': timestamp,
    };
  }
}
