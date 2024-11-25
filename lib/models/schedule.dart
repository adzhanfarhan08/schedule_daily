class Schedule {
  final String id;
  final String title;
  final DateTime dateTime;
  final String time;
  final String classroom;
  final String lecturer;
  bool isCompleted;

  Schedule({
    required this.id,
    required this.title,
    required this.dateTime,
    required this.time,
    required this.classroom,
    required this.lecturer,
    this.isCompleted = false,
  });

  // Konversi objek ke JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'dateTime': dateTime.toIso8601String(),
      'time': time,
      'classroom': classroom,
      'lecturer': lecturer,
      'isCompleted': isCompleted,
    };
  }

  // Konversi JSON ke objek
  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      id: json['id'],
      title: json['title'],
      dateTime: DateTime.parse(json['dateTime']),
      time: json['time'],
      classroom: json['classroom'],
      lecturer: json['lecturer'],
      isCompleted: json['isCompleted'] ?? false,
    );
  }
}
