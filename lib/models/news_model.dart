/// NewsModel
///
/// Represents a single news article with all relevant metadata and content fields.
///
/// Fields:
/// - sourceName: The name of the news source or publisher.
/// - author: The author of the article.
/// - title: The headline or title of the news article.
/// - description: A short summary or description of the article.
/// - publishedAt: The publication date/time of the article (usually ISO8601 string).
/// - newsURL: The direct URL to the full news article.
/// - imageURL: The URL to the article's main image or thumbnail.
/// - content: The full content or main body of the article (if available).
///
/// Usage:
/// Used throughout the app to represent and display news articles in lists, details, etc.
///
/// Example:
/// ```dart
/// NewsModel(
///   sourceName: 'BBC News',
///   author: 'John Doe',
///   title: 'Flutter 3.0 Released',
///   description: 'Flutter 3.0 brings new features...',
///   publishedAt: '2025-07-03T12:00:00Z',
///   newsURL: 'https://news.example.com/flutter-3',
///   imageURL: 'https://news.example.com/images/flutter-3.jpg',
///   content: 'Flutter 3.0 introduces...'
/// )
/// ```
class NewsModel {
  final String sourceName;
  final String author;
  final String title;
  final String description;
  final String publishedAt;
  final String newsURL;
  final String imageURL;
  final String content;

  NewsModel({
    required this.sourceName,
    required this.author,
    required this.title,
    required this.description,
    required this.publishedAt,
    required this.newsURL,
    required this.imageURL,
    required this.content,
  });
}
