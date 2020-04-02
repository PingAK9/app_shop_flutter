class AccountToken {
  String accessToken;
  String tokenType;
  String expiresIn;
  String userName;
  String issued;
  String expires;

  AccountToken(
      {this.accessToken,
        this.tokenType,
        this.expiresIn,
        this.userName,
        this.issued,
        this.expires});

  AccountToken.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
    tokenType = json['token_type'];
    expiresIn = json['expires_in'];
    userName = json['userName'];
    issued = json['.issued'];
    expires = json['.expires'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['access_token'] = this.accessToken;
    data['token_type'] = this.tokenType;
    data['expires_in'] = this.expiresIn;
    data['userName'] = this.userName;
    data['.issued'] = this.issued;
    data['.expires'] = this.expires;
    return data;
  }
}