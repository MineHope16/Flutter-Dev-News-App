/// NewsBloc
///
/// NewsBloc is a BLoC (Business Logic Component) that manages the state and business logic for fetching,
/// paginating, searching, and refreshing news articles in the app. It interacts with the API endpoints
/// and exposes states for the UI to react to loading, success, and end-of-list scenarios.
///
/// Features:
/// - Maintains a list of fetched news articles (`newsArticles`).
/// - Handles pagination with `currentPage`, `pageSize`, `maxPages`, and `totalResults`.
/// - Supports category and search query filtering.
/// - Prevents duplicate fetches with `isFetching` and `hasMore` flags.
/// - Emits states for UI to react to loading, success, and end-of-list scenarios.
///
/// Events:
/// - LoadNewsEvent: Handles initial fetch, pull-to-refresh, and load-more actions. Accepts flags for refresh and load more, as well as category and query.
///
/// States:
/// - NewsInitial: Initial state before any data is loaded.
/// - NewsLoadingState: State when news is being loaded (used for skeleton/shimmer loading UI).
/// - NewsLoadedSuccessState: Contains the loaded articles and a flag for more data.
///
/// Usage:
/// Add this BLoC to your widget tree using BlocProvider and dispatch LoadNewsEvent to fetch, load more, or refresh news.
/// Listen to state changes to update the UI accordingly. Show a skeleton/shimmer loader when state is NewsLoadingState.
///
/// Example:
/// ```dart
/// BlocProvider(
///   create: (context) => NewsBloc(),
///   child: HomeScreen(),
/// )
/// ```
///
/// Example event dispatch:
/// ```dart
/// // Initial fetch
/// context.read<NewsBloc>().add(LoadNewsEvent(isRefresh: false, isLoadMore: false));
/// // Pull-to-refresh
/// context.read<NewsBloc>().add(LoadNewsEvent(isRefresh: true, isLoadMore: false));
/// // Load more
/// context.read<NewsBloc>().add(LoadNewsEvent(isRefresh: false, isLoadMore: true));
/// ```
///
/// Dependencies:
/// - bloc: State management
/// - http: For making API requests
/// - flutter_news_app/models/news_model.dart: News model definition
/// - flutter_news_app/utils/api/api_endpoints.dart: API endpoint utilities
///
/// Main Methods:
/// - loadNewsEvent: Handles all news loading logic (initial, refresh, load more).
/// - _fetchArticles: Internal method to fetch articles from the API, handle pagination, and update state.
library;

import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app/models/news_model.dart';
import 'package:flutter_news_app/utils/api/api_endpoints.dart';
import 'package:http/http.dart';
import 'dart:convert';
part 'news_event.dart';
part 'news_state.dart';

/// The NewsBloc class manages the state and logic for fetching news articles.
class NewsBloc extends Bloc<NewsEvent, NewsState> {
  /// List of fetched news articles.
  List<NewsModel> newsArticles = [];

  /// Current page for pagination.
  int currentPage = 1;

  /// Prevents multiple simultaneous fetches.
  bool isFetching = false;

  /// Indicates if more articles are available to fetch.
  bool hasMore = true;

  /// Total number of results from the API.
  int totalResults = 0;

  /// Number of articles to fetch per page.
  int pageSize = 15;

  /// Maximum number of pages available from the API.
  int maxPages = 0;

  /// Current news category filter.
  String category = "general";

  /// Current search query filter.
  String searchQuery = "";

  /// Constructor: Registers event handler for loading news articles.
  NewsBloc() : super(NewsInitial()) {
    on<LoadNewsEvent>(loadNewsEvent);
  }

  /// Internal method to fetch articles from the API, handle pagination, and update state.
  /// [isInitial] determines if this is the first fetch or a pagination fetch.
  Future<void> _fetchArticles(
    Emitter<NewsState> emit, {
    bool isInitial = false,
  }) async {
    if (!hasMore) return;

    isFetching = true;

    try {
      debugPrint(
        ApiEndpoints.getTopHeadlines(
          page: currentPage,
          pageSize: pageSize,
          category: category,
          query: searchQuery,
        ),
      );
      final response = await get(
        Uri.parse(
          ApiEndpoints.getTopHeadlines(
            page: currentPage,
            pageSize: pageSize,
            category: category,
            query: searchQuery,
          ),
        ),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Set total results and max pages only once
        if (isInitial) {
          totalResults = data['totalResults'];
          maxPages = (totalResults / pageSize).ceil();
          debugPrint("Total results: $totalResults");
        }

        final articles = (data['articles'] as List).map<NewsModel>((article) {
          return NewsModel(
            sourceName: article['source']['name'] ?? "",
            author: article['author'] ?? "",
            title: article['title'] ?? "",
            description: article['description'] ?? "",
            publishedAt: article['publishedAt'] ?? "",
            newsURL: article['url'] ?? "",
            imageURL: article['urlToImage'] ?? "",
            content: article['content'] ?? "",
          );
        }).toList();

        if (isInitial) {
          newsArticles = articles;
        } else {
          newsArticles.addAll(articles);
        }

        if (articles.isEmpty ||
            currentPage >= maxPages ||
            newsArticles.length >= totalResults) {
          hasMore = false;
        } else {
          hasMore = true;
          currentPage++;
        }

        emit(
          NewsLoadedSuccessState(newsArticles: newsArticles, hasMore: hasMore),
        );
      } else {
        debugPrint("Error: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Exception: $e");
    } finally {
      isFetching = false;
    }
  }

  /// Handles all news loading logic (initial, refresh, load more).
  ///
  /// - If [event.isRefresh] is true, clears articles and fetches from the first page.
  /// - If [event.isLoadMore] is true, fetches the next page.
  /// - Otherwise, performs an initial fetch.
  FutureOr<void> loadNewsEvent(
    LoadNewsEvent event,
    Emitter<NewsState> emit,
  ) async {
    if (isFetching) return;

    if (event.isRefresh) {
      newsArticles.clear();
      currentPage = 1;
      hasMore = true;
      category = event.category;
      searchQuery = event.query;
      emit(NewsLoadingState());
      await _fetchArticles(emit, isInitial: true);
    } else if (event.isLoadMore) {
      await _fetchArticles(emit);
    } else {
      emit(NewsLoadingState());
      await _fetchArticles(emit, isInitial: true);
    }
  }
}
