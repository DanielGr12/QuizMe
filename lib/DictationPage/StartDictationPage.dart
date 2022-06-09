import 'package:dictation_app/DictationPage/DictationQuiz.dart';
import 'package:dictation_app/DictationPage/OnFinished.dart';
import 'package:dictation_app/Globals/GlobalColors.dart';
import 'package:dictation_app/Globals/GlobalFunctions.dart';
import 'package:dictation_app/Globals/GlobalParameters.dart';
import 'package:dictation_app/Globals/constant.dart';
import 'package:dictation_app/SaveInFile.dart';
import 'package:dictation_app/Widgets/my_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:translator/translator.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:connectivity/connectivity.dart';
class DictationInfo extends StatefulWidget {
  Dictation dictation;
  DictationInfo(this.dictation);
  @override
  _DictationInfoState createState() => _DictationInfoState();
}

class _DictationInfoState extends State<DictationInfo> with SingleTickerProviderStateMixin {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var translation_field_val = TextEditingController();
  var word_field_val = TextEditingController();
  String word;
  String translation_word;
  var connectivityResult;
  String user_note = "";
  bool auto_play = true;
  TextEditingController _wordFieldController = TextEditingController();
  TextEditingController _translationFieldController = TextEditingController();
  String drawer_alert = "";
  AnimationController drawer_alert_controller;
  Animation drawer_alert_animation;
  @override
  void initState() {
    drawer_alert_controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    drawer_alert_animation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(drawer_alert_controller);
  }

  @override
  void dispose() {
    drawer_alert_controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        endDrawer: settings_drawer(),
        //backgroundColor: GlobalParameters.DarkMode ? kBackgroundDarkColor : Colors.white,
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                title("Dictation info:", widget.dictation.name),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  height: 320,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    //color: GlobalParameters.DarkMode ? kBackgroundDarkColor : Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: Colors.grey[500],
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[

                        Row(
                          children: <Widget>[

                            Padding(
                              padding: EdgeInsets.fromLTRB(25, 10, 4, 4),
                              child: Text("Words", style: TextStyle(
                                  fontSize: 20
                              ),),
                            ),
                            Spacer(),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () {
                                update_connectivity();
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return StatefulBuilder(
                                        builder: (context, setState) {
                                          return AlertDialog(

                                              shape: new RoundedRectangleBorder(
                                                borderRadius: new BorderRadius
                                                    .circular(20),
                                              ),
                                              title: Column(

                                                children: <Widget>[
                                                  Container(
                                                      child: Row(
                                                        children: <Widget>[
                                                          Text("Add a word",
                                                            style: TextStyle(
                                                                fontSize: 25,
                                                                fontWeight: FontWeight
                                                                    .bold),),
                                                        ],
                                                      ),
                                                  ),
                                                  user_note != "" ? Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Text(user_note,style: TextStyle(
                                                        color: Colors.redAccent,
                                                        fontSize: 20
                                                    ),),
                                                  ) : SizedBox.shrink()
                                                ],
                                              ),
                                              content: SingleChildScrollView(
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: <Widget>[
                                                      Padding(
                                                        padding: const EdgeInsets
                                                            .fromLTRB(0, 0, 0, 10),
                                                        child: TextFormField(
                                                          decoration: InputDecoration(
                                                            suffixIcon: IconButton(
                                                              onPressed: () {
                                                                word = "";
                                                                word_field_val.clear();
                                                              },
                                                              icon: Icon(Icons.clear),
                                                            ),
                                                            labelText: "Word - ${widget.dictation.from_language}",
                                                            border: OutlineInputBorder(
                                                              borderRadius: BorderRadius
                                                                  .circular(16),
                                                            ),
                                                          ),
                                                          onChanged: (String val) {
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
                                                            if ((word == null) && (user_note == "Remove the field that you want to translate"))
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
                                                            labelText: "Translation - ${widget.dictation.to_language}",
                                                            border: OutlineInputBorder(
                                                              borderRadius: BorderRadius
                                                                  .circular(16),
                                                            ),
                                                          ),
                                                          onChanged: (String val) {
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
                                                            if ((translation_word == null) && (user_note == "Remove the field that you want to translate"))
                                                            {
                                                              setState(() {
                                                                user_note = "";
                                                              });
                                                            }
                                                          },
                                                          controller: translation_field_val,
                                                        ),
                                                      ),

                                                      //auto_fill_button(),
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
                                                        if (change == "add word") {
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
                                                      }, Colors.orange, kInfectedColor,) : custom_button(Row(
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

                                                      //custom_button("Auto fill", auto_fill),
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

                                                      },Colors.orange, kInfectedColor),
//                                                  custom_button(Row(
//                                                    children: <Widget>[
//                                                      Text(
//                                                        "Add",
//                                                        textAlign: TextAlign
//                                                            .center,
//                                                        style: TextStyle(
//                                                            fontSize: 17,
//                                                            color: Colors.white
//                                                        ),
//                                                      ),
//                                                    ],
//                                                    mainAxisAlignment: MainAxisAlignment
//                                                        .center,
//                                                  ), add_word, Colors.orange,
//                                                    kInfectedColor,),

                                                    ],
                                                  ),
                                                ),

                                          );
                                        },
                                      );
                                    }
                                ).then((val){
                                  user_note = "";
                                });
                              },
                            ),
                          ],
                        ),
                        Container(
                          height: 250,
                          child: Swiper(
                            loop: false,
                            itemBuilder: (BuildContext context, int index) =>
                              WordCard(context, index),
                            itemCount: widget.dictation.words_list.length,
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
//                        Container(
//                          height: 200.0,
//                          child: PageView.builder(
//                            //physics: NeverScrollableScrollPhysics(),
//                              //scrollDirection: Axis.horizontal,
//                              controller: PageController(viewportFraction: 0.7),
//                              itemCount: widget.dictation.words_list.length,
//                              onPageChanged: (int index) => setState(() => _index = index),
//                              itemBuilder: (BuildContext context, int index) =>
//                                  horizontal_listview_card(context, index)),
//                        ),
//                        Container(
//                          height: 200.0,
//                          child: ListView.builder(
//                            //physics: NeverScrollableScrollPhysics(),
//                              scrollDirection: Axis.horizontal,
//                              shrinkWrap: true,
//                              itemCount: widget.dictation.words_list.length,
//                              itemBuilder: (BuildContext context, int index) =>
//                                  horizontal_listview_card(context, index)),
//                        ),
                        //WordsListCard(widget.dictation.words_list),

                      ],
                    ),
                  ),
                ),
                widget.dictation.date != "" ? Padding(
                  padding: EdgeInsets.all(15),
                ) : SizedBox.shrink(),
                widget.dictation.date != "" ? Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  //height: 250,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    //color: GlobalParameters.DarkMode ? kBackgroundDarkColor : Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: Colors.grey[500],
                    ),
                  ),
                  child: ListTile(
                    leading: Icon(Icons.assignment),
                    title: Text("Last dictation - ${widget.dictation.date}"),
                    trailing: GestureDetector(
                      child: Text("See details", style: TextStyle(
                          color: kPrimaryColor
                      ),),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return OnFinished(widget.dictation,
                                  widget.dictation.last_dictation_tested_words,
                                  "last dictation");
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ) : SizedBox.shrink(),
//                widget.dictation.date != "" ? Container(
//                          margin: EdgeInsets.symmetric(horizontal: 20),
//                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//                          //height: 250,
//                          width: double.infinity,
//                          decoration: BoxDecoration(
//                            color: Colors.white,
//                            borderRadius: BorderRadius.circular(25),
//                            border: Border.all(
//                              color: Colors.grey[500],
//                            ),
//                          ), child:
//                  ListTile(
//                    leading: Icon(Icons.assignment),
//                    title: Text("Last dictation"),
//                    trailing: Row(
//                      children: <Widget>[
//                        Text(widget.dictation.date),
//                        IconButton(
//                          icon: Icon(Icons.arrow_forward_ios),
//                          onPressed: (){
//                            Navigator.push(
//                              context,
//                              MaterialPageRoute(
//                                builder: (context) {
//                                  return OnFinished(widget.dictation,widget.dictation.last_dictation_tested_words,"last dictation");
//                                },
//                              ),
//                            );
//                          },
//                        )
//                      ],
//                    ),
//                  ),
//                ) : SizedBox.shrink(),
                Padding(
                  padding: EdgeInsets.all(15),
                ),
                widget.dictation.say_word == true ? Padding(
                  padding: const EdgeInsets.fromLTRB(0,0,0,15),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    //height: 20,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      //color: GlobalParameters.DarkMode ? kBackgroundDarkColor : Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: Colors.grey[500],
                      ),
                    ),
                    child: Column(
                      children: <Widget>[
                        Text(
                            "Select how much time the system will untill it will say the word again"),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 8, 8, 30),
                              child: NumberPicker.integer(
                                  initialValue: widget.dictation.duration != null
                                      ? widget.dictation.duration
                                      : 6,
                                  minValue: 6,
                                  maxValue: 30,
                                  onChanged: (newValue) =>
                                      setState(() =>
                                      widget.dictation.duration = newValue)),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 30, 0, 8),
                              child: Text("Seconds"),
                            )
                          ],
                        ),
                        Text("Current delay between words: ${widget.dictation
                            .duration}"),
                      ],
                    ),
                  ),
                ) : SizedBox.shrink(),
//              Padding(
//                  padding: EdgeInsets.all(15),
//                ),
                Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
                      child: RaisedButton(
                        onPressed: () {
                          if ((can_spell() == false) &&
                              (widget.dictation.say_word == true)) {
                            show_snack_bar(scaffoldKey,
                                "Change the shown word or the test type");
                          }
                          else if (widget.dictation.words_list.length > 0) {
                            List<Check_word> check_word_list = new List<
                                Check_word>();
                            GlobalParameters.last_dictation_date =
                            "${GlobalParameters.now.day}/${GlobalParameters.now
                                .month}/${GlobalParameters.now.year}";
                            GlobalParameters.last_dictation = widget.dictation;


                            GlobalParameters.last_saved_dictation =
                                LastDictation(
                                    GlobalParameters.last_dictation.name,
                                    GlobalParameters.last_dictation.words_list,
                                    GlobalParameters.last_dictation.say_word,
                                    GlobalParameters.last_dictation.test_type,
                                    GlobalParameters.last_dictation_date,
                                    check_word_list,
                                    GlobalParameters.last_dictation.duration);
                            //widget.dictation.last_dictation_tested_words.clear();
//                                check_word_list.forEach((cell)
//                                {
//                                  widget.dictation.last_dictation_tested_words.add(cell);
//                                });
                            widget.dictation.date =
                                GlobalParameters.last_dictation_date;


                            DateTime now = DateTime.now();
                            //dynamic currentTime = DateFormat.jm().format(DateTime.now());
                            widget.dictation.last_dictation_time = now
                                .toString();
                            SaveInFile.save_in_file();
                            //widget.dictation.last_dictation_tested_words = check_word_list;
                            SaveInFile.save_last_dictation();


                            //widget.dictation.date = "${GlobalParameters.now.day}/${GlobalParameters.now.month}/${GlobalParameters.now.year}";
                            //SaveInFile.save_last_dictation();
                            GlobalParameters.tested_words_count = 0;
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return DictationQuiz(widget.dictation);
                                },
                              ),
                            );
                          }
                          else {
                            show_snack_bar(scaffoldKey,
                                "There are no words in this dictation");
                            //snack_bar("There are no words in this dictation");
                          }
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(80.0)),
                        padding: const EdgeInsets.all(0.0),
                        child: Ink(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: <Color>[
                                Colors.orange,
                                kInfectedColor,
                              ],
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(
                                80.0)),
                          ),
                          child: Container(
                            constraints: const BoxConstraints(minWidth: 88.0,
                                minHeight: 36.0),
                            // min sizes for Material buttons
                            alignment: Alignment.center,
                            child: Row(
                              children: <Widget>[
                                Text(
                                  "Start dictation",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.white
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(10,0,0,0),
                                  child: Icon(Icons.assignment,color: Colors.white,),
                                )
                              ],
                              mainAxisAlignment: MainAxisAlignment.center,
                            )
                          ),
                        ),
                      ),
                    )
                  ],
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
  bool can_spell()
  {
    for (int i = 0;i < widget.dictation.words_list.length;i ++)
      {
        if (widget.dictation.test_type == "Show the word")
          {
            if (check_if_in_english(widget.dictation.words_list[i].word) != true)
              {
                return false;
              }
          }
        else if (widget.dictation.test_type == "Show the translation")
        {
          if (check_if_in_english(widget.dictation.words_list[i].translation) != true)
          {
            return false;
          }
        }
      }
    return true;
  }
  void update_connectivity() async
  {
    connectivityResult = await (Connectivity().checkConnectivity());
  }

  Widget auto_fill_button() {
    if ((connectivityResult == ConnectivityResult.mobile) ||
        (connectivityResult == ConnectivityResult.wifi)) {
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
      ), auto_fill, Colors.orange, kInfectedColor,); //

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
    ), () {}, Colors.grey, Colors.grey[700],);
  }

  Widget settings_drawer() {
    return ClipRRect(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30), bottomLeft: Radius.circular(30)),
        child: new Drawer(

          child: new ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(15),
              ),


//          Padding(
//            padding: const EdgeInsets.all(8.0),
//            child: DropdownButton<String>(
//              hint: widget.dictation.say_word == true ? Text("Only write on a paper with timer") : Text("Answer in the app without timer"),
//              items: <String>["Only write on a paper with timer", "Answer in the app without timer"].map((String value) {
//                return new DropdownMenuItem<String>(
//                  value: value,
//                  child: new Text(value),
//                );
//              }).toList(),
//
//              onChanged: (newValue) {
//                setState(() {
//                  if (newValue == "Only write on a paper with timer")
//                    {
//                      widget.dictation.say_word = true;
//                    }
//                  else if (newValue == "Answer in the app without timer")
//                  {
//                    widget.dictation.say_word = false;
//                  }
//
//                });
//                SaveInFile.save_in_file();
//              },
//            ),
//          ),


              ListTile(
                leading: widget.dictation.say_word == true ? Icon(Icons.volume_up) : Icon(Icons.keyboard),
                title: Text("Quiz type"),
                subtitle: widget.dictation.say_word == true ? Text(
                    "Spell (Only in English)") : Text(
                    "Write"),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  showModalBottomSheet(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
                      ),
                      context: context,
                      builder: (context) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            active_auto_dictation(),
                            Divider(height: 5,
                              color: Colors.grey,
                              endIndent: 30,
                              indent: 30,),
                            ListTile(
                              leading: Icon(Icons.keyboard),
                              title: Text("Write"),
                              onTap: () {
                                //Close the showModalBottomSheet widget
                                Navigator.pop(context);

                                setState(() {
                                  widget.dictation.say_word = false;
                                });
                                SaveInFile.save_in_file();
                              },
                              trailing: widget.dictation.say_word == false ? Icon(
                                Icons.check, color: kPrimaryColor,) : SizedBox
                                  .shrink(),
                            ),
                          ],
                        );
                      }
                  );
                },
              ),
//          SwitchListTile(
//            title: Text('Auto dictation'),
//            subtitle: Text('Automatically say the shown word every selected time'),
//            secondary: Icon(Icons.volume_up),
//            value: widget.dictation.say_word,
//            onChanged: (value) {
//              setState(() {
//                if (value == true)
//                    widget.dictation.duration = 6;
//
//                widget.dictation.say_word = value;
//              });
//              SaveInFile.save_in_file();
//            },
//            dense: true,
//          ),


//          SwitchListTile(
//            title: Text('Auto dictation'),
//            subtitle: Text('The app will say the word every selected time'),
//            secondary: Icon(Icons.timelapse),
//            value: widget.dictation.auto_dictaion,
//            onChanged: (value) {
//              setState(() {
//                widget.dictation.say_word = value;
//              });
//              SaveInFile.save_in_file();
//            },
//            dense: true,
//          ),
              new Divider(color: kTextLightColor,),
              ListTile(
                title: Text("Shown word"),
                subtitle: Text(widget.dictation.test_type),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  showModalBottomSheet(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
                      ),
                      context: context,
                      builder: (context) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              title: Text("Show the word"),
                              onTap: () {
                                //Close the showModalBottomSheet widget
                                on_type_changed("Show the word");
                              },
                              trailing: widget.dictation.test_type ==
                                  "Show the word" ? Icon(
                                Icons.check, color: kPrimaryColor,) : SizedBox
                                  .shrink(),
                            ),
                            Divider(height: 5,
                              color: Colors.grey,
                              endIndent: 30,
                              indent: 30,),
                            ListTile(
                              title: Text("Show the translation"),
                              onTap: () {
                                //Close the showModalBottomSheet widget
                                on_type_changed("Show the translation");

                              },
                              trailing: widget.dictation.test_type ==
                                  "Show the translation"
                                  ? Icon(Icons.check, color: kPrimaryColor,)
                                  : SizedBox.shrink(),
                            ),
                            Divider(height: 5,
                              color: Colors.grey,
                              endIndent: 30,
                              indent: 30,),
                            ListTile(
                              title: Text("Randomly select"),
                              onTap: () {
                                //Close the showModalBottomSheet widget
                                on_type_changed("Randomly select");
                              },
                              trailing: widget.dictation.test_type ==
                                  "Randomly select" ? Icon(
                                Icons.check, color: kPrimaryColor,) : SizedBox
                                  .shrink(),
                            ),

                          ],
                        );
                      }
                  );
                },
              ),
//          DropdownButton<String>(
//            hint: Text(widget.dictation.test_type),
//            items: <String>["Show the word", "Show the translation", "Randomly select"].map((String value) {
//              return new DropdownMenuItem<String>(
//                value: value,
//                child: new Text(value),
//              );
//            }).toList(),
//
//            onChanged: (newValue) {
//              setState(() {
//                widget.dictation.test_type = newValue;
//              });
//              SaveInFile.save_in_file();
//            },
//          ),
              Padding(
                padding: EdgeInsets.all(8),
              ),
              new Divider(color: kTextLightColor,),
              new ListTile(
                title: new Text("Close"),
                trailing: new Icon(Icons.close),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              //Spacer(),
              Padding(
                padding: EdgeInsets.all(15),
              ),
              Center(
                child: FadeTransition(
                      opacity: drawer_alert_animation,
                      child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                          //height: 250,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(
                              color: Colors.grey[500],
                            ),
                          ),
                        child: Text(drawer_alert,style: TextStyle(
                            fontSize: 17
                        ),),
                      ),
//                      child: Text(drawer_alert,style: TextStyle(
//                          fontSize: 17
//                      ),)
                  ),



              ),
            ],
          ),
        ),
      );
  }
  void on_type_changed(String type)
  {
    Navigator.pop(context);
    if (type == "Show the word")
      {
        if (widget.dictation.from_language != "English")
          {
            widget.dictation.say_word = false;
            setState(() {
              drawer_alert = "Test type has been changed";
              drawer_alert_controller.forward();
            });
            Future.delayed(const Duration(milliseconds: 1500), () {
              setState(() {
                drawer_alert_controller.reverse();
                //drawer_alert = "";

              });
            });
          }
      }
    else if (type == "Show the translation")
    {
      if (widget.dictation.to_language != "English")
      {
        widget.dictation.say_word = false;
        setState(() {
          drawer_alert = "Test type has been changed";
          drawer_alert_controller.forward();
        });
        Future.delayed(const Duration(milliseconds: 2000), () {
          setState(() {
            drawer_alert_controller.reverse();
//            drawer_alert = "";
//            drawer_alert_controller.forward();
          });
        });
      }
    }
    else
    {
      if ((widget.dictation.to_language != "English") || (widget.dictation.from_language != "English"))
      {
        widget.dictation.say_word = false;
        setState(() {
          drawer_alert = "Test type has been changed";
          drawer_alert_controller.forward();
        });
        Future.delayed(const Duration(milliseconds: 2000), () {
          setState(() {
            drawer_alert_controller.reverse();
//            drawer_alert = "";
//            drawer_alert_controller.forward();
          });
        });
      }
    }

    setState(() {
      widget.dictation.test_type = type;
    });
    SaveInFile.save_in_file();
  }
  bool checkIfInEnglish()
  {
    bool inEnglish = true;
    for (int i = 0; i < widget.dictation.words_list.length; i++)
    {
      if (widget.dictation.test_type == "Show the word")
      {
        for (int j = 0; j < widget.dictation.words_list[i].word.length; j++)
        {
          widget.dictation.words_list[i].word.runes.forEach((int rune)
          {
            var character = new String.fromCharCode(rune);
            if ((character.codeUnitAt(0) >= 'a'.codeUnitAt(0) && character.codeUnitAt(0) <= 'z'.codeUnitAt(0)) ||
                (character.codeUnitAt(0) >= 'A'.codeUnitAt(0) && character.codeUnitAt(0) <= 'Z'.codeUnitAt(0))) {
            }
            else {
              inEnglish = false;
              //break;
            }
          });
          if (inEnglish == false)
            {
              break;
            }
        }
      }
      else if (widget.dictation.test_type == "Show the translation")
        {
          for (int j = 0; j < widget.dictation.words_list[i].translation.length; j++)
          {
            widget.dictation.words_list[i].translation.runes.forEach((int rune)
            {
              var character = new String.fromCharCode(rune);
              if ((character.codeUnitAt(0) >= 'a'.codeUnitAt(0) && character.codeUnitAt(0) <= 'z'.codeUnitAt(0)) ||
                  (character.codeUnitAt(0) >= 'A'.codeUnitAt(0) && character.codeUnitAt(0) <= 'Z'.codeUnitAt(0))) {
              }
              else {
                inEnglish = false;
              }
            });
            if (inEnglish == false)
            {
              break;
            }
          }
        }
      if (inEnglish == false)
      {
        break;
      }
    }
    return inEnglish;
  }

  Widget active_auto_dictation()
  {
    if (checkIfInEnglish())
      {
        return ListTile(
        leading: Icon(Icons.volume_up),
        title: Text("Spell (Only in English)"),
        onTap: () {
          //Close the showModalBottomSheet widget
          Navigator.pop(context);

          setState(() {
            widget.dictation.say_word = true;
          });
          SaveInFile.save_in_file();
        },
        trailing: widget.dictation.say_word == true
            ? Icon(
                Icons.check,
                color: kPrimaryColor,
              )
            : SizedBox.shrink(),
      );
    }
    // if (widget.dictation.test_type == "Show the word")
    //   {
    //     if (widget.dictation.from_language == "English")
    //       {
    //         return ListTile(
    //           leading: Icon(Icons.volume_up),
    //           title: Text("Spell (Only in English)"),
    //           onTap: (){
    //             //Close the showModalBottomSheet widget
    //             Navigator.pop(context);
    //
    //             setState(() {
    //               widget.dictation.say_word = true;
    //             });
    //             SaveInFile.save_in_file();
    //           },
    //           trailing: widget.dictation.say_word == true ? Icon(Icons.check,color: kPrimaryColor,) : SizedBox.shrink(),
    //         );
    //       }
    //   }
    // else if (widget.dictation.test_type == "Show the translation")
    // {
    //   if (widget.dictation.to_language == "English")
    //   {
    //     return ListTile(
    //       leading: Icon(Icons.volume_up),
    //       title: Text("Spell (Only in English)"),
    //       onTap: (){
    //         //Close the showModalBottomSheet widget
    //         Navigator.pop(context);
    //
    //         setState(() {
    //           widget.dictation.say_word = true;
    //         });
    //         SaveInFile.save_in_file();
    //       },
    //       trailing: widget.dictation.say_word == true ? Icon(Icons.check,color: kPrimaryColor,) : SizedBox.shrink(),
    //     );
    //   }
    // }
    return ListTile(
      leading: Icon(Icons.volume_up),
      title: Text("Spell (Only in English)",style: TextStyle(
        color: Colors.grey
      ),),
      onTap: (){
        //Close the showModalBottomSheet widget
//        Navigator.pop(context);
//
//        setState(() {
//          widget.dictation.say_word = true;
//        });
//        SaveInFile.save_in_file();
      },
      trailing: widget.dictation.say_word == true ? Icon(Icons.check,color: kPrimaryColor,) : SizedBox.shrink(),
    );
  }
  Widget bottom_item(BuildContext context, int index)
  {
    return ListTile(
        leading: Icon(Icons.featured_play_list),

//      IconButton(
//        icon: Icon(Icons.remove),
//        onPressed: (){
//          on_removed(index);
//        },
//      ),
    );
  }
//  void change_val(String value)
//  {
//    switch(value)
//    {
//      case "Quiz only on the translations":
//        {
//          widget.dictation.test_on = quiz_variations.only_translation;
//        }
//        break;
//      case "Quiz only on the words":
//        {
//          widget.dictation.test_on = quiz_variations.only_words;
//        }
//        break;
//      case "Quiz on both":
//        {
//          widget.dictation.test_on = quiz_variations.both;
//        }
//        break;
//    }
//  }
//  String getStringFromEnum(quiz_variations quiz) {
//    switch (quiz) {
//      case quiz_variations.only_translation: return "Quiz only on the translations";
//      case quiz_variations.only_words: return "Quiz only on the words";
//      case quiz_variations.both: return "Quiz on both";
//    }
//    return "Quiz only on the translations";
//  }
//  Widget hint_val()
//  {
//    switch(quiz_variations)
//    {
//      case quiz_variations.only_translation:
//        {
//          return Text("Quiz only on the translations");
//        }
//        break;
//      case quiz_variations.only_words:
//        {
//          return Text("Quiz only on the words");
//        }
//        break;
//      case quiz_variations.both:
//        {
//          return Text("Quiz on both");
//        }
//        break;
//    }
//    return Text("Quiz only on the translations");
//  }
  Widget WordCard(BuildContext context,int index)
  {
    return Container(
      //height: 100,
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          side: new BorderSide(color: Colors.white60,
              width: 4.0),
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
                    remove_function(widget.dictation.words_list[index]);
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
                        child: widget.dictation.test_type == "Show the word" ? Text("${widget.dictation.words_list[index].word}",style: TextStyle(fontSize: 25),) : Text("${widget.dictation.words_list[index].translation}",style: TextStyle(fontSize: 25)) ,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: widget.dictation.test_type == "Show the word" ? Text("${widget.dictation.words_list[index].translation}",style: TextStyle(fontSize: 17),) : Text("${widget.dictation.words_list[index].word}",style: TextStyle(fontSize: 17),),
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
  Widget WordsListCard(List<Word> words_list)
  {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        DataTable(

          //dataRowHeight: rowHeight,
          columns: <DataColumn>[
            DataColumn(
              label:
              Column(
                children: <Widget>[
                  Text(
                    'Word',// - ${widget.dictation.from_language}
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 15,
                    ),
                  ),
                  Text(
                    widget.dictation.from_language,// - ${widget.dictation.from_language}
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 15,
                    ),
                  )
                ],
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              ),
            ),
            DataColumn(
              label:Column(
                children: <Widget>[
                  Text(
                    'Translation',// - ${widget.dictation.from_language}
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    widget.dictation.to_language,// - ${widget.dictation.from_language}
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 15,
                    ),
                  )
                ],
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              ),
            ),
          ],
          rows: List.generate(
              words_list.length, (index) => dataRow(words_list[index])),
            

        ),
      ],
    );
  }
  DataRow dataRow(Word cell)
  {
    return DataRow(
      cells: <DataCell>[
        DataCell(Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(cell.word,style: TextStyle(fontSize: 15),),
        ),
        ),
        DataCell(Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
              children: <Widget>[
                Expanded(child: Text(cell.translation,style: TextStyle(fontSize: 15),)),
                Spacer(),
                GestureDetector(
                  child: Text("Delete",style: TextStyle(
                    color: kDeathColor
                  ),),
                  onTap: (){
//                Future<bool> a = alertdialog_func();
//
//
//                if (a == true)
//                {
//                  setState(() {
//                    widget.dictation.words_list.remove(cell);
//                  });
//                  SaveInFile.save_in_file();
//                }

                    remove_function(cell);
//                setState(() {
//                  widget.dictation.words_list.remove(cell);
//                });
//
                  },
                )
//            IconButton(
//              icon: Icon(Icons.remove),
//              onPressed: (){
//                setState(() {
//                  widget.dictation.words_list.remove(cell);
//                });
//              },
//            )
              ],
            ),
        ),
        ),
      ],
    );
  }
//  Future<bool> alertdialog_func() async
//  {
//    bool remove_or_not = await remove_function(context,"word");
//    return remove_or_not;
//  }

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
            widget.dictation.words_list.remove(cell);
          });
        }
    }
  Widget title(String textTop, String textBottom)
  {
    return MyHeader(
      textTop: Positioned(
        top: 10,
        left: 70,
        child: Text(
          "Dictation info:",
          style: kHeadingTextStyle.copyWith(
              color: Colors.white,
              fontSize: 30
          ),
        ),
      ),
      textBottom: Positioned(
        top: 10,
        left: 70,
        child: Text(
          "\n\n               ${widget.dictation.name}",
          style: kHeadingTextStyle.copyWith(
              color: Colors.white,
              fontSize: 30
          ),
        ),
      ),
      offset: 2,
      height: 300,
      left_height: 200,
      right_height: 80,
      color_1: Colors.orange,
      color_2: GlobalParameters.DarkMode ? Colors.orangeAccent[700] : Colors.orangeAccent[100],
      left_widget: back_icon(),
      right_widget: settings_icon(),
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
//              Colors.orange,
//              Colors.orangeAccent[100],
//            ],
//          ),
//        ),
//        child: Column(
//          children: <Widget>[
//            Row(
//              mainAxisAlignment: MainAxisAlignment.spaceBetween,
//              //crossAxisAlignment: CrossAxisAlignment.end,
//              children: <Widget>[
//                GestureDetector(
//                  onTap: () {
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
//                                return DictationInfo(widget.dictation);
//                              },
//                            ),
//                          );
//                        },
//                      )
//                  ),//Icon(Icons.b)//SvgPicture.asset("assets/icons/menu.svg"),
//                ),
//                GestureDetector(
//                  onTap: () {
//                  },
//                  child: IconButton(
//                    icon: Icon(Icons.settings),
//                    onPressed: (){
//                      scaffoldKey.currentState.openEndDrawer();
//                    },
//                  )//SvgPicture.asset("assets/icons/menu.svg"),
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
//                    //top: 10,
//                    left: 100,
//                    child: Text(
//                      "${textTop} \n\n          ${textBottom}",
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
  Widget settings_icon()
  {
    return IconButton(
      icon: Icon(Icons.settings, size: 35, color: Colors.white,),
      onPressed: () {
        scaffoldKey.currentState.openEndDrawer();
      },
    );
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
              return DictationInfo(widget.dictation);
            },
          ),
        );
      },
    );
  }
  String auto_fill()
  {
    if (((word == null) || (word == "")) && ((translation_word != null) && (translation_word != "")))
    {
      if ((GlobalParameters.add_dictation_translation_language != "") && (GlobalParameters.add_dictation_word_language != "")) {
        final translator = GoogleTranslator();
        translator.translate(translation_field_val.text, from: language_key("translation",widget.dictation.from_language,widget.dictation.to_language), to: language_key("word",widget.dictation.from_language,widget.dictation.to_language))
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

      //show_snack_bar(_scaffoldKey,"First add word");

      //GlobalParameters.snackBarValue = "First add word";
      //_scaffoldKey.currentState.showSnackBar(GlobalParameters.snackBar);
      //Scaffold.of(context).showSnackBar(GlobalParameters.snackBar);
    }
    else if (((word != null) && (word != "")) && ((translation_word == null) || (translation_word == "")))
    {
      if ((widget.dictation.from_language != "") && (widget.dictation.to_language != ""))
      {
        final translator = GoogleTranslator();
        translator.translate(word, from: language_key("word",widget.dictation.from_language,widget.dictation.to_language), to: language_key("translation",widget.dictation.from_language,widget.dictation.to_language)).then((translated_word) {
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


    }
    else if (((word != null) && (word != "")) && ((translation_word != null) & (translation_word != "")))
      {
        return "remove field";
      }
    else
    {
      return "add word";
      //show_snack_bar(_scaffoldKey,"First add word");
      //GlobalParameters.snackBarValue = "First add word";
      //Scaffold.of(context).showSnackBar(GlobalParameters.snackBar);
    }
    return "stay";
  }
//  void auto_fill()
//  {
//    if (((word == null) || (word == "")) && ((translation_word != null) && (translation_word != "")))
//    {
//      final translator = GoogleTranslator();
//      translator.translate(translation_field_val.text, from: language_key("translation"), to: language_key("word")).then((result) {
//        setState(() {
//          word = result;
//          //translation_word = translated_word;
//          word_field_val.text = word;
//
//          //String a = translated_word.
//          //print(a);
//        });
//        //add_word();
//      });
//      //show_snack_bar(_scaffoldKey,"First add word");
//
//      //GlobalParameters.snackBarValue = "First add word";
//      //_scaffoldKey.currentState.showSnackBar(GlobalParameters.snackBar);
//      //Scaffold.of(context).showSnackBar(GlobalParameters.snackBar);
//    }
//    else if (((word != null) && (word != "")) && ((translation_word == null) || (translation_word == "")))
//    {
//      final translator = GoogleTranslator();
//      translator.translate(word, from: language_key("word"), to: language_key("translation")).then((translated_word) {
//        setState(() {
//          translation_word = translated_word;
//          //translation_word = translated_word;
//          translation_field_val.text = translation_word;
//
//          //String a = translated_word.
//          //print(a);
//        });
//        //add_word();
//      });
//
//    }
//    else
//    {
//      show_snack_bar(scaffoldKey,"First add word");
//      //GlobalParameters.snackBarValue = "First add word";
//      //Scaffold.of(context).showSnackBar(GlobalParameters.snackBar);
//    }
//  }
  bool auto_fill_chosen_button()
  {
    if ((connectivityResult == ConnectivityResult.mobile) || (connectivityResult == ConnectivityResult.wifi)) {
      return true;
    }
    return false;
  }
  bool add_word()
  {
    if (word != null)
    {
      if (translation_word != null)
      {

        setState(() {
          translation_field_val.text = "";
          word_field_val.text = "";
          widget.dictation.words_list.add(Word(word,translation_word));
          //GlobalParameters.words_to_add_list.add(Word(word,translation_word));
          word = "";
          translation_word = null;
          SaveInFile.save_in_file();
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
//  void add_word()
//  {
//    if (word != null)
//    {
//      if (translation_word != null)
//      {
//        setState(() {
//          translation_field_val.text = "";
//          word_field_val.text = "";
//          widget.dictation.words_list.add(Word(word,translation_word));
//          //GlobalParameters.words_to_add_list.add(Word(word,translation_word));
//          word = "";
//          translation_word = null;
//          SaveInFile.save_in_file();
//          Navigator.pop(context);
//        });
//
//      }
//    }
//    else{
//      show_snack_bar(scaffoldKey, "First add word");
//      //snack_bar("First add word");
//    }
//  }
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
//              (Colors.orange[300]),
//              Colors.orange,
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
//  snack_bar(String text)
//  {
//    GlobalParameters.snackBarValue = text;
//    scaffoldKey.currentState.showSnackBar(GlobalParameters.snackBar);
//    //Scaffold.of(context).showSnackBar(GlobalParameters.snackBar);
//  }
}
