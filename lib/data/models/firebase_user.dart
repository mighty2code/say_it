import 'dart:convert';

class FirebaseUser {
  String? id;
  String? name;
  String? username;
  String? email;
  String? password;

  FirebaseUser({
    this.id,
    this.name,
    this.username,
    this.email,
    this.password,
  });

  factory FirebaseUser.fromJson(Map<String, dynamic> json) {
    return FirebaseUser(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      username: json['username']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      password: json['password']?.toString() ?? '',
    );
  }

  factory FirebaseUser.fromRawJson(String rawJson) => FirebaseUser.fromJson(jsonDecode(rawJson));

  String toRawJson() => jsonEncode(toJson());

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'email': email,
      // 'password': password,
    };
  }
}
