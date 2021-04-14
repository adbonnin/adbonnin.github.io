class Education {
  Education({
    required this.school,
    required this.degree,
    required this.description,
    required this.fromYear,
    this.toYear,
  });

  final String school;
  final String degree;
  final String description;
  final int fromYear;
  final int? toYear;
}