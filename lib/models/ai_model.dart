class AIModel {
  final String id;
  final String name;
  final String description;
  final String size;
  final String filename;
  final String url;
  final bool requiresAuth;

  const AIModel({
    required this.id,
    required this.name,
    required this.description,
    required this.size,
    required this.filename,
    required this.url,
    this.requiresAuth = false,
  });
}
