import 'dart:convert';
import 'dart:io';

import 'package:dictation_app/Globals/GlobalParameters.dart';
import 'package:path_provider/path_provider.dart';

class SaveInFile
{
  static void save_recent_dictations()
  {
    String json = jsonEncode(GlobalParameters.recentDictations);
    print(json);
    writeRecentDictationsToFile(json);
  }
  static writeRecentDictationsToFile(String text) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/recent_dictations.txt');
    file.writeAsStringSync('');
    await file.writeAsString(text);
  }
  static Future<String> read_recent_dictations_from_file() async {
    String text;
    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      final File file = File('${directory.path}/recent_dictations.txt');
      text = await file.readAsString();
    } catch (e) {
      print("Couldn't read file");
    }
    return text;
  }



  static void save_last_dictation()
  {
    String json = jsonEncode(GlobalParameters.last_saved_dictation);
    print(json);
    writeLastDictationToFile(json);
  }
  static writeLastDictationToFile(String text) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/last_dictation.txt');
    file.writeAsStringSync('');
    await file.writeAsString(text);
  }


  static void save_in_file()
  {
    String json = jsonEncode(GlobalParameters.Dictations.map((e) => e.toJson()).toList());
    print(json);
    writeToFile(json);
  }
  static writeToFile(String text) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/dictations.txt');
    file.writeAsStringSync('');
    await file.writeAsString(text);
  }
}