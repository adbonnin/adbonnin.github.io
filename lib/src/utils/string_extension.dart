extension StringExtension on String {
  String removeSpecialCharacters() {
    return replaceAll(RegExp(r'[^a-zA-ZÀ-ÖØ-öø-ÿ\s]+'), '');
  }

  String removeMultipleSpace() {
    return replaceAll(RegExp(' +'), ' ');
  }
}
