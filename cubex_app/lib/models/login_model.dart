class LoginModel {
  String? username;
  String? password;

  LoginModel({
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {'username': username, 'password': password};
  }
}
