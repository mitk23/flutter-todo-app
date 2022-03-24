class Todo {
  static int _idCounter = 0;
  int id = 0;
  String title = 'todo', description = '';
  bool state = false, pinned = false;
  DateTime? dateTime;

  Todo({required this.title, int? id}) {
    this.id = id ?? _idCounter++;
  }

  Todo.fromMap(Map todoMap) {
    title = todoMap['title'] ?? title;
    state = todoMap['state'] ?? state;
    pinned = todoMap['pinned'] ?? pinned;
    description = todoMap['description'] ?? description;
    dateTime = todoMap['dateTime'] == null
        ? dateTime
        : todoMap['dateTime'] is String
        ? DateTime.parse(todoMap['dateTime']).toLocal()
        : todoMap['dateTime'].toLocal();
    id = todoMap['id'] ?? _idCounter++;
  }

  Map<String, Object?> toMap() => {
    'id': id,
    'title': title,
    'state': state,
    'description': description,
    'dateTime': dateTime == null ? null : dateTime!.toUtc().toIso8601String(),
    'pinned': pinned,
  };

  static void countReset() {
    _idCounter = 0;
  }
}

int todoComparator(Todo a, Todo b) {
  if (a.pinned) {
    if (b.pinned) return 0;
    return -1;
  } else if (b.pinned) {
    return 1;
  }
  return a.id.compareTo(b.id);
}