class LoginRequest {
  String mobile;
  String password;

  LoginRequest({this.mobile, this.password});

  LoginRequest.fromJson(Map<String, dynamic> json) {
    mobile = json['mobile'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mobile'] = this.mobile;
    data['password'] = this.password;
    return data;
  }
}
