import 'dart:convert';

class Task {
  final String id;
  final String title;
  final bool done;
  final DateTime createdAt;

  const Task({
    required this.id,
    required this.title,
    required this.createdAt,
    this.done = false,
  });

  Task copyWith({
    String? id,
    String? title,
    bool? done,
    DateTime? createdAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      done: done ?? this.done,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'done': done,
        'createdAt': createdAt.toIso8601String(),
      };

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json['id'] as String,
        title: json['title'] as String,
        done: json['done'] as bool,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );

  static List<Task> decodeList(String jsonString) {
    final list = json.decode(jsonString) as List<dynamic>;
    return list.map((e) => Task.fromJson(e as Map<String, dynamic>)).toList();
  }

  static String encodeList(List<Task> tasks) {
    final list = tasks.map((t) => t.toJson()).toList();
    return json.encode(list);
  }
}
