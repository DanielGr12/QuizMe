import 'package:dictation_app/file_write.dart';
import 'package:flutter/material.dart';



class GlobalParameters
{
  static String AppVersion = "1.0.0";
  static List<Dictation> Dictations = new List<Dictation>();
  static Dictation add_dictation = new Dictation("", words_to_add_list, false, "Show the word",6,last_dictation_worng_words,"",clear_tested_words_list);
  static List<Word> words_to_add_list = new List<Word>();
  static List<Word> last_dictation_worng_words = new List<Word>();
  static List<Check_word> clear_tested_words_list = new List<Check_word>();
  static List<Dictation> recentDictations = new List<Dictation>();
  static int recent_dictations_length = 5;

  static List<Check_word> tested_words_list = new List<Check_word>();
  static List<Map<String, String>> words_to_add_list_dictionary = new List<Map<String, String>>();
  //static Dictation add_words;
  static List<DropdownMenuItem<String>> languages_list = new List<DropdownMenuItem<String>>();
  static String selected_dictation = "Select dictation";
  static TabController tab_controller;
  static int tested_words_count = 0;
  static List<Check_word> tested_words = new List<Check_word>();
  static int correct_counter = 0;
  static String last_dictation_date;
  static Dictation last_dictation;
  static LastDictation last_saved_dictation;
  static List<Check_word> last_dictation_tested_words = new List<Check_word>();
//  static String snackBarValue;
//  static Color snackBarColor;
//  static var snackBar = SnackBar(content: Text(snackBarValue),backgroundColor: snackBarColor,duration: Duration(seconds: 1),);
  static var now = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day
  );
  static String current_shown_word;
  static int said_word_counter = 0;
  static bool DarkMode = false;



  static String add_dictation_word_language = "";
  static String add_dictation_translation_language = "";
  //Auto fill languages
  static List<String> languages_names = new List<String>();
  static List<String> languages_keys = new List<String>();
  static final auto_fill_langs = {
    'auto': 'Automatic',
    'af': 'Afrikaans',
    'sq': 'Albanian',
    'am': 'Amharic',
    'ar': 'Arabic',
    'hy': 'Armenian',
    'az': 'Azerbaijani',
    'eu': 'Basque',
    'be': 'Belarusian',
    'bn': 'Bengali',
    'bs': 'Bosnian',
    'bg': 'Bulgarian',
    'ca': 'Catalan',
    'ceb': 'Cebuano',
    'ny': 'Chichewa',
    'zh-cn': 'Chinese Simplified',
    'zh-tw': 'Chinese Traditional',
    'co': 'Corsican',
    'hr': 'Croatian',
    'cs': 'Czech',
    'da': 'Danish',
    'nl': 'Dutch',
    'en': 'English',
    'eo': 'Esperanto',
    'et': 'Estonian',
    'tl': 'Filipino',
    'fi': 'Finnish',
    'fr': 'French',
    'fy': 'Frisian',
    'gl': 'Galician',
    'ka': 'Georgian',
    'de': 'German',
    'el': 'Greek',
    'gu': 'Gujarati',
    'ht': 'Haitian Creole',
    'ha': 'Hausa',
    'haw': 'Hawaiian',
    'iw': 'Hebrew',
    'hi': 'Hindi',
    'hmn': 'Hmong',
    'hu': 'Hungarian',
    'is': 'Icelandic',
    'ig': 'Igbo',
    'id': 'Indonesian',
    'ga': 'Irish',
    'it': 'Italian',
    'ja': 'Japanese',
    'jw': 'Javanese',
    'kn': 'Kannada',
    'kk': 'Kazakh',
    'km': 'Khmer',
    'ko': 'Korean',
    'ku': 'Kurdish (Kurmanji)',
    'ky': 'Kyrgyz',
    'lo': 'Lao',
    'la': 'Latin',
    'lv': 'Latvian',
    'lt': 'Lithuanian',
    'lb': 'Luxembourgish',
    'mk': 'Macedonian',
    'mg': 'Malagasy',
    'ms': 'Malay',
    'ml': 'Malayalam',
    'mt': 'Maltese',
    'mi': 'Maori',
    'mr': 'Marathi',
    'mn': 'Mongolian',
    'my': 'Myanmar (Burmese)',
    'ne': 'Nepali',
    'no': 'Norwegian',
    'ps': 'Pashto',
    'fa': 'Persian',
    'pl': 'Polish',
    'pt': 'Portuguese',
    'pa': 'Punjabi',
    'ro': 'Romanian',
    'ru': 'Russian',
    'sm': 'Samoan',
    'gd': 'Scots Gaelic',
    'sr': 'Serbian',
    'st': 'Sesotho',
    'sn': 'Shona',
    'sd': 'Sindhi',
    'si': 'Sinhala',
    'sk': 'Slovak',
    'sl': 'Slovenian',
    'so': 'Somali',
    'es': 'Spanish',
    'su': 'Sundanese',
    'sw': 'Swahili',
    'sv': 'Swedish',
    'tg': 'Tajik',
    'ta': 'Tamil',
    'te': 'Telugu',
    'th': 'Thai',
    'tr': 'Turkish',
    'uk': 'Ukrainian',
    'ur': 'Urdu',
    'uz': 'Uzbek',
    'vi': 'Vietnamese',
    'cy': 'Welsh',
    'xh': 'Xhosa',
    'yi': 'Yiddish',
    'yo': 'Yoruba',
    'zu': 'Zulu'
  };
  //
  static List<String> hebrew_letters = new List<String>();

  static bool change_language = true;
}
void show_snack_bar(GlobalKey<ScaffoldState> scaffoldKey,String text,[Color color])
{
  scaffoldKey.currentState.showSnackBar(SnackBar(content: Row(
    children: <Widget>[
      icon_widget(text),
      Text(text),
    ],
  ),
  backgroundColor: color,duration: Duration(seconds: 2),behavior: SnackBarBehavior.floating,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100))));

//  scaffoldKey.currentState.showSnackBar(SnackBar(content: ListTile(
//    //leading: text == "correct" ? Icon(Icons.mood) : Icon(Icons.mood_bad),
//    title: Text(text),
//  ),backgroundColor: color,duration: Duration(seconds: 2),behavior: SnackBarBehavior.floating,));
}
Widget icon_widget(String text)
{
  if (text == "correct")
    {
      return Icon(Icons.mood);
    }
  else if (text == "wrong")
  {
     return Icon(Icons.mood_bad);
  }
  return SizedBox.shrink();
}
String remove_decoration(String translated_word)
{

  String fixed_word = "";
  for (int i = 0;i < translated_word.length;i ++)
  {
    String a = translated_word[i];
    if (GlobalParameters.hebrew_letters.contains(a))
    {
      fixed_word += a;
    }
    print(a);
  }
  return fixed_word;
  //print(fixed_word);
}
class LastDictation
{
  String name;
  List<Word> words_list = new List<Word>();
  bool say_word = false;
  String test_type;
  String from_language;
  String to_language;
  int duration = 6;
  String date;
  List<Check_word> last_dictation_tested_words = new List<Check_word>();

  LastDictation(this.name,this.words_list,this.say_word,this.test_type,this.date,this.last_dictation_tested_words,this.duration,[this.from_language,this.to_language]);

  Map<String, dynamic> toJson() => {
    'name': name,
    'words_list': words_list,
    'say_word': say_word,
    'test_type': test_type,
    'duration': duration,
    'from_language': from_language,
    'to_language': to_language,
    'date': date,
    'last_dictation_tested_words': last_dictation_tested_words,

  };
}
class TestedWord
{
  Word word;
  bool correct;
  TestedWord(this.word,this.correct);
  Map<String, dynamic> toJson() => {
    "word": word,
    "correct": correct,
  };
}
class Dictation
{
  String name;
  List<Word> words_list = new List<Word>();
  bool say_word = false;
  String test_type;
  String from_language;
  String to_language;
  int duration = 6;
  List<Word> last_wrong_words = new List<Word>();
  String date;
  List<Check_word> last_dictation_tested_words = new List<Check_word>();
  String last_dictation_time;
  String last_dictation_type;
  Dictation(this.name,this.words_list,this.say_word,this.test_type,this.duration,this.last_wrong_words,this.date,this.last_dictation_tested_words,[this.from_language,this.to_language,this.last_dictation_time]);

  Map<String, dynamic> toJson() => {
    'name': name,
    'words_list': words_list,
    'say_word': say_word,
    'test_type': test_type,
    "duration": duration,
    'from_language': from_language,
    'to_language': to_language,
    'last_wrong_words' : last_wrong_words,
    "date": date,
    "last_tested_words": last_dictation_tested_words,
    "last_dictation_time" : last_dictation_time,
  };

}
class Check_word
{
  String shown_word;
  String translation;
  String type;
  Check_word(this.translation,this.shown_word,this.type);
  Map<String, dynamic> toJson() => {
    'shown_word': shown_word,
    'translation': translation,
    'type': type,
  };
}
class Word
{
  String word;
  String translation;
  Word(this.word,this.translation);

  Map<String, dynamic> toJson() => {
    'word': word,
    'translation': translation,
  };
}