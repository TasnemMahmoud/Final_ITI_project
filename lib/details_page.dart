import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailsPage extends StatefulWidget {
  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  final _commentController = TextEditingController();
  final List<String> _comments = [];
  bool _liked = false;
  late String _articleId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments;
    if (args is Map<String, dynamic>) {
      _articleId = args['id'] as String? ?? '';
      _loadPreferences();
    } else {
      // Handle unexpected arguments
      _articleId = '';
    }
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _liked = prefs.getBool('$_articleId-liked') ?? false;
      _comments.addAll(prefs.getStringList('$_articleId-comments') ?? []);
    });
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('$_articleId-liked', _liked);
    prefs.setStringList('$_articleId-comments', _comments);
  }

  @override
  Widget build(BuildContext context) {
    final article = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>? ?? {};

    final imageUrl = article['urlToImage'] as String? ?? 'https://media.istockphoto.com/id/1336906460/photo/media-concept-multiple-television-screens.jpg?s=1024x1024&w=is&k=20&c=i2lPLvTj5hPvVt_Q2dqqCTZRH3MIKYutq1x6RFIN1BM=';
    final title = article['title'] as String? ?? 'No Title';
    final description = article['description'] as String? ?? 'No Description';
    final publishedAt = article['publishedAt'] as String? ?? 'No Date';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                imageUrl,
                width: double.infinity,
                height: 200.0, // Adjust image height
                fit: BoxFit.cover,
              ),
              SizedBox(height: 16.0),
              Text(title, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
              SizedBox(height: 8.0),
              Text(description, style: Theme.of(context).textTheme.bodyMedium),
              SizedBox(height: 16.0),
              Text('Published at: $publishedAt', style: Theme.of(context).textTheme.bodySmall),
              SizedBox(height: 16.0),
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      _liked ? Icons.thumb_up : Icons.thumb_up_off_alt,
                      color: _liked ? Colors.blue : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _liked = !_liked;
                        _savePreferences(); // Save the updated state
                      });
                    },
                  ),
                  SizedBox(width: 8.0),
                  Text(_liked ? 'You liked this article' : 'Like this article'),
                ],
              ),
              SizedBox(height: 16.0),
              Text('Comments:', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
              SizedBox(height: 8.0),
              Column(
                children: _comments.map((comment) {
                  return ListTile(
                    title: Text(comment, style: Theme.of(context).textTheme.bodyMedium),
                    contentPadding: EdgeInsets.symmetric(vertical: 4.0),
                  );
                }).toList(),
              ),
              TextField(
                controller: _commentController,
                decoration: InputDecoration(
                  labelText: 'Add a comment',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {
                      setState(() {
                        if (_commentController.text.isNotEmpty) {
                          _comments.add(_commentController.text);
                          _commentController.clear();
                          _savePreferences(); // Save the updated comments
                        }
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



