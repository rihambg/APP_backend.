class Account {
  dynamic accountId;
  dynamic userName;
  dynamic email;
  dynamic phoneNumber;
  dynamic password;
  dynamic accountType;
  dynamic status;

  Account({
    this.accountId,
    this.userName,
    this.email,
    this.phoneNumber,
    this.password,
    this.accountType,
    this.status,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      accountId: json['account_id'],
      userName: json['user_name'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      password: json['password'],
      accountType: json['account_type'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'account_id': accountId,
      'user_name': userName,
      'email': email,
      'phone_number': phoneNumber,
      'password': password,
      'account_type': accountType,
      'status': status,
    };
  }
}
