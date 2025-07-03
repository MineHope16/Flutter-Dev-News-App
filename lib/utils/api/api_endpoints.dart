import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiEndpoints {
  ApiEndpoints._();

  static final String baseUrl = dotenv.env['BASE_URL']!;
  static final String apiKey = dotenv.env['API_KEY']!;
  static const String topHeadlinesPath = "/top-headlines";
  static const String everythingPath = "/everything";

  static String getTopHeadlines({
    String country = 'us',
    int page = 1,
    int pageSize = 15,
    String category = "general",
    String query = "",
  }) {
    final uri = Uri.parse(baseUrl + topHeadlinesPath).replace(queryParameters: {
      'country': country,
      'category': category,
      'q': query,
      'page': page.toString(),
      'pageSize': pageSize.toString(),
      'apiKey': apiKey,
    });
    return uri.toString();
  }

  static String getEverything(String keyword) {
    final uri = Uri.parse(baseUrl + everythingPath).replace(queryParameters: {
      'q': keyword,
      'apiKey': apiKey,
    });
    return uri.toString();
  }
}
