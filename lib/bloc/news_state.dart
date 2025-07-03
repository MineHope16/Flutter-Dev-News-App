/// NewsState and its subclasses
///
/// This file defines the possible states for the NewsBloc, which represent the UI and data status
/// during the news fetching lifecycle in the app.
///
/// States:
/// - NewsState: The abstract base class for all news-related states.
/// - NewsActionState: For one-off UI actions (e.g., navigation, snackbars).
/// - NewsInitial: The initial state before any data is loaded.
/// - NewsLoadingState: Indicates that news data is currently being loaded (e.g., show skeleton/shimmer).
/// - NewsLoadedSuccessState: Contains the loaded news articles and a flag for more data (pagination).
/// - NewsLoadedErrorState: Indicates an error occurred while loading news data.
/// - NewsDetailsLoadedState: Contains a single news article for detail view.
///
/// Usage:
/// The UI should react to these states in BlocBuilder/BlocConsumer to display loading indicators,
/// show news lists, handle errors, or navigate to details.
///
/// Example:
/// ```dart
/// if (state is NewsLoadingState) { ... }
/// if (state is NewsLoadedSuccessState) { ... }
/// if (state is NewsLoadedErrorState) { ... }
/// ```

part of 'news_bloc.dart';

@immutable
sealed class NewsState {}

/// For one-off UI actions (e.g., navigation, snackbars).
sealed class NewsActionState extends NewsState {}

/// The initial state before any data is loaded.
final class NewsInitial extends NewsState {}

/// Indicates that news data is currently being loaded.
final class NewsLoadingState extends NewsState {}

/// Contains the loaded news articles and a flag for more data (pagination).
final class NewsLoadedSuccessState extends NewsState {
  final List<NewsModel> newsArticles;
  final bool hasMore;

  NewsLoadedSuccessState({required this.newsArticles, required this.hasMore});
}

/// Indicates an error occurred while loading news data.
final class NewsLoadedErrorState extends NewsState {}

/// Contains a single news article for detail view.
final class NewsDetailsLoadedState extends NewsState {
  final NewsModel article;

  NewsDetailsLoadedState({required this.article});
}
