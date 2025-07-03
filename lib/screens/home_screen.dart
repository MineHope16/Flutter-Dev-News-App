/// HomeScreen
///
/// The `HomeScreen` widget is the main screen of the HeadLyne news app, responsible for displaying
/// a searchable and filterable list of news articles. It leverages the BLoC pattern for state management
/// and supports features such as category selection, search with debounce, infinite scrolling (pagination),
/// pull-to-refresh, and skeleton loading indicators.
///
/// **Features:**
/// - Displays a branded header with the app logo and name.
/// - Provides a search bar to filter news articles by keyword, with debounce to reduce unnecessary API calls.
/// - Allows users to filter news by category using horizontally scrollable chips.
/// - Shows a paginated list of news articles, loading more as the user scrolls.
/// - Supports pull-to-refresh to reload the news feed.
/// - Displays skeleton loaders while fetching data.
/// - Handles empty states and end-of-list scenarios gracefully.
/// - Navigates to a detailed news screen when an article is tapped.
///
/// **State Management:**
/// - Uses `BlocConsumer<NewsBloc, NewsState>` to listen for and build UI based on news loading states.
/// - Dispatches `LoadNewsEvent` with appropriate parameters for search, category, refresh, and pagination.
///
/// **Usage:**
/// ```dart
/// Navigator.pushNamed(context, HomeScreen.id);
/// ```
///
/// **Constructor:**
/// - `const HomeScreen({Key? key})`
///
/// **State:**
/// - `_HomeScreenState` manages scroll, search, category selection, and event dispatching.
///
/// **Dependencies:**
/// - `flutter_bloc` for BLoC state management.
/// - `skeletonizer` for loading skeletons.
/// - `flutter_news_app/bloc/news_bloc.dart` for news BLoC and events.
/// - `flutter_news_app/screens/news_details_screen.dart` for navigation to article details.
/// - `flutter_news_app/utils/constants/app_assets.dart` and `app_colors.dart` for assets and theming.
///
/// **Example:**
/// ```dart
/// MaterialApp(
///   initialRoute: HomeScreen.id,
///   routes: {
///     HomeScreen.id: (context) => const HomeScreen(),
///   },
/// );
/// ```
///
/// See also:
/// - [NewsBloc] for business logic and state management.
/// - [NewsDetailsScreen] for displaying detailed news articles.
/// The `HomeScreen` widget is the main screen of the HeadLyne news app, responsible for displaying
/// a searchable and filterable list of news articles. It leverages the BLoC pattern for state management
/// and supports features such as category selection, search with debounce, infinite scrolling (pagination),
/// pull-to-refresh, and skeleton loading indicators.
///
/// **Features:**
/// - Displays a branded header with the app logo and name.
/// - Provides a search bar to filter news articles by keyword, with debounce to reduce unnecessary API calls.
/// - Allows users to filter news by category using horizontally scrollable chips.
/// - Shows a paginated list of news articles, loading more as the user scrolls.
/// - Supports pull-to-refresh to reload the news feed.
/// - Displays skeleton loaders while fetching data.
/// - Handles empty states and end-of-list scenarios gracefully.
/// - Navigates to a detailed news screen when an article is tapped.
///
/// **State Management:**
/// - Uses `BlocConsumer<NewsBloc, NewsState>` to listen for and build UI based on news loading states.
/// - Dispatches `LoadNewsEvent` with appropriate parameters for search, category, refresh, and pagination.
///
/// **Usage:**
/// ```dart
/// Navigator.pushNamed(context, HomeScreen.id);
/// ```
///
/// **Constructor:**
/// - `const HomeScreen({Key? key})`
///
/// **State:**
/// - `_HomeScreenState` manages scroll, search, category selection, and event dispatching.
///
/// **Dependencies:**
/// - `flutter_bloc` for BLoC state management.
/// - `skeletonizer` for loading skeletons.
/// - `flutter_news_app/bloc/news_bloc.dart` for news BLoC and events.
/// - `flutter_news_app/screens/news_details_screen.dart` for navigation to article details.
/// - `flutter_news_app/utils/constants/app_assets.dart` and `app_colors.dart` for assets and theming.
///
/// **Example:**
/// ```dart
/// MaterialApp(
///   initialRoute: HomeScreen.id,
///   routes: {
///     HomeScreen.id: (context) => const HomeScreen(),
///   },
/// );
/// ```
///
/// See also:
/// - [NewsBloc] for business logic and state management.
/// - [NewsDetailsScreen] for displaying detailed news articles.
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app/bloc/news_bloc.dart';
import 'package:flutter_news_app/screens/news_details_screen.dart';
import 'package:flutter_news_app/utils/constants/app_assets.dart';
import 'package:flutter_news_app/utils/constants/app_colors.dart';
import 'package:flutter_news_app/utils/widgets/news_article_card.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static String id = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  int selectedCategoryIndex = 0;
  String get selectedCategory => categories[selectedCategoryIndex];
  bool isTyping = false;
  late FocusNode _searchFocusNode;

  final List<String> categories = [
    'general',
    'business',
    'entertainment',
    'health',
    'science',
    'sports',
    'technology',
  ];

  //Debouncing Logic of the Search Bar
  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    if (value.isNotEmpty) {
      setState(() {
        isTyping = true;
      });
    } else {
      setState(() {
        isTyping = false;
      });
    }

    _debounce = Timer(const Duration(milliseconds: 600), () {
      context.read<NewsBloc>().add(
        LoadNewsEvent(
          isRefresh: true,
          isLoadMore: false,
          category: selectedCategory,
          query: _searchController.text,
        ),
      );
    });
  }

  @override
  void initState() {
    _searchFocusNode = FocusNode();

    context.read<NewsBloc>().add(
      LoadNewsEvent(
        isRefresh: false,
        isLoadMore: false,
        category: selectedCategory,
      ),
    );

    scrollController.addListener(() {
      if (FocusScope.of(context).hasFocus) {
        FocusScope.of(context).unfocus();
      }
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 100) {
        context.read<NewsBloc>().add(
          LoadNewsEvent(
            isRefresh: false,
            isLoadMore: true,
            category: selectedCategory,
            query: _searchController.text,
          ),
        );
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    scrollController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NewsAppColors.scaffoldBackgroundColor,
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              //App Logo + App Name
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    Image.asset(AppAssets.logo, height: 40),
                    const SizedBox(width: 10),
                    Text(
                      "HeadLyne",
                      style: TextStyle(
                        color: NewsAppColors.splashScreenLogoColor,
                        fontFamily: "NewsV",
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  focusNode: _searchFocusNode,
                  controller: _searchController,
                  decoration: InputDecoration(
                    suffixIcon: isTyping
                        ? GestureDetector(
                            onTap: () {
                              FocusScope.of(context).unfocus();
                              setState(() {
                                _searchController.clear();
                                isTyping = false;
                              });
                              context.read<NewsBloc>().add(
                                LoadNewsEvent(
                                  isRefresh: true,
                                  isLoadMore: false,
                                  category: selectedCategory,
                                ),
                              );
                            },
                            child: const Icon(Icons.close),
                          )
                        : null,
                    hintText: 'Search news...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: _onSearchChanged,
                ),
              ),

              const SizedBox(height: 10),

              // Category Chips
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(categories.length, (index) {
                      final category = categories[index];
                      final isSelected = selectedCategoryIndex == index;

                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text(
                            category[0].toUpperCase() + category.substring(1),
                          ),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (!selected || selectedCategoryIndex == index) {
                              return;
                            }

                            setState(() {
                              selectedCategoryIndex = index;
                            });

                            _searchController.clear();

                            context.read<NewsBloc>().add(
                              LoadNewsEvent(
                                isRefresh: true,
                                isLoadMore: false,
                                category: selectedCategory,
                                query: _searchController.text,
                              ),
                            );
                          },
                          selectedColor: Colors.blue,
                          backgroundColor: Colors.grey[300],
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // News Feed
              Expanded(
                child: BlocConsumer<NewsBloc, NewsState>(
                  listenWhen: (previous, current) => current is NewsActionState,
                  listener: (context, state) {},
                  builder: (context, state) {
                    switch (state) {
                      case NewsLoadingState _:
                        return ListView.builder(
                          itemCount: 10,
                          itemBuilder: (context, index) {
                            return const Skeletonizer(
                              child: Card(
                                child: ListTile(
                                  leading: CircleAvatar(radius: 30),
                                  title: Text('Loading...'),
                                  subtitle: Text('Loading...'),
                                ),
                              ),
                            );
                          },
                        );

                      case NewsLoadedSuccessState _:
                        final successState = state;

                        return RefreshIndicator(
                          onRefresh: () async {
                            _searchController.clear();
                            final bloc = context.read<NewsBloc>();
                            await Future.delayed(const Duration(seconds: 1));
                            bloc.add(
                              LoadNewsEvent(
                                isRefresh: true,
                                isLoadMore: false,
                                category: selectedCategory,
                                query: _searchController.text,
                              ),
                            );
                          },
                          child: ListView.builder(
                            controller: scrollController,
                            itemCount: successState.newsArticles.length + 1,
                            itemBuilder: (context, index) {
                              if (index < successState.newsArticles.length) {
                                final article =
                                    successState.newsArticles[index];
                                return NewsArticleCard(
                                  article: article,
                                  onTap: () {
                                    _searchController.clear();
                                    FocusScope.of(context).unfocus();
                                    _searchFocusNode.unfocus();
                                    setState(() {
                                      isTyping = false; // Hide the clear icon
                                    });
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            NewsDetailsScreen(article: article),
                                      ),
                                    );
                                    context.read<NewsBloc>().add(
                                      LoadNewsEvent(
                                        isRefresh: true,
                                        isLoadMore: false,
                                        category: selectedCategory,
                                      ),
                                    );
                                  },
                                );
                              } else {
                                return successState.hasMore
                                    ? const Center(
                                        child: Padding(
                                          padding: EdgeInsets.all(12.0),
                                          child: CircularProgressIndicator(),
                                        ),
                                      )
                                    : const Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 16,
                                        ),
                                        child: Center(
                                          child: Text("No more news to load"),
                                        ),
                                      );
                              }
                            },
                          ),
                        );

                      default:
                        return const SizedBox();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
