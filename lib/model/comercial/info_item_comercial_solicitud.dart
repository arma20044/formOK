class InfoItem {
  final String title;
  final String description;
  final String buttonText;
  final bool? necesitaAuth;

  InfoItem({
    required this.title,
    required this.description,
    required this.buttonText,
    this.necesitaAuth=false
  });
}
