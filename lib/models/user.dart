class User {
  int? id;
  String? username;
  String? password;

  User({this.id, this.username, this.password});

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'password': password,
      };

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        username = json['username'],
        password = json['password'];
}
