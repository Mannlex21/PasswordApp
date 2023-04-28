class PasswordModel {
  final int? id;
  final String name;
  final String password;
  final String description;
  final String url;
  PasswordModel(
      {this.id,
      required this.name,
      required this.password,
      required this.description,
      required this.url});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'password': password,
      'description': description,
      'url': url
    };
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'password': password,
        'description': description,
        'url': url,
      };

  PasswordModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        password = json['password'],
        description = json['description'],
        url = json['url'];
}
