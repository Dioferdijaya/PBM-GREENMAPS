class ArticleModel {
  final String id;
  final String title;
  final String summary;
  final String content;
  final String category;
  final String author;
  final int readMinutes;
  final DateTime publishedAt;
  final bool isFeatured;
  final String? imageUrl; // Added thumbnail support

  const ArticleModel({
    required this.id,
    required this.title,
    required this.summary,
    required this.content,
    required this.category,
    required this.author,
    required this.readMinutes,
    required this.publishedAt,
    this.isFeatured = false,
    this.imageUrl,
  });
}
