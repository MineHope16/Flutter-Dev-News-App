import 'package:flutter/material.dart';
import 'package:flutter_news_app/models/news_model.dart';
import 'package:flutter_news_app/utils/constants/app_assets.dart';

class NewsArticleCard extends StatelessWidget {
  final NewsModel article;
  final VoidCallback onTap;

  const NewsArticleCard({
    super.key,
    required this.article,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            height: 60,
            width: 60,
            child: article.imageURL.isNotEmpty
                ? Hero(
                    tag: article.imageURL,
                    child: Image.network(
                      article.imageURL,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Image.asset(
                        AppAssets.imageNotFound,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : Hero(
                    tag: "",
                    child: Image.asset(
                      AppAssets.imageNotFound,
                      fit: BoxFit.cover,
                    ),
                  ),
          ),
        ),

        title: Text(article.title),

        onTap: onTap,
      ),
    );
  }
}
