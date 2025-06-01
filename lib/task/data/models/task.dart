class Task {
  final int id;
  final String title;
  final String description;
  final bool completed;
  final DateTime dueDate;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.completed,
    required this.dueDate,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      completed: json['completed'],
      dueDate: DateTime.parse(json['dueDate']),
    );
  }
}
