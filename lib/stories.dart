class Story {
  final String id;
  final String title;
  final String text;

  Story({required this.id, required this.title, required this.text});

  // Factory constructor to create an ApiObject from JSON
  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      id: json['id'],
      title: json['title'],
      text: json['text'],
    );
  }
}

class Word {
  final String id;
  final String word;
  bool isSelected;

  Word({required this.id, required this.word, this.isSelected = false});

  // Factory constructor to create an ApiObject from JSON
  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      id: json['id'],
      word: json['word'],
    );
  }
}