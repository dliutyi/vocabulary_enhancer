import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vocabulary_enhancer/stories.dart';
import 'package:vocabulary_enhancer/word_dialog.dart';

class WordListScreen extends StatefulWidget {
  @override
  _WordListScreenState createState() => _WordListScreenState();
}

class _WordListScreenState extends State<WordListScreen> {
  Future<List<Word>> fetchWords() async {
    final response = await http.get(
        Uri.parse('https://ambitious-noreen-dliutyi-b3e46d66.koyeb.app/words'));

    if (response.statusCode == 200) {
      final List<dynamic> wordsJson = jsonDecode(response.body);
      return wordsJson.map((json) => Word.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load words');
    }
  }

  void _showAddWordDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddWordDialog(
          onWordAdded: (newWord) {
            //TODO: Implement api call to add new word.
            print("new word added: $newWord");
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<List<Word>>(
          future: fetchWords(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              final List<Word> words = snapshot.data!;
              return ListView.builder(
                itemCount: words.length,
                itemBuilder: (context, index) {
                  final word = words[index];
                  return ListTile(
                    title: Text(word.word),
                  );
                },
              );
            } else {
              return Text('No words available');
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddWordDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}

class AddWordDialog extends StatefulWidget {
final Function(String) onWordAdded;

AddWordDialog({required this.onWordAdded});

@override
_AddWordDialogState createState() => _AddWordDialogState();
}

class _AddWordDialogState extends State<AddWordDialog> {
  final TextEditingController _wordController = TextEditingController();

  @override
  void dispose() {
    _wordController.dispose();
    super.dispose();
  }

  void _addWord() {
    final newWord = _wordController.text.trim();
    if (newWord.isNotEmpty) {
      widget.onWordAdded(newWord);
      Navigator.of(context).pop(); // Close the dialog
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add New Word'),
      content: TextField(
        controller: _wordController,
        decoration: InputDecoration(hintText: 'Enter word'),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
        ),
        TextButton(
          child: Text('Add'),
          onPressed: _addWord,
        ),
      ],
    );
  }
}