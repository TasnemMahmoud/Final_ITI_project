import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../news_provider.dart';
import 'settings_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final newsProvider = Provider.of<NewsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Top News',
          style: TextStyle(
            fontSize: 27,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                blurRadius: 7.0,
                color: Colors.black38,
                offset: Offset(2.0, 2.0),
              ),
            ],
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/');
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: NewsSearchDelegate(newsProvider),
              );
            },
          ),
        ],
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
              !newsProvider.loading && newsProvider.hasMore) {
            newsProvider.fetchNews(loadMore: true);
          }
          return false;
        },
        child: newsProvider.loading && newsProvider.articles.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
          itemCount: newsProvider.articles.length + (newsProvider.hasMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == newsProvider.articles.length) {
              return Center(child: CircularProgressIndicator());
            }
            final article = newsProvider.articles[index];
            final imageUrl = article['urlToImage'] ?? 'https://media.istockphoto.com/id/1336906460/photo/media-concept-multiple-television-screens.jpg?s=1024x1024&w=is&k=20&c=i2lPLvTj5hPvVt_Q2dqqCTZRH3MIKYutq1x6RFIN1BM=';
            return Card(
              margin: EdgeInsets.all(8.0),
              elevation: 5,
              shadowColor: Colors.grey,
              child: ListTile(
                contentPadding: EdgeInsets.all(8.0),
                leading: Image.network(imageUrl, width: 100, fit: BoxFit.cover),
                title: Text(article['title'], style: Theme.of(context).textTheme.bodyLarge),
                subtitle: Text(article['description'] ?? '', style: Theme.of(context).textTheme.bodySmall),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/details',
                    arguments: {
                      'title': article['title'],
                      'description': article['description'],
                      'urlToImage': article['urlToImage'],
                      'publishedAt': article['publishedAt'],
                      'author': article['author'], // معلومات إضافية
                      'source': article['source'], // معلومات إضافية
                      'content': article['content'], // معلومات إضافية
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          newsProvider.fetchNews();
        },
        backgroundColor: Colors.blue,
        child: Icon(Icons.refresh , color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

class NewsSearchDelegate extends SearchDelegate {
  final NewsProvider newsProvider;

  NewsSearchDelegate(this.newsProvider);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = newsProvider.articles.where((article) {
      return article['title'].toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final article = results[index];
        final imageUrl = article['urlToImage'] ?? 'https://media.istockphoto.com/id/1336906460/photo/media-concept-multiple-television-screens.jpg?s=1024x1024&w=is&k=20&c=i2lPLvTj5hPvVt_Q2dqqCTZRH3MIKYutq1x6RFIN1BM=';
        return Card(
          margin: EdgeInsets.all(8.0),
          elevation: 5,
          shadowColor: Colors.grey,
          child: ListTile(
            contentPadding: EdgeInsets.all(8.0),
            leading: Image.network(imageUrl, width: 100, fit: BoxFit.cover),
            title: Text(article['title'], style: Theme.of(context).textTheme.bodyLarge),
            subtitle: Text(article['description'] ?? '', style: Theme.of(context).textTheme.bodySmall),
            onTap: () {
              Navigator.pushNamed(
                context,
                '/details',
                arguments: {
                  'title': article['title'],
                  'description': article['description'],
                  'urlToImage': article['urlToImage'],
                  'publishedAt': article['publishedAt'],
                  'author': article['author'], // معلومات إضافية
                  'source': article['source'], // معلومات إضافية
                  'content': article['content'], // معلومات إضافية
                },
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = newsProvider.articles.where((article) {
      return article['title'].toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final article = suggestions[index];
        final imageUrl = article['urlToImage'] ?? 'https://media.istockphoto.com/id/1336906460/photo/media-concept-multiple-television-screens.jpg?s=1024x1024&w=is&k=20&c=i2lPLvTj5hPvVt_Q2dqqCTZRH3MIKYutq1x6RFIN1BM=';
        return ListTile(
          leading: Image.network(imageUrl, width: 100, fit: BoxFit.cover),
          title: Text(article['title']),
          onTap: () {
            query = article['title'];
            showResults(context);
          },
        );
      },
    );
  }
}


