class Message {
  dynamic idMessage;
  dynamic idContact;
  dynamic messageText;
  dynamic dateTime;
  dynamic messageStatus;

  Message({
    this.idMessage,
    this.idContact,
    this.messageText,
    this.dateTime,
    this.messageStatus,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      idMessage: json['id_message'],
      idContact: json['id_contact'],
      messageText: json['message_text'],
      dateTime: json['date_time'],
      messageStatus: json['message_status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_message': idMessage,
      'id_contact': idContact,
      'message_text': messageText,
      'date_time': dateTime,
      'message_status': messageStatus,
    };
  }
}
