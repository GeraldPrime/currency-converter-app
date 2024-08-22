

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  List<dynamic> articles = [];

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  Future<void> fetchNews() async {
    final response = await http.get(Uri.parse('https://newsapi.org/v2/everything?q=currency&apiKey=5cc8509d12764976a02c6a52c7dcf939'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        articles = data['articles'].reversed.toList();
      });
    } else {
      throw Exception('Failed to load news');
    }
  }

  Future<void> _refreshNews() async {
    await fetchNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(title: Text('Currency News')),
      body: RefreshIndicator(
        onRefresh: _refreshNews,
        child: ListView.builder(
          itemCount: articles.length,
          itemBuilder: (context, index) {
            final article = articles[index];
            return Card(
              child: ListTile(
                leading: article['urlToImage'] != null && article['urlToImage'].toString().isNotEmpty
                    ? Image.network(
                  article['urlToImage'],
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.broken_image, size: 100);
                  },
                )
                    : Icon(Icons.image, size: 100),
                title: Text(article['title']),
                subtitle: Text(article['description'] ?? 'No description available'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ArticleDetailPage(article: article),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class ArticleDetailPage extends StatelessWidget {
  final dynamic article;

  const ArticleDetailPage({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(article['title'] ?? 'Article')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            // Display the article image if available
            article['urlToImage'] != null
                ? Image.network(article['urlToImage'])
                : SizedBox.shrink(),
            SizedBox(height: 10),
            // Display the article title
            Text(
              article['title'] ?? 'No title available',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            // Display the publication date
            Text(
              article['publishedAt'] != null
                  ? 'Published on: ${article['publishedAt']}'
                  : 'No publication date available',
              style: TextStyle(color: Colors.grey),
            ),
            // Display the author if available
            article['author'] != null
                ? Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                'Author: ${article['author']}',
                style: TextStyle(color: Colors.grey),
              ),
            )
                : SizedBox.shrink(),
            // Display the source name if available
            article['source'] != null && article['source']['name'] != null
                ? Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                'Source: ${article['source']['name']}',
                style: TextStyle(color: Colors.grey),
              ),
            )
                : SizedBox.shrink(),
            SizedBox(height: 10),
            // Display the article description
            Text(
              article['description'] ?? 'No description available',
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
            SizedBox(height: 10),
            // Display the full content if available
            article['content'] != null
                ? Text(
              article['content']!,
              style: TextStyle(fontSize: 16),
            )
                : Text(
              'No content available',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
