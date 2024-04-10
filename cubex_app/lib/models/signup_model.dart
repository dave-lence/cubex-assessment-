class SignUpModel {
  String? username;
  String? password;
  String? email;
  String? phone;
  String? address;
  String? image;

  SignUpModel(
      {required this.username,
      required this.password,
      required this.email,
      required this.phone,
      required this.address,
      required this.image});

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'email': email,
      'phone': phone,
      'address': address,
      'image': image
    };
  }
}
