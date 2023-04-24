class PasswordItem {
  final int? id;
  final String name;
  final String password;
  final String description;
  final String url;
  PasswordItem(
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
}
