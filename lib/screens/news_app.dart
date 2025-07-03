import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app/bloc/news_bloc.dart';
import 'package:flutter_news_app/screens/home_screen.dart';
import 'package:flutter_news_app/screens/splash_screen.dart';

class NewsApp extends StatefulWidget {
  const NewsApp({super.key});

  @override
  State<NewsApp> createState() => _NewsAppState();
}

class _NewsAppState extends State<NewsApp> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NewsBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          appBarTheme: AppBarTheme(backgroundColor: Color(0xFFBBDEFB)),
        ),
        initialRoute: SplashScreen.id,
        routes: {
          SplashScreen.id: (context) => SplashScreen(),
          HomeScreen.id: (context) => HomeScreen(),
        },
      ),
    );
  }
}
