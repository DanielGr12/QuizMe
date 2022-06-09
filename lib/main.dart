import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:dictation_app/Globals/GlobalParameters.dart';
import 'package:dictation_app/MainTabs/MainSettings.dart';
import 'package:dictation_app/MainTabs/MainPage.dart';
import 'package:dictation_app/SaveInFile.dart';
import 'package:dictation_app/file_write.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'Globals/GlobalColors.dart';
import 'Globals/GlobalFunctions.dart';
import 'Globals/constant.dart';
import 'package:flutter/material.dart';
//removed <string>UIInterfaceOrientationLandscapeLeft</string>
//		<string>UIInterfaceOrientationLandscapeRight</string>
// from ios->Runner->Info.plist
void main(){
  runApp(MyApp());
}
//void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    https://stackoverflow.com/questions/49418332/flutter-how-to-prevent-device-orientation-changes-and-force-portrait
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      //DeviceOrientation.portraitDown,
    ]);
    return StreamBuilder(
      stream: bloc.darkThemeEnabled,
      initialData: false,
      builder: (context, snapshot) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Quizme',
        theme: snapshot.data ? ThemeData.dark() : ThemeData.light(),
//        theme: ThemeData(
//            scaffoldBackgroundColor: kBackgroundColor,
//            fontFamily: "Poppins",
//            textTheme: TextTheme(
//              body1: TextStyle(color: kBodyTextColor),
//            )),
        home: HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  //initializing variables
  final controller = ScrollController();
  double offset = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  //bool darkTheme = false;
  @override
  void initState () {
    super.initState();

    controller.addListener(onScroll);

    //Adding dictations to the dictations list
//    List<Word> words = new List<Word>();
//    words.add(Word("Dog","כלב"));
//    words.add(Word("Cat","חתול"));
//    GlobalParameters.Dictations.add(Dictation("Animals",words,false,"Quiz only on the translations","en","iw"));
//    GlobalParameters.Dictations.add(Dictation("Animals",words,false,"Quiz only on the translations","en","iw"));
//    GlobalParameters.Dictations.add(Dictation("Animals",words,false,"Quiz only on the translations","en","iw"));

      parse_dications_from_file();
      parse_last_dictation_from_file();
      parse_recent_dictation_from_file();

    update_languages();
    //Making tab bar with two tabs
    GlobalParameters.tab_controller = new TabController(vsync: this,length: 2);

    GlobalParameters.hebrew_letters.add("א");
    GlobalParameters.hebrew_letters.add("ב");
    GlobalParameters.hebrew_letters.add("ג");
    GlobalParameters.hebrew_letters.add("ד");
    GlobalParameters.hebrew_letters.add("ה");
    GlobalParameters.hebrew_letters.add("ו");
    GlobalParameters.hebrew_letters.add("ז");
    GlobalParameters.hebrew_letters.add("ח");
    GlobalParameters.hebrew_letters.add("ט");
    GlobalParameters.hebrew_letters.add("י");
    GlobalParameters.hebrew_letters.add("כ");
    GlobalParameters.hebrew_letters.add("ל");
    GlobalParameters.hebrew_letters.add("מ");
    GlobalParameters.hebrew_letters.add("נ");
    GlobalParameters.hebrew_letters.add("ס");
    GlobalParameters.hebrew_letters.add("ע");
    GlobalParameters.hebrew_letters.add("פ");
    GlobalParameters.hebrew_letters.add("צ");
    GlobalParameters.hebrew_letters.add("ק");
    GlobalParameters.hebrew_letters.add("ר");
    GlobalParameters.hebrew_letters.add("ש");
    GlobalParameters.hebrew_letters.add("ת");
    GlobalParameters.hebrew_letters.add("ך");
    GlobalParameters.hebrew_letters.add("ף");
    GlobalParameters.hebrew_letters.add("ץ");
    GlobalParameters.hebrew_letters.add("ן");
    GlobalParameters.hebrew_letters.add("ם");
  }
  void update_languages()
  {

    GlobalParameters.auto_fill_langs.forEach((key,value){
      GlobalParameters.languages_names.add(value);
      GlobalParameters.languages_keys.add(key);
    });
//      List<String> a = new List<String>();
//        GlobalParameters.languages = GlobalParameters.auto_fill_langs.keys;
//      for (int i = 0;i < GlobalParameters.languages._data.length;i ++)
//        {
//          if (GlobalParameters.languages._data[i] &2 == 0)
//            {
//              a.add(GlobalParameters.languages._data[i]);
//            }
//        }
  }
  void parse_dications_from_file() async
  {
    String file_val = await read_dictations_from_file();
    print(file_val);
    if ((file_val != null) && (file_val != ""))
      {
        var data = json.decode(file_val);
        print(data);
        load_dictations(data,"GlobalParameters.Dictations");
      }
  }
  load_dictations(var data,String dictations_list)
  {
      for (int i = 0;i < data.length;i ++)
      {
        //Dictation dictation;
        String name = data[i]["name"];
        //List<dynamic> words_list = data[i]["words_list"];
        List<Word> words_list = new List<Word>();
        for (int j = 0;j < data[i]["words_list"].length;j ++)
        {
          String word = data[i]["words_list"][j]["word"];
          String translation = data[i]["words_list"][j]["translation"];
          words_list.add(Word(word,translation));
        }
        bool say_word = data[i]["say_word"];
        String test_type = data[i]["test_type"];
        int duration = data[i]["duration"];
        String from_language = data[i]["from_language"];
        String to_language = data[i]["to_language"];
        String date = data[i]["date"];
        List<Word> wrong_words_list = new List<Word>();
        for (int j = 0;j < data[i]["last_wrong_words"].length;j ++)
        {
          //Word word = data[i]["last_wrong_words"][j]["word"];
          String word = data[i]["last_wrong_words"][j]["word"];
          String translation = data[i]["last_wrong_words"][j]["translation"];
          //bool correct = data[i]["last_worng_words"][j]["correct"];
          wrong_words_list.add(Word(word,translation));
        }


        List<Check_word> checked_words_list = new List<Check_word>();
        if (data[i]["last_tested_words"] != null)
          {
            for (int j = 0;j < data[i]["last_tested_words"].length;j ++)
            {
              String shown_word = data[i]["last_tested_words"][j]["shown_word"];
              String translation = data[i]["last_tested_words"][j]["translation"];
              String type = data[i]["last_tested_words"][j]["type"];
              checked_words_list.add(Check_word(translation,shown_word,type));
            }
          }
        String last_dictation_time = data[i]["last_dictation_time"];
        if (dictations_list == "GlobalParameters.Dictations")
          {
            GlobalParameters.Dictations.add(Dictation(name,words_list,say_word,test_type,duration,wrong_words_list,date,checked_words_list,from_language,to_language,last_dictation_time));
          }
        else if (dictations_list == "GlobalParameters.recentDictations")
        {
          Dictation dictation_to_add = Dictation(name,words_list,say_word,test_type,duration,wrong_words_list,date,checked_words_list,from_language,to_language);
          GlobalParameters.recentDictations.add(dictation_to_add);
//          setState(() {
//            GlobalParameters.recentDictations.add(Dictation(name,words_list,say_word,test_type,duration,wrong_words_list,date,checked_words_list,from_language,to_language));
//          });

        }

      }


  }
  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  void onScroll() {
    setState(() {
      offset = (controller.hasClients) ? controller.offset : 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData mode = Theme.of(context);
    var whichMode=mode.brightness;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
//      floatingActionButton: FloatingActionButton(
//        child: Icon(Icons.save),
//        onPressed: () {
////          final String membershipKey = 'someuniquestring';
////          SharedPreferences sp = await SharedPreferences.getInstance();
////          sp.setString(membershipKey, json.encode(FileDictation));
//          SaveInFile.save_in_file();
//          //save_in_file();
//          //var json = jsonEncode(GlobalParameters.Dictations, toEncodable: (e) => e.toJsonAttr());
//        },
//      ),
          endDrawer: settings_drawer(),
          key: _scaffoldKey,
          body: MainPage(_scaffoldKey,controller),
//      bottomNavigationBar: Material(
//        color: Colors.grey[100],
//        child: TabBar(
//            indicatorColor: Colors.blueAccent,
//            controller: GlobalParameters.tab_controller, tabs: <Tab>[
//          Tab(icon: new Icon(Icons.home, color: Colors.grey[400],)),
//          Tab(icon: new Icon(Icons.settings, color: Colors.grey[400],)),
//        ]),
//      ),
//      body: Container(
//        child: new TabBarView(controller: GlobalParameters.tab_controller, children: <Widget>[
//          //GlobalParameters.recentDictations.length > 0 ? MainPage(_scaffoldKey,controller) : SizedBox.shrink(),
//          MainPage(_scaffoldKey,controller),
//          //////////////////
//          //End of tab 1
//          //////////////////
//          MainSettings(),
//          //////////////////
//          //End of tab 2
//          //////////////////
//        ],
//       ),
//      )
        ),
      theme: GlobalParameters.DarkMode ? ThemeData.dark() : ThemeData.light(),
    );

  }
  void parse_recent_dictation_from_file() async
  {
    String file_val = await SaveInFile.read_recent_dictations_from_file();
    print(file_val);
    if (file_val != null)
    {
      var data = json.decode(file_val);
      print(data);
      load_dictations(data,"GlobalParameters.recentDictations");
      //load_last_dictation(data);
    }
  }

//  void _checkIfDarkModeEnabled() {
//    final ThemeData theme = Theme.of(context);
//    theme.brightness == appDarkTheme().brightness
//        ? GlobalParameters.DarkMode = true
//        : GlobalParameters.DarkMode = false;
//  }
  Future<String> read_dictations_from_file() async {
    String text;
    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      final File file = File('${directory.path}/dictations.txt');
      text = await file.readAsString();
    } catch (e) {
      print("Couldn't read file");
    }
    return text;
  }
  void parse_last_dictation_from_file() async
  {
    String file_val = await read_last_dictation_from_file();
    print(file_val);
    if (file_val != null)
    {
      var data = json.decode(file_val);
      print(data);
      load_last_dictation(data);
    }
  }
  void load_last_dictation(var data)
  {
    if (data != null)
      {
        String name = data["name"];
        //List<dynamic> words_list = data[i]["words_list"];
        List<Word> words_list = new List<Word>();
        for (int j = 0;j < data["words_list"].length;j ++)
        {
          String word = data["words_list"][j]["word"];
          String translation = data["words_list"][j]["translation"];
          words_list.add(Word(word,translation));
        }
        bool say_word = data["say_word"];
        String test_type = data["test_type"];
        String from_language = data["from_language"];
        String to_language = data["to_language"];
        String date = data["date"];
        int duration = data["duration"];
        List<Check_word> checked_words_list = new List<Check_word>();
        for (int j = 0;j < data["last_dictation_tested_words"].length;j ++)
        {
          String shown_word = data["last_dictation_tested_words"][j]["shown_word"];
          String translation = data["last_dictation_tested_words"][j]["translation"];
          String type = data["last_dictation_tested_words"][j]["type"];
          checked_words_list.add(Check_word(translation,shown_word,type));
        }
        List<Word> wrong_words_list = new List<Word>();
        if (data["last_wrong_words"] != null)
        {
          for (int j = 0;j < data["last_wrong_words"].length;j ++)
          {
            String word = data["last_wrong_words"][j]["word"];
            String translation = data["last_wrong_words"][j]["translation"];
            wrong_words_list.add(Word(word,translation));
          }
        }

        setState(() {
          GlobalParameters.last_dictation = Dictation(name,words_list,say_word,test_type,duration,wrong_words_list,date,checked_words_list,from_language,to_language);
          GlobalParameters.last_saved_dictation = LastDictation(name,words_list,say_word,test_type,date,checked_words_list,duration,from_language,to_language);
        });
      }
      else
        {
          setState(() {
            GlobalParameters.last_dictation = null;
          });

        }



  }
  Future<String> read_last_dictation_from_file() async {
    String text;
    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      final File file = File('${directory.path}/last_dictation.txt');
      text = await file.readAsString();
    } catch (e) {
      print("Couldn't read file");
    }
    return text;
  }
  Widget settings_drawer() {
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30), bottomLeft: Radius.circular(30)),
      child: new Drawer(
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(15),
            ),
//            new Divider(color: kTextLightColor,),
//            ListTile(
//              leading: Icon(Icons.settings),
//              title: Text("App settings"),
//              trailing: Icon(Icons.arrow_forward_ios),
//              onTap: () {
//                Navigator.push(
//                  context,
//                  MaterialPageRoute(
//                    builder: (context) {
//                      return MainSettings();
//                    },
//                  ),
//                );
//              },
//            ),
//            new Divider(color: kTextLightColor,),
//            Padding(
//              padding: EdgeInsets.all(15),
//            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.info_outline,color: Colors.grey,),
                Padding(
                  padding: EdgeInsets.all(5),
                ),
                Text("Version: ${GlobalParameters.AppVersion}",style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 17
                ),)
              ],
            ),
            Padding(
              padding: EdgeInsets.all(15),
            ),
            ListTile(
              leading: GlobalParameters.DarkMode == false ? Icon(Icons.wb_sunny,size: 30,color: Colors.orangeAccent,) : Icon(Icons.brightness_3,size: 30,color: Colors.yellow[100],),
              title: Text("Dark Mode"),
              trailing: Switch(value: GlobalParameters.DarkMode,onChanged: (value){
                setState(() {
                  GlobalParameters.DarkMode = value;
                });
              },),
            ),

          ],
        ),
      ),
    );
  }
}
class Bloc {
  final _themeController = StreamController<bool>();
  get changeTheme => _themeController.sink.add;
  get darkThemeEnabled => _themeController.stream;
}

final bloc = Bloc();