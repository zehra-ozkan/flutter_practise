class Friend {
  final String name;
  final String image;

  Friend({required this.name, required this.image});

  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      name: json['name']?.toString() ?? '',
      image: json['profile']?.toString() ?? '',
    );
  }
}
