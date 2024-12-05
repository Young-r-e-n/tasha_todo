class Todo {
  final int id; // Use int for id
  final String title;
  final bool completed;

  Todo({
    required this.id,
    required this.title,
    required this.completed,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'], // Directly assign as int
      title: json['title'] as String,
      completed: json['completed'] == 1 || json['completed'] == '1', // Normalize
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'completed': completed ? 1 : 0, // Convert to 1/0
    };
  }
}
