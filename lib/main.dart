/// main.dart
///
/// Entry point for the Flutter News App.
///
/// Responsibilities:
/// - Ensures Flutter engine and widget binding are initialized before running the app.
/// - Loads environment variables from the .env file using flutter_dotenv (for API keys, base URLs, etc).
/// - Launches the root widget [NewsApp], which contains the app's navigation and state management setup.
///
/// Usage:
/// Run this file to start the application. Make sure a valid .env file is present at the project root.
///
/// Example .env file:
/// ```env
/// BASE_URL=https://newsapi.org/v2
/// API_KEY=your_api_key_here
/// ```
///
/// Dependencies:
/// - flutter_dotenv: For loading environment variables.
/// - flutter_news_app/screens/news_app.dart: The main app widget.
library;

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_news_app/screens/news_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(NewsApp());
}
