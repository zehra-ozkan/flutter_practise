import 'dart:convert';
import 'dart:typed_data';

class Friend {
  final String name;
  final Uint8List? image;

  Friend({required this.name, required this.image});

  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      name: json['name']?.toString() ?? '',
      image: json["profile"] == ""
          ? null
          : base64Decode(json['profile']!.toString()),
    );
  }
}
