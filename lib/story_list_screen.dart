import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vocabulary_enhancer/config.dart';
import 'package:vocabulary_enhancer/stories.dart';
import 'package:vocabulary_enhancer/word_dialog.dart';

class StoryListScreen extends StatefulWidget {
  @override
  _StoryListScreenState createState() => _StoryListScreenState();
}

class _StoryListScreenState extends State<StoryListScreen> {
  // 2. Fetching Data (Simulate API Call)
  Future<List<Story>> fetchStories() async {
    final response = await http
        .get(Uri.http(AppConfig.serverLocation, 'stories'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      final List<dynamic> storiesJson = jsonDecode(response.body);
      return storiesJson.map((json) => Story.fromJson(json)).toList();
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load stories');
    }
  }

  Future<List<Word>> fetchWords() async {
    final response = await http.get(
        Uri.http(AppConfig.serverLocation, 'words')); // Replace with your actual words API endpoint

    if (response.statusCode == 200) {
      final List<dynamic> wordsJson = jsonDecode(response.body);
      return wordsJson.map((json) => Word.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load words');
    }
  }

  void _showWordSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return WordSelectionDialog(fetchWords: fetchWords,);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stories List'),
      ),
      body: Center(
        // 3. FutureBuilder
        child: FutureBuilder<List<Story>>(
          future: fetchStories(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(); // Show loading indicator
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}'); // Show error message
            } else if (snapshot.hasData) {
              final List<Story> stories = snapshot.data!;
              // 4. ListView.builder
              return ListView.builder(
                itemCount: stories.length,
                itemBuilder: (context, index) {
                  // 5. Item Widget
                  final story = stories[index];
                  return StoryListItem(story: story);
                },
              );
            } else {
              return Text('No data available'); // Show message if no data
            }
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: _showWordSelectionDialog,
            child: Text('Generate'),
          ),
        ),
      ),
    );
  }
}
class StoryListItem extends StatefulWidget {
  final Story story;

  const StoryListItem({Key? key, required this.story}) : super(key: key);

  @override
  _StoryListItemState createState() => _StoryListItemState();
}

class _StoryListItemState extends State<StoryListItem> {
  final GlobalKey textKey = GlobalKey();
  bool isExpanded = false;

  String _trimDescription(String description, int maxLines) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: description,
        style: DefaultTextStyle.of(context).style,
      ),
      maxLines: maxLines,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: MediaQuery.of(context).size.width - 100); // Adjust maxWidth as needed

    if (textPainter.didExceedMaxLines) {
      final endIndex = textPainter.getPositionForOffset(Offset(textPainter.size.width, textPainter.size.height)).offset;
      return description.substring(0, endIndex) + '...';
    } else {
      return description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(widget.story.title),
        subtitle: isExpanded
            ? Text(widget.story.text)
            : Text(_trimDescription(widget.story.text, 2), key: textKey),
        onTap: () {
          setState(() {
            isExpanded = !isExpanded;
          });
        },
      ),
    );
  }
}
