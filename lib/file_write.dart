class ParseFromJson {
  String name;
  List<WordsList> wordsList;
  bool sayWord;
  String testType;
  String fromLanguage;
  String toLanguage;

  ParseFromJson(
      {this.name,
        this.wordsList,
        this.sayWord,
        this.testType,
        this.fromLanguage,
        this.toLanguage});

  ParseFromJson.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    if (json['words_list'] != null) {
      wordsList = new List<WordsList>();
      json['words_list'].forEach((v) {
        wordsList.add(new WordsList.fromJson(v));
      });
    }
    sayWord = json['say_word'];
    testType = json['test_type'];
    fromLanguage = json['from_language'];
    toLanguage = json['to_language'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    if (this.wordsList != null) {
      data['words_list'] = this.wordsList.map((v) => v.toJson()).toList();
    }
    data['say_word'] = this.sayWord;
    data['test_type'] = this.testType;
    data['from_language'] = this.fromLanguage;
    data['to_language'] = this.toLanguage;
    return data;
  }
}

class WordsList {
  String word;
  String translation;

  WordsList({this.word, this.translation});

  WordsList.fromJson(Map<String, dynamic> json) {
    word = json['word'];
    translation = json['translation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['word'] = this.word;
    data['translation'] = this.translation;
    return data;
  }
}