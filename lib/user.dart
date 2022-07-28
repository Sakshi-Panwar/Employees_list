import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String name;
  final DateTime joining;

  User({
    required this.name,
    required this.joining,
  });
  Map<String, dynamic> toJson() => {'name': name, 'joining': joining};
  static User fromJson(Map<String, dynamic> json) => User(
      name: json['name'], joining: (json['joining'] as Timestamp).toDate());
}
