import 'dart:convert';
import 'dart:typed_data';

class Post {
  final String text;
  final String postUserName;
  final Uint8List postImage; //this is never null
  final DateTime postDate;

  Post({
    required this.postUserName,
    required this.postDate,
    required this.text,
    required this.postImage,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      postUserName: json['postUserName'],
      text: json['postText']?.toString() ?? '',
      postImage: base64Decode(json['postPhoto']!.toString()),
      postDate: DateTime.parse(
        json['postDate'],
      ), //posts are guaranteed to have an image
    );
  }
}
