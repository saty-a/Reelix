class Errors {
  late List<String>? email;
  late List<String>? mobile;
  late List<String>? userId;

  Errors({
    this.email,
    this.mobile,
    this.userId,
  });

  Errors.fromJson(Map<String, dynamic> json) {
    email = json['email']?.cast<String>();
    mobile = json['mobile']?.cast<String>();
    userId = json['userId']?.cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['mobile'] = mobile;
    data['userId'] = userId;
    return data;
  }
}
