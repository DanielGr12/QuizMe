//import 'dart:html';

import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:dictation_app/Globals/GlobalColors.dart';
import 'package:dictation_app/Globals/GlobalFunctions.dart';
import 'package:dictation_app/Globals/GlobalParameters.dart';
import 'package:dictation_app/Globals/constant.dart';
import 'package:dictation_app/SaveInFile.dart';
import 'package:dictation_app/Widgets/SelectLanguage.dart';
import 'package:dictation_app/Widgets/my_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:translator/translator.dart';
class NewDictation extends StatefulWidget {
  @override
  _NewDictationState createState() => _NewDictationState();
}

class _NewDictationState extends State<NewDictation> {
  String translation_word;
  var translation_field_val = TextEditingController();
  var word_field_val = TextEditingController();

  //Dictation dictation = new Dictation("", dictation_words, false, "Show the word in your language",6,last_dictation_worng_words,"",clear_tested_words_list);
  List<Word> dictation_words = new List<Word>();
  List<Word> last_dictation_worng_words = new List<Word>();
  List<Check_word> clear_tested_words_list = new List<Check_word>();
  //Dictation dictation;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String word;
  String name;
  String word_language = "";
  String translation_language = "";
  var _controller = TextEditingController();
  var connectivityResult;
  String user_note = "";
  bool auto_play = true;
  //
  void initState() {
    super.initState();


  }
  void update_connectivity() async
  {
    connectivityResult = await (Connectivity().checkConnectivity());
  }
  @override
  Widget build(BuildContext context) {
    user_note = user_note;
    return Scaffold(
        key: _scaffoldKey,
        //backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                title(),
              Padding(
                padding: const EdgeInsets.fromLTRB(20,0,20,15),
                child: TextFormField(
                  controller: _controller,
                  decoration: InputDecoration(
                    labelText: "Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        name = "";
                        _controller.clear();
                      },
                      icon: Icon(Icons.clear),
                    ),
                  ),
                  onFieldSubmitted: (String dictation_name){
                    name = dictation_name;
                  },

                ),
              ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15,15,15,0),
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      side: new BorderSide(
                          color: Colors.white60,
                          width: 1.0),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: ListTile(
                      onTap: (){
                        if (GlobalParameters.change_language == true)
                          {
                            //Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => SelectLanguage("word",GlobalParameters.add_dictation)),).then((res) => refreshPage());

//                            Navigator.push(
//                              context,
//                              MaterialPageRoute(
//                                builder: (context) {
//                                  return SelectLanguage("word",GlobalParameters.add_dictation);
//                                },
//                              ),
                            //);
                          }
                        else{
                          show_snack_bar(_scaffoldKey, "Remove the words");
                        }

                      },
                      leading: Icon(Icons.translate),
                      title: Text("Word language"),
                      subtitle: Text(GlobalParameters.add_dictation_word_language),
                      trailing: Icon(Icons.arrow_forward_ios),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      side: new BorderSide(
                          color: Colors.white60,
                          width: 1.0),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: ListTile(
                      onTap: (){
                        if (GlobalParameters.change_language == true)
                        {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => SelectLanguage("translation",GlobalParameters.add_dictation)),).then((res) => refreshPage());
//                          Navigator.push(
//                            context,
//                            MaterialPageRoute(
//                              builder: (context) {
//                                return SelectLanguage("translation",GlobalParameters.add_dictation);
//                              },
//                            ),
//                          );
                        }
                        else{
                          show_snack_bar(_scaffoldKey, "Remove the words");
                        }
                      },
                      leading: Icon(Icons.translate),
                      title: Text("Translation language"),
                      subtitle: Text(GlobalParameters.add_dictation_translation_language),
                      trailing: Icon(Icons.arrow_forward_ios),
                    ),
                  ),
                ),

                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  height: 320,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    //color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: Colors.grey[500],
                    ),
                  ),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.fromLTRB(25, 10, 4, 20),
                            child: Text("Words", style: TextStyle(
                                fontSize: 20
                            ),),
                          ),
                          Spacer(),
                          IconButton(
                              icon: Icon(Icons.add),
                            onPressed: (){
                              update_connectivity();
                              word_field_val.text = "";
                              translation_field_val.text = "";
                              word = null;
                              translation_word = null;
                              if (((GlobalParameters.add_dictation_word_language != "") && (GlobalParameters.add_dictation_translation_language != "") && (user_note == "Fill the languages")) || (user_note == "Remove the field that you want to translate"))
                                {
                                  user_note = "";
                                }
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context){
                                    return StatefulBuilder(
                                      builder: (context,StateSetter setState)
                                      {
                                        return AlertDialog(

                                            shape: new RoundedRectangleBorder(
                                              borderRadius: new BorderRadius.circular(20),
                                            ),
                                            title: Column(
                                              children: <Widget>[
                                                Container(
                                                    child: Row(
                                                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: <Widget>[
                                                        Text("Add word",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),

                                                      ],
                                                    ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Text(user_note,style: TextStyle(
                                                      color: Colors.redAccent,
                                                      fontSize: 20
                                                  ),),
                                                )
                                              ],
                                            ),
                                            content: SingleChildScrollView(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  Padding(
                                                    padding: const EdgeInsets.fromLTRB(0,5,0,10),
                                                    child: TextFormField(
                                                      decoration: InputDecoration(
                                                        suffixIcon: IconButton(
                                                          onPressed: () {
                                                            word = "";
                                                            word_field_val.clear();
                                                          },
                                                          icon: Icon(Icons.clear),
                                                        ),
                                                        labelText: "Word - ${GlobalParameters.add_dictation_word_language}",
                                                        border: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(16),
                                                        ),
                                                      ),

                                                      onChanged: (String val){

                                                        word = val;
                                                        if (word == "")
                                                          {
                                                            word = null;
                                                          }
                                                        if ((word != "") && (user_note == "Add a word"))
                                                          {
                                                            setState(() {
                                                              user_note = "";
                                                            });
                                                          }
                                                      },
                                                      controller: word_field_val,
                                                    ),
                                                  ),
                                                  Container(
                                                    child: TextFormField(
                                                      decoration: InputDecoration(
                                                        suffixIcon: IconButton(
                                                          onPressed: () {
                                                            translation_word = "";
                                                            translation_field_val.clear();
                                                          },
                                                          icon: Icon(Icons.clear),
                                                        ),
                                                        labelText: "Translation - ${GlobalParameters.add_dictation_translation_language}",
                                                        border: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(16),
                                                        ),
                                                      ),
                                                      onChanged: (String val){
                                                        translation_word = val;
                                                        if (translation_word == "")
                                                        {
                                                          translation_word = null;
                                                        }
                                                        if ((translation_word != "") && (user_note == "Add a word"))
                                                        {
                                                          setState(() {
                                                            user_note = "";
                                                          });
                                                        }
                                                      },
                                                      controller: translation_field_val,
                                                    ),
                                                  ),
//                                                IconButton(
//                                                  icon: Icon(Icons.access_time),
//                                                  onPressed: (){
//                                                    setState(() {
//                                                      user_note = "fbdj";
//                                                    });
//                                                  },
//                                                ),
                                                  auto_fill_chosen_button() == true ? custom_button(Row(
                                                    children: <Widget>[
                                                      Text(
                                                        "Auto fill",
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                            fontSize: 17,
                                                            color: Colors.white
                                                        ),
                                                      ),
                                                    ],
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                  ), () {
                                                    String change;
                                                    change = auto_fill();
                                                    if (change == "fill languages") {
                                                      setState(() {
                                                        user_note = "Fill the languages";
                                                      });
                                                    }
                                                    else if (change == "add word") {
                                                      //WidgetsBinding.instance.addPostFrameCallback((_){
                                                      setState(() {
                                                        user_note = "Add a word";
                                                      });
                                                    }
                                                    else if (change == "remove field") {
                                                      setState(() {
                                                        user_note = "Remove the field that you want to translate";
                                                      });
                                                    }
                                                    FocusScope.of(context).requestFocus(FocusNode());
                                                  }, Colors.lightBlue[300], Colors.blue,) : custom_button(Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                    children: <Widget>[
                                                      Text("Auto fill",
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                          fontSize: 17,
                                                        ),
                                                      ),
                                                      Icon(Icons.signal_cellular_connected_no_internet_4_bar)
                                                    ],
                                                  ), () {}, Colors.grey, Colors.grey[700],),
                                                  //auto_fill_button(),
                                                  custom_button(Row(
                                                    children: <Widget>[
                                                      Text(
                                                        "Add",
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                            fontSize: 17,
                                                            color: Colors.white
                                                        ),
                                                      ),
                                                    ],
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                  ), (){
                                                    bool change_alertdialog;
                                                    change_alertdialog = add_word();
                                                    if (change_alertdialog == false)
                                                      {
                                                        setState(() {
                                                          user_note = "Add a word";
                                                        });
                                                      }

                                                  },Colors.lightBlue[300],Colors.blue,),

                                                ],
                                              ),
                                            )
                                        );
                                      },
                                    );
                                  }
                              );
                            },
                          ),
                        ],
                      ),
                      Container(
                        height: 240,
                        child: Swiper(
                          loop: false,
                          itemBuilder: (BuildContext context, int index) =>
                              WordCard(context, index),
                          itemCount: dictation_words.length,
                          //layout: SwiperLayout.CUSTOM,
                          pagination: new SwiperPagination(
                            builder: new DotSwiperPaginationBuilder(
                                color: Colors.grey, activeColor: Colors.blue),
                          ),
//                            customLayoutOption: CustomLayoutOption(startIndex: 0,stateCount: 2).addRotate([-45/180,0.0,45.0/100]).addTranslate([
////                              Offset(-370.0,-40.0),
////                              Offset(0.0,0.0),
////                              Offset(370,-40.0),
//                            ]),
                          onTap: (var val){
                            setState(() {
                              auto_play = false;
                            });
                          },
//                            onIndexChanged: (int i){
//                              if (i == widget.dictation.words_list.length)
//                                {
//                                  setState(() {
//                                    auto_play = false;
//                                    index = 0;
//                                  });
//                                }
//                            },
                          autoplay: auto_play,
                          viewportFraction: 0.8,
                          scale: 0.9,
                          control: SwiperControl(),
                        ),
                      )
//                      Expanded(
//                        child: Container(
//                          child: WordsListCard(),
//                        )
//
//                      ),//: SizedBox.shrink(),
                    ],
                  ),
                ),

                Padding(
                  child: custom_button(Row(
                    children: <Widget>[
                      Text(
                        "Add dictation",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 17,
                            color: Colors.white
                        ),
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                  ), add_dictation,GlobalParameters.DarkMode ? Colors.blue[700] : Colors.lightBlue[300]
                    ,Colors.blue,),
                  padding: EdgeInsets.all(15),
                ),
                Padding(
                  padding: EdgeInsets.all(15),
                ),
              ],
            ),
          ),
        )
    );
  }
//  Future<bool> returned_button() async
//  {
//    bool a = await auto_fill_chosen_button();
//    return a;
//  }
  void refreshPage() {
    setState(() {
      GlobalParameters.add_dictation_word_language = GlobalParameters.add_dictation_word_language;
      GlobalParameters.add_dictation_translation_language = GlobalParameters.add_dictation_translation_language;
    });
  }
  Widget WordCard(BuildContext context,int index)
  {
    return Container(
      height: 200,
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          side: new BorderSide(color: Colors.white60,
              width: 2.0),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  icon: Icon(Icons.delete_outline,color: Colors.redAccent,),
                  onPressed: (){
                    setState(() {
                      remove_function(dictation_words[index]);
                      //dictation_words.removeAt(index);
                    });
                  },
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10,50,10,15),
                        child: Text("${dictation_words[index].word}",style: TextStyle(fontSize: 25),),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("${dictation_words[index].translation}"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  bool auto_fill_chosen_button()
  {
    if ((connectivityResult == ConnectivityResult.mobile) || (connectivityResult == ConnectivityResult.wifi)) {
      return true;
    }
    return false;
  }
  Widget auto_fill_button()
  {

    if ((connectivityResult == ConnectivityResult.mobile) || (connectivityResult == ConnectivityResult.wifi)) {
       return custom_button(Row(
         children: <Widget>[
           Text(
             "Auto fill",
             textAlign: TextAlign.center,
             style: TextStyle(
                 fontSize: 17,
               color: Colors.white
             ),
           ),
         ],
         mainAxisAlignment: MainAxisAlignment.center,
       ), (){
         String change;
         change = auto_fill();
         if (change == "fill languages")
           {
             setState(() {
               user_note = "Fill the languages";
             });
           }
         else if (change == "add word")
           {
             //WidgetsBinding.instance.addPostFrameCallback((_){
               setState(() {
                 user_note = "Add a word";
               });
               setState(() {
                 user_note = "Add a word";
               });
             //});
//             this.setState(() {
//               user_note = "Add a word";
//             });
           }
       },Colors.lightBlue[300],Colors.blue,);
     }
    return custom_button(Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(
          "Auto fill",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 17,
          ),
        ),
        Icon(Icons.signal_cellular_connected_no_internet_4_bar)
      ],
    ), (){},Colors.grey,Colors.grey[700],);
  }
  Widget WordsListCard()
  {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        //flex: 1,
        children: <Widget>[
          DataTable(
            columns: <DataColumn>[
              DataColumn(
                label:
                Text(
                  'Word',
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 15
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'Translation',
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 15
                  ),
                ),
              ),
            ],
            rows: List.generate(
                dictation_words.length, (index) => dataRow(dictation_words[index])),
          ),
        ],
      ),
    );
  }
  DataRow dataRow(Word cell)
  {
    return DataRow(
      cells: <DataCell>[
        //DataCell(Text(element["Name"])), //Extracting from Map element the value
        DataCell(Text(cell.word,style: TextStyle(
          fontSize: 15
        ),)),
        DataCell(Row(
          children: <Widget>[
            Text(cell.translation, style: TextStyle(fontSize: 15),),
            Spacer(),
            GestureDetector(
              onTap: (){
                remove_function(cell);
                //remove_function(context,"word");
//                bool remove_or_not = remove_function(context,"word");
//                if (remove_or_not == true)
//                {
//                  setState(() {
//                    GlobalParameters.words_to_add_list.remove(cell);
//                  });
//                  SaveInFile.save_in_file();
//                }

              },
              child: Text("Delete",style: TextStyle(
                color: Colors.redAccent
              ),),
            )
//            IconButton(
//              icon: Icon(Icons.remove),
//              onPressed: () {
//                setState(() {
//                  GlobalParameters.words_to_add_list.remove(cell);
//                });
//              },
//            )
          ],
        )),
      ],
    );
  }
  void remove_function(Word cell) async
  {
    //https://stackoverflow.com/questions/53882930/how-to-refresh-flutter-ui-on-alertdialog-close
    final result = await showDialog<bool>(
        context: context,
        builder: (BuildContext context){
          return StatefulBuilder(
            builder: (context,StateSetter setState)
            {
              return AlertDialog(
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20),
                  ),
                  title: Container(
                    child:
                    Text("Are you sure you want to delete this word?",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                  ),
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      FlatButton(
                        child: Text("Yes",style: TextStyle(
                            fontSize: 20,
                            color: kPrimaryColor
                        ),),
                        onPressed: (){
                          Navigator.of(context).pop(true);
                          //Navigator.pop(context);
                          //return true;

                        },
                      ),
                      FlatButton(
                        child: Text("No",style: TextStyle(
                            fontSize: 20,
                            color: kPrimaryColor
                        ),),
                        onPressed: (){
                          //Navigator.pop(context);
                          Navigator.of(context).pop(false);
                        },
                      ),
                    ],
                  )
              );
            },
          );
        }
    );
    if (result == true)
    {
      setState(() {
        GlobalParameters.words_to_add_list.remove(cell);
        dictation_words.remove(cell);

        if (dictation_words.length == 0)
          {
            GlobalParameters.change_language = true;
          }
      });
    }
  }
  void add_dictation()
  {
    if ((GlobalParameters.add_dictation_translation_language != "") && (GlobalParameters.add_dictation_word_language != ""))
      {
        if ((name != null) && (name != ""))
        {
          GlobalParameters.Dictations.forEach((cell){
            if (cell.name == name)
            {


              setState(() {
                //GlobalParameters.snackBarValue = "This dictation name is used in another dictation";
                //GlobalParameters.snackBarColor = Colors.black54;
                _controller.clear();
                name = "";
              });
              show_snack_bar(_scaffoldKey,"This dictation name is used in another dictation");
              //_scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("This dictation name is used in another dictation"),duration: Duration(seconds: 2),));
            }
          });
          if (name != "")
          {
            //GlobalParameters.add_dictation.name = name;
            if (dictation_words.length != 0)
            {
//              List<Dictation> not_updated_dictations = new List<Dictation>();
//              GlobalParameters.Dictations.forEach((cell){
//                not_updated_dictations.add(cell);
//              });
//              GlobalParameters.Dictations.clear();
//              GlobalParameters.Dictations.add(GlobalParameters.add_dictation);
//              not_updated_dictations.forEach((cell){
//                GlobalParameters.Dictations.add(cell);
//              });
              //int dictation_index = GlobalParameters.Dictations.indexOf(GlobalParameters.add_dictation);
//            GlobalParameters.Dictations[dictation_index].words_list.clear();
//            for (int i = 0; i < GlobalParameters.words_to_add_list.length;i ++)
//              {
//                GlobalParameters.Dictations[dictation_index].words_list.add(GlobalParameters.words_to_add_list[i]);
//              }
              List<Dictation> not_updated_dictations = new List<Dictation>();
              GlobalParameters.Dictations.forEach((cell){
                not_updated_dictations.add(cell);
              });
              GlobalParameters.Dictations.clear();
              Dictation dictation = new Dictation(name, dictation_words, false, "Show the word",6,last_dictation_worng_words,"",clear_tested_words_list,GlobalParameters.add_dictation_word_language,GlobalParameters.add_dictation_translation_language);
              GlobalParameters.Dictations.add(dictation);
              not_updated_dictations.forEach((cell){
                GlobalParameters.Dictations.add(cell);
              });
              SaveInFile.save_in_file();
              Navigator.pop(context);
            }
            else
            {
              show_snack_bar(_scaffoldKey,"Add words to the dictation");
              //GlobalParameters.snackBarValue = "Add words to the dictation";
              //_scaffoldKey.currentState.showSnackBar(GlobalParameters.snackBar);
            }
            //name = "";

            //GlobalParameters.add_dictation.words_list.clear();
          }

        }
        else{
          show_snack_bar(_scaffoldKey,"Fill the dictation name");
          //GlobalParameters.snackBarValue = "Fill the dictation name";
          //_scaffoldKey.currentState.showSnackBar(GlobalParameters.snackBar);
        }
      }
    else{
      show_snack_bar(_scaffoldKey,"Fill the languages");
    }
  }
  String auto_fill()
  {
    if (((word == null) || (word == "")) && ((translation_word != null) && (translation_word != "")))
      {
        if ((GlobalParameters.add_dictation_translation_language != "") && (GlobalParameters.add_dictation_word_language != "")) {
          final translator = GoogleTranslator();
          translator.translate(translation_field_val.text, from: language_key("translation",GlobalParameters.add_dictation_word_language,GlobalParameters.add_dictation_translation_language), to: language_key("word",GlobalParameters.add_dictation_word_language,GlobalParameters.add_dictation_translation_language))
              .then((result) {
            setState(() {
              word = result.toString();
              //translation_word = translated_word;
              word_field_val.text = word;

              //String a = translated_word.
              //print(a);
            });
            //add_word();
          });
        }
        else{
          return "fill languages";
          setState(() {
            user_note = "Fill the languages";
          });
          //show_snack_bar(_scaffoldKey,"Fill the languages");
        }
        //show_snack_bar(_scaffoldKey,"First add word");

        //GlobalParameters.snackBarValue = "First add word";
        //_scaffoldKey.currentState.showSnackBar(GlobalParameters.snackBar);
        //Scaffold.of(context).showSnackBar(GlobalParameters.snackBar);
      }
    else if (((word != null) && (word != "")) && ((translation_word == null) || (translation_word == "")))
    {
      if ((GlobalParameters.add_dictation_translation_language != "") && (GlobalParameters.add_dictation_word_language != ""))
        {
          final translator = GoogleTranslator();
          translator.translate(word, from: language_key("word",GlobalParameters.add_dictation_word_language,GlobalParameters.add_dictation_translation_language), to: language_key("translation",GlobalParameters.add_dictation_word_language,GlobalParameters.add_dictation_translation_language)).then((translated_word) {
            setState(() {
              translation_word = translated_word.toString();
              //translation_word = translated_word;
              translation_field_val.text = translation_word;

              //String a = translated_word.
              //print(a);
            });
            //add_word();
          });
        }
        else
          {
            return "fill languages";
            setState(() {
              user_note = "Fill the languages";
            });
            //show_snack_bar(_scaffoldKey,"Fill the languages");
          }

    }
    else if (((word != null) && (word != "")) && ((translation_word != null) || (translation_word != "")))
    {
      return "remove field";
    }
    else
      {
        return "add word";
        show_snack_bar(_scaffoldKey,"First add word");
        //GlobalParameters.snackBarValue = "First add word";
        //Scaffold.of(context).showSnackBar(GlobalParameters.snackBar);
      }
    return "stay";
  }

  String remove_decoration(String translated_word)
  {
    List<String> hebrew_letters = new List<String>();
    hebrew_letters.add("א");
    hebrew_letters.add("ב");
    hebrew_letters.add("ג");
    hebrew_letters.add("ד");
    hebrew_letters.add("ה");
    hebrew_letters.add("ו");
    hebrew_letters.add("ז");
    hebrew_letters.add("ח");
    hebrew_letters.add("ט");
    hebrew_letters.add("י");
    hebrew_letters.add("כ");
    hebrew_letters.add("ל");
    hebrew_letters.add("מ");
    hebrew_letters.add("נ");
    hebrew_letters.add("ס");
    hebrew_letters.add("ע");
    hebrew_letters.add("פ");
    hebrew_letters.add("צ");
    hebrew_letters.add("ק");
    hebrew_letters.add("ר");
    hebrew_letters.add("ש");
    hebrew_letters.add("ת");
    hebrew_letters.add("ך");
    hebrew_letters.add("ף");
    hebrew_letters.add("ץ");
    hebrew_letters.add("ן");
    String fixed_word = "";
    for (int i = 0;i < translated_word.length;i ++)
      {
        String a = translated_word[i];
        if (hebrew_letters.contains(a))
          {
            fixed_word += a;
          }
        print(a);
      }
    return fixed_word;
      //print(fixed_word);
  }
  bool add_word()
  {
      if (word != null)
        {
          if (translation_word != null)
            {
              setState(() {
                GlobalParameters.change_language = false;

                translation_field_val.text = "";
                word_field_val.text = "";
                dictation_words.add(Word(word,translation_word));
                //GlobalParameters.words_to_add_list.add(Word(word,translation_word));
                //GlobalParameters.add_dictation.words_list.add(Word(word,translation_word));
                word = null;
                translation_word = null;
                Navigator.of(context, rootNavigator: true).pop('dialog');
              });

            }
        }
      else{
        //show_snack_bar(_scaffoldKey,"First add word");
        return false;


        //GlobalParameters.snackBarValue = "First add word";
        //_scaffoldKey.currentState.showSnackBar(GlobalParameters.snackBar);
        //Scaffold.of(context).showSnackBar(GlobalParameters.snackBar);
      }
      return true;
  }
//  Widget custom_button(String text,Function on_pressed)
//  {
//    return RaisedButton(
//      onPressed: () {
//        on_pressed();
//      },
//      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
//      padding: const EdgeInsets.all(0.0),
//      child: Container(
//        decoration: BoxDecoration(
//          gradient:  LinearGradient(
//            colors: <Color>[
//              (Colors.lightBlue[300]),
//              Colors.blue,
//              //Color(0xFF1976D2),
//              //kInfectedColor,
//            ],
//          ),
//          borderRadius: BorderRadius.all(Radius.circular(80.0)),
//        ),
//        child: Container(
//          constraints: const BoxConstraints(minWidth: 88.0, minHeight: 36.0), // min sizes for Material buttons
//          alignment: Alignment.center,
//          child: Text(
//            text,
//            textAlign: TextAlign.center,
//            style: TextStyle(
//                fontSize: 17
//            ),
//          ),
//        ),
//      ),
//    );
//  }
//  static void word_submitted(String val)
//  {
//    GlobalParameters.add_words.words_list.add(Word(val));
//  }
//  static void translation_submitted(String val)
//  {
//    GlobalParameters.add_words.words_list.add(Word(val));
//  }
  Widget buildWordCard(BuildContext context, int index)
  {
    return Column(
      children: <Widget>[
        Container(
          child: ListTile(
            leading: Icon(Icons.short_text),
            title: Text("${dictation_words[index].word} - ${dictation_words[index].translation}"),
          ),
        ),
        Divider(endIndent: 20,indent: 20,color: Colors.grey,)
      ],
    );
  }
  Widget buildCard(BuildContext context, int index)
  {
    return Column(
      children: <Widget>[
        Container(
          child: ListTile(
            leading: Icon(Icons.assignment),
            title: Text("${GlobalParameters.Dictations[index].name}"),
          ),
        ),
        Divider(endIndent: 20,indent: 20,color: Colors.grey,)
      ],
    );
  }
  Widget title()
  {
    return MyHeader(
      textTop: Positioned(
          top: 10,
          left: 70,
          child: Text(
            "Add new dictation",
            style: kHeadingTextStyle.copyWith(
                color: Colors.white,
                fontSize: 30
            ),
          ),
        ),
      textBottom: Text(""),
      offset: 2,
      height: 300,
      left_height: 200,
      right_height: 80,
      color_1: Colors.lightBlue,
      color_2: GlobalParameters.DarkMode ? Colors.blue[700] : Colors.lightBlue[200],
      left_widget: back_icon(),
      right_widget: Container(),
    );
//    return ClipPath(
//      clipper: MyClipper(),
//      child: Container(
//        padding: EdgeInsets.only(left: 40, top: 50, right: 20),
//        height: 300,
//        width: double.infinity,
//        decoration: BoxDecoration(
//          gradient: LinearGradient(
//            begin: Alignment.topRight,
//            end: Alignment.bottomLeft,
//            colors: [
//              Colors.lightBlue,
//              Colors.lightBlue[200],
//            ],
//          ),
////          image: DecorationImage(
////
////              alignment: Alignment.bottomLeft,
////               image: AssetImage("assets/dictation_icon.png",),//
////            ),
//
//        ),
//        child: Column(
//          children: <Widget>[
//            Row(
//              mainAxisAlignment: MainAxisAlignment.spaceBetween,
//              //crossAxisAlignment: CrossAxisAlignment.end,
//              children: <Widget>[
//                GestureDetector(
//                  onTap: () {
////                    Navigator.push(
////                      context,
////                      MaterialPageRoute(
////                        builder: (context) {
////                          return InfoScreen();
////                        },
////                      ),
////                    );
//                  },
//                  child: Container(
//
//                      child: IconButton(
//                        icon: Icon(Icons.arrow_back_ios,size:35,color: Colors.black,),
//                        onPressed: (){
//                          Navigator.pop(
//                            context,
//                            MaterialPageRoute(
//                              builder: (context) {
//                                return NewDictation();
//                              },
//                            ),
//                          );
//                        },
//                      )
//                  ),//Icon(Icons.b)//SvgPicture.asset("assets/icons/menu.svg"),
//                ),
//                GestureDetector(
//                  onTap: () {
////                    Navigator.push(
////                      context,
////                      MaterialPageRoute(
////                        builder: (context) {
////                          return InfoScreen();
////                        },
////                      ),
////                    );
//                  },
//                  child: Container(
////                      width: 30,
////                      height: 30,
////                      child: Image.asset("assets/menu_icon.png")
//                  ),//Icon(Icons.b)//SvgPicture.asset("assets/icons/menu.svg"),
//                ),
//                //SizedBox(height: 10),
//
//
//              ],
//            ),
//
//            Expanded(
//              child: Stack(
//                children: <Widget>[
////                  Positioned(
////                    top: (widget.offset < 0) ? 0 : widget.offset,
////                    child: Icon(Icons.battery_alert)
//////                    SvgPicture.asset(
//////                      widget.image,
//////                      width: 230,
//////                      fit: BoxFit.fitWidth,
//////                      alignment: Alignment.topCenter,
//////                    ),
////                  ),
//                  Positioned(
//                    top: 10,
//                    left: 70,
//                    child: Text(
//                      "${textTop} \n${textBottom}",
//                      style: kHeadingTextStyle.copyWith(
//                        color: Colors.white,
//                        fontSize: 30
//                      ),
//                    ),
//                  ),
//                  Container(), // I don't know why it can't work without container
//                ],
//              ),
//            ),
//
//          ],
//        ),
//      ),
//    );
  }
  Widget back_icon()
  {
    return IconButton(
      icon: Icon(Icons.arrow_back_ios, size: 35, color: Colors.white,),
      onPressed: () {
        Navigator.pop(
          context,
          MaterialPageRoute(
            builder: (context) {
              return NewDictation();
            },
          ),
        );
      },
    );
  }
}