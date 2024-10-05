
class ToDo {
  String title;
  String? description;
  late DateTime createdDate;
  DateTime endDate;

  ToDo({
    required this.title, 
    required this.endDate,
    this.description
  }) {
    final now = DateTime.now();
    createdDate = DateTime(now.year, now.month, now.day);
  }
}