class Experience {
  Experience({
    required this.title,
    required this.fromDate,
    this.toDate,
    required this.description,
  });

  final String title;
  final DateTime fromDate;
  final DateTime? toDate;
  final String description;
}
