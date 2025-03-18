import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vocabulary_enhancer/stories.dart';

// Word Selection Dialog
class WordSelectionDialog extends StatefulWidget {
  final Future<List<Word>> Function() fetchWords;

  WordSelectionDialog({required this.fetchWords});

  @override
  _WordSelectionDialogState createState() => _WordSelectionDialogState();
}

class _WordSelectionDialogState extends State<WordSelectionDialog> {
  late Future<List<Word>> _wordsFuture;
  List<Word> selectedWords = [];

  @override
  void initState() {
    super.initState();
    _wordsFuture = widget.fetchWords();
  }

  void _sendRequest(List<Word> selectedWords) {
    // TODO: Implement sending the request with selected words
    print("Selected words: ${selectedWords.map((w) => w.word).toList()}");
    Navigator.of(context).pop(); // Close the dialog
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select Words'),
      content: FutureBuilder<List<Word>>(
        future: _wordsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            final List<Word> words = snapshot.data!;
            return Container(
              width: double.maxFinite, // Make the container take full width
              child: ListView.builder(
                shrinkWrap: true, // Allow the ListView to take the space it needs
                itemCount: words.length,
                itemBuilder: (context, index) {
                  final word = words[index];
                  return CheckboxListTile(
                    title: Text(word.word),
                    value: word.isSelected,
                    onChanged: (bool? value) {
                      setState(() {
                        word.isSelected = value ?? false;
                        if (word.isSelected) {
                          selectedWords.add(word);
                        } else {
                          selectedWords.remove(word);
                        }
                      });
                    },
                  );
                },
              ),
            );
          } else {
            return Text('No words available');
          }
        },
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
        ),
        TextButton(
          child: Text('Send Request'),
          onPressed: () {
            _sendRequest(selectedWords);
          },
        ),
      ],
    );
  }
}