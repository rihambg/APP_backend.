class Contact {
  dynamic idContact;
  dynamic idAccountSender;
  dynamic idAccountReciver;
  dynamic contactStatus;
  dynamic isEmergencyContact;

  Contact({
    this.idContact,
    this.idAccountSender,
    this.idAccountReciver,
    this.contactStatus,
    this.isEmergencyContact,
  });

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      idContact: json['id_contact'],
      idAccountSender: json['id_account_sender'],
      idAccountReciver: json['id_account_reciver'],
      contactStatus: json['contact_status'],
      isEmergencyContact: json['is_emergency_contact'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_contact': idContact,
      'id_account_sender': idAccountSender,
      'id_account_reciver': idAccountReciver,
      'contact_status': contactStatus,
      'is_emergency_contact': isEmergencyContact,
    };
  }
}
