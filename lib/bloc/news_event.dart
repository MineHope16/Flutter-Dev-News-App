/// NewsEvent and LoadNewsEvent
///
/// This file defines the events for the NewsBloc, which are used to trigger state changes and data fetching in the news app.
///
/// Events:
/// - NewsEvent: The abstract base class for all news-related events.
/// - LoadNewsEvent: The main event for loading news articles. It supports initial load, pull-to-refresh, load more (pagination), category-based, and search-based fetching.
///
/// Usage:
/// Dispatch a LoadNewsEvent to the NewsBloc to fetch news articles. You can specify:
///   - isRefresh: true for pull-to-refresh, false otherwise.
///   - isLoadMore: true to load the next page, false otherwise.
///   - category: the news category to fetch (e.g., 'business', 'sports').
///   - query: a search query string for keyword-based news fetching.
///
/// Example:
/// ```dart
/// // Initial fetch
/// context.read<NewsBloc>().add(LoadNewsEvent(isRefresh: false, isLoadMore: false, category: 'general'));
/// // Pull-to-refresh
/// context.read<NewsBloc>().add(LoadNewsEvent(isRefresh: true, isLoadMore: false, category: 'general'));
/// // Load more
/// context.read<NewsBloc>().add(LoadNewsEvent(isRefresh: false, isLoadMore: true, category: 'general'));
/// // Search
/// context.read<NewsBloc>().add(LoadNewsEvent(isRefresh: false, isLoadMore: false, category: 'general', query: 'flutter'));
/// ```

part of 'news_bloc.dart';

@immutable
sealed class NewsEvent {}

/// Event to load news articles.
///
/// [isRefresh]: true for pull-to-refresh, false otherwise.
/// [isLoadMore]: true to load the next page, false otherwise.
/// [category]: the news category to fetch.
/// [query]: search query for keyword-based fetching (optional).
final class LoadNewsEvent extends NewsEvent {
  final bool isRefresh;
  final bool isLoadMore;
  final String category;
  final String query;
  LoadNewsEvent({
    this.query = '',
    required this.isRefresh,
    required this.isLoadMore,
    required this.category,
  });
}
