import 'package:flutter/material.dart';

class Reminder {
  final int? id;
  final String title;
  final String subtitle;
  final String category;
  final String time;

  Reminder({
    this.id,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.time,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'category': category,
      'time': time,
    };
  }

  factory Reminder.fromJson(Map<String, dynamic> json) {
    return Reminder(
      id: json['id'],
      title: json['title'],
      subtitle: json['subtitle'],
      category: json['category'],
      time: json['time'],
    );
  }
}

List<Color> color = [
  Colors.orange.shade100,
  Colors.green.shade100,
  Colors.blue.shade100,
  Colors.pink.shade100,
  Colors.purple.shade100,
  Colors.red.shade100,
];

List<Color> colorRoute = [
  Colors.orange.shade200,
  Colors.green.shade200,
  Colors.blue.shade200,
  Colors.pink.shade200,
  Colors.purple.shade200,
  Colors.red.shade200,
];
