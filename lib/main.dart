import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'news_provider.dart';
import 'home_page.dart';
import 'details_page.dart';
import 'settings_page.dart';
import 'settings_provider.dart';
import 'splash_screen.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => NewsProvider()),
        ChangeNotifierProvider(create: (context) => SettingsProvider()),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settingsProvider, child) {
          return MaterialApp(
            title: 'News App',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              brightness: settingsProvider.darkTheme ? Brightness.dark : Brightness.light,
              textTheme: TextTheme(
                bodyLarge: TextStyle(fontSize: settingsProvider.fontSize, fontWeight: FontWeight.bold),
                bodyMedium: TextStyle(fontSize: settingsProvider.fontSize - 2),
                bodySmall: TextStyle(color: Colors.grey[600], fontSize: settingsProvider.fontSize - 4),
              ),
            ),
            home: SplashScreen(), // استخدام صفحة SplashScreen هنا
            routes: {
              '/home': (context) => HomePage(),
              '/details': (context) => DetailsPage(),
              '/settings': (context) => SettingsPage(),
            },
          );
        },
      ),
    );
  }
}


class NewsList extends StatelessWidget {
  final List<Map<String, String>> articles = [
    {'title': 'News in English', 'language': 'en'},
    {'title': 'أخبار باللغة العربية', 'language': 'ar'},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: articles.length,
      itemBuilder: (context, index) {
        final article = articles[index];
        final isArabic = article['language'] == 'ar';

        return Directionality(
          textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
          child: ListTile(
            title: Text(article['title']!),
          ),
        );
      },
    );
  }
}