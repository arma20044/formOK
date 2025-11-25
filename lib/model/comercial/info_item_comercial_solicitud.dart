class InfoItem {
  final String title;
  final String description;
  final String buttonText;
  final bool necesitaAuth;
  final String path;
  final bool comercial;

  InfoItem({
    required this.path,
    required this.title,
    required this.description,
    required this.buttonText,
    this.necesitaAuth=false,
    required this.comercial
  });
}
