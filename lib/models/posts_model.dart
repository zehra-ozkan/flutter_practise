import 'dart:convert';
import 'dart:typed_data';

class Post {
  final String text;
  final String postUserName;
  final Uint8List postImage; //this is never null
  final Uint8List? postUserImage; //this can be null
  final DateTime postDate;

  Post({
    required this.postUserName,
    required this.postDate,
    required this.text,
    required this.postImage,
    this.postUserImage,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      postUserName: json['postUserName'],
      postUserImage: json['postUserPhoto'] != ""
          ? base64Decode(json['postUserPhoto']!.toString())
          : null,
      text: json['postText']?.toString() ?? '',
      postImage: base64Decode(json['postPhoto']!.toString()),
      postDate: DateTime.parse(
        json['postDate'],
      ), //posts are guaranteed to have an image
    );
  }
}
