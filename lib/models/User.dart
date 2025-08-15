class User {
  final int userId;
  final String userName;
  final DateTime birthday;
  final String password;

  User({
    required this.birthday,
    required this.password,
    required this.userId,
    required this.userName,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'],
      userName: json['user_name'],
      birthday: json['birthday'],
      password: json['user_password'],
    );
  }

  Map<String, dynamic> toJson() => {
    'user_id': userId,
    'user_name': userName,
    'user_password': password,
    'birthday': birthday,
  };
}
