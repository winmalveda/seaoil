class Data {
  int id;
  String accessToken;
  String refreshToken;
  int userId;
  String expiresAt;
  String updatedAt;
  String createdAt;
  String userUuid;
  String code;
  String message;

  Data(
      {this.id,
      this.accessToken,
      this.refreshToken,
      this.userId,
      this.expiresAt,
      this.updatedAt,
      this.createdAt,
      this.userUuid,
      this.code,
      this.message});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    accessToken = json['accessToken'];
    refreshToken = json['refreshToken'];
    userId = json['userId'];
    expiresAt = json['expiresAt'];
    updatedAt = json['updatedAt'];
    createdAt = json['createdAt'];
    userUuid = json['userUuid'];
    code = json['code'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['accessToken'] = this.accessToken;
    data['refreshToken'] = this.refreshToken;
    data['userId'] = this.userId;
    data['expiresAt'] = this.expiresAt;
    data['updatedAt'] = this.updatedAt;
    data['createdAt'] = this.createdAt;
    data['userUuid'] = this.userUuid;
    data['code'] = this.code;
    data['message'] = this.message;
    return data;
  }
}
