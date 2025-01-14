class Task {
  final int? id; // Allow `id` to be nullable for new tasks
  final String title;
  final String content;
  final String font;
  final double fontSize;
  final String color;
  final int isCompleted;
  final int userId;

  Task({
    this.id,
    required this.title,
    required this.content,
    required this.font,
    required this.fontSize,
    required this.color,
    required this.isCompleted,
    required this.userId
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'font': font,
      'fontSize': fontSize,
      'color': color,
      'isCompleted': isCompleted,
      'userId': userId,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      font: map['font'],
      fontSize: map['fontSize'],
      color: map['color'],
      userId: map['userId'],
      isCompleted: map['isCompleted']
    );
  }

  Task copyWith({
    int? id,
    String? title,
    String? content,
    String? font,
    double? fontSize,
    String? color,
    int? userId,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      font: font ?? this.font,
      fontSize: fontSize ?? this.fontSize,
      color: color ?? this.color,
      userId: userId ?? this.userId,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
