import 'package:password_manager/screens/passwords.dart';

class PasswordModel {
  final String? name;
  final String? password;
  final String? description;
  final String? url;
  PasswordModel(this.name, this.password, this.description, this.url);

  PasswordModel.fromJson(Map<String?, dynamic> json)
      : name = json['name'],
        password = json['password'],
        description = json['description'],
        url = json['url'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'password': password,
        'description': description,
        'url': url
      };
}
