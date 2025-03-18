class Story {
  final int id;
  final String title;
  final String text;

  Story({required this.id, required this.title, required this.text});

  // Factory constructor to create an ApiObject from JSON
  factory Story.fromJson(List<dynamic> json) {
    return Story(
      id: json[0],
      title: json[1],
      text: json[2],
    );
  }
}

class Word {
  final int id;
  final String word;
  bool isSelected;

  Word({required this.id, required this.word, this.isSelected = false});

  // Factory constructor to create an ApiObject from JSON
  factory Word.fromJson(List<dynamic> json) {
    return Word(
      id: json[0],
      word: json[1],
    );
  }
}