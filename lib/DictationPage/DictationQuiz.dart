import 'dart:async';
import 'dart:math';

import 'package:dictation_app/DictationPage/AutoDictationScore.dart';
import 'package:dictation_app/DictationPage/OnFinished.dart';
import 'package:dictation_app/Globals/GlobalColors.dart';
import 'package:dictation_app/Globals/GlobalParameters.dart';
import 'package:dictation_app/Globals/constant.dart';
import 'package:dictation_app/MainTabs/MainPage.dart';
import 'package:dictation_app/SaveInFile.dart';
import 'package:dictation_app/Widgets/TimerPainter.dart';
import 'package:dictation_app/Widgets/my_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:dictation_app/Globals/GlobalFunctions.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
class DictationQuiz extends StatefulWidget{

  Dictation dictation;
  Function onTimerFinished;
  bool practice;
  DictationQuiz(this.dictation,[this.onTimerFinished,this.practice]);
  @override
  _DictationQuizState createState() => _DictationQuizState();

//  static FlutterTts flutterTts = FlutterTts();
//  static void onFinished()
//  {
//    speak_func();
//    GlobalParameters.said_word_counter = 0;
//    GlobalParameters.tested_words_count++;
//  }
//  static void speak_func()
//  {
//    _speak(GlobalParameters.current_shown_word);
//  }
//  static Future _speak(String speak_text) async {
//    await flutterTts.setLanguage("en-US");
//    await flutterTts.setSpeechRate(1);
//
//    await flutterTts.setVolume(1.0);
//    await flutterTts.setPitch(1.0);
//    var result = await flutterTts.speak(speak_text);
//    //if (result == 1) setState(() => ttsState = TtsState.playing);
//  }
}

class _DictationQuizState extends State<DictationQuiz> with TickerProviderStateMixin{

  AnimationController count_down_controller;
  String get timerString {
    Duration duration = count_down_controller.duration * count_down_controller.value;
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }
  String user_text_val;
  String shown_word;
  String shown_word_translation = "";
  String word_type;
  var _controller = TextEditingController();
  String submit_button_text = "Skip";
  bool last_said = false;
  static FlutterTts flutterTts = FlutterTts();

  Timer _timer;
  int start_time;
  List<int> showed_words = new List<int>();
  String user_hint = "";
  bool hint_pressed = false;
  bool next_word = true;
  bool finished = false;
  bool shouldPop = false,finishedCheckingForPop = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  @override
//  void dispose() {
////    _timer.cancel();
////    _timer.cancel();
//
//    super.dispose();
//    count_down_controller.dispose();
//  }
//  void dispose() {
//
//
//    count_down_controller.dispose();
//    super.dispose();
//
//
////    if (widget.dictation.say_word == true)
////      {
////
////        _timer.cancel();
////      }
//
//
//
//  }

  void initState(){
    super.initState();

    if (widget.dictation.say_word == true)
      {
        count_down_controller = AnimationController(
          vsync: this,
          duration: Duration(seconds: widget.dictation.duration),
        );
        start_time = widget.dictation.duration;
        startTimer();
        count_down_controller.reverse(
            from: count_down_controller.value == 0.0
                ? 1.0
                : count_down_controller.value);
      }
  }
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return WillPopScope(
      onWillPop: ()async {
        //Navigator.pop(context);
        if (finished == false)
          await areYouSure();
        // if (shouldPop)
        //   Navigator.pop(context);
        if (finishedCheckingForPop)
          {
            return shouldPop;
          }

      },
      child: Scaffold(
        key: _scaffoldKey,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              MyHeader(
                textTop: Positioned(
                  //top: 10,
                  //left: 40,
                  child: Text(
                    "Quiz - ${widget.dictation.name}\n",
                    style: kHeadingTextStyle.copyWith(
                        color: Colors.white,
                        fontSize: 50,
                        fontStyle: FontStyle.italic
                    ),
                  ),
                ),
                textBottom: Container(),
//                textBottom: Positioned(
//                  //top: 10,
//                  left: 50,
//                  child: Text(
//                    "\n\nWord ${GlobalParameters.tested_words_count+1} out of ${widget.dictation.words_list.length}",
//                    style: kHeadingTextStyle.copyWith(
//                        color: Colors.white,
//                        fontSize: 25,
//                        fontStyle: FontStyle.italic
//                    ),
//                  ),
//                ),
                offset: 2,
                height: 250,
                left_height: 30,
                right_height: 100,
                color_1: Colors.orange,
                color_2: Colors.redAccent,
                left_widget: quiz_left_widget(),
                right_widget: quiz_right_widget(),
              ),

              Padding(
                padding: EdgeInsets.all(15.0),
                child: new LinearPercentIndicator(
                  //width: MediaQuery.of(context).size.width - 50,
                  animation: false,
                  lineHeight: 30.0,
                  animationDuration: 1000,
                  percent: GlobalParameters.tested_words_count == 0 ? 0 : (GlobalParameters.tested_words_count) / widget.dictation.words_list.length,
                  center: Text("${GlobalParameters.tested_words_count} / ${widget.dictation.words_list.length}",style: TextStyle(
                    color: Colors.black
                  ),),
                  linearStrokeCap: LinearStrokeCap.roundAll,
                  progressColor: Colors.blue,
                ),
              ),
              word_generator(),
              Divider(
                color: Colors.grey,
              ),
              widget.dictation.say_word == true ? Padding(
                padding: const EdgeInsets.all(20.0),
                child: custom_button("Next word",show_next_word),
              ) : SizedBox.shrink(),
              widget.dictation.say_word == false ? Padding(
                padding: const EdgeInsets.fromLTRB(20,0,20,15),
                child: TextFormField(
                  autocorrect: false,
                  //https://github.com/flutter/flutter/issues/22828
                  keyboardType: TextInputType.visiblePassword,
                  enableSuggestions: false,
                  controller: _controller,
                  decoration: InputDecoration(
                    labelText: user_hint == "" ? "Translation" : user_hint,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    //hintText: user_hint,
                    suffixIcon: IconButton(
                      onPressed: () {
                        user_text_val = "";
                        _controller.clear();
                      },
                      icon: Icon(Icons.clear),
                    ),
                  ),
                  onChanged: (String val){
                    user_text_val = val;
                    if (val != "")
                      {
                        setState(() {
                          submit_button_text = "Submit";
                        });
                      }
                    else if (val == "")
                    {
                      setState(() {
                        submit_button_text = "Skip";
                      });
                    }
                  },
                  onFieldSubmitted: (String translation){
                    //GlobalParameters.tested_words.add(translation);
                  },
                ),
              ): SizedBox.shrink(),
              widget.dictation.say_word == false ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  finished == false ? custom_button(submit_button_text,on_submitted) : SizedBox.shrink(),
                  finished == false ? custom_button("Hint",hint) : SizedBox.shrink(),
                   //custom_button("Skip",on_submitted),
              ],): SizedBox.shrink(),

              ////////////////////////////////////////////////////////////////////
              widget.dictation.say_word == true ? Padding(
                padding: const EdgeInsets.fromLTRB(100.0,30,100,100),
                child: Align(
                  alignment: FractionalOffset.center,
                  child: AspectRatio(
                    aspectRatio: 1.0,
                    child: Stack(
                      children: <Widget>[
                        Positioned.fill(
                          child: AnimatedBuilder(
                            animation: count_down_controller,
                            builder: (BuildContext context, Widget child) {
                              return CustomPaint(
                                  painter: TimerPainter(
                                    animation: count_down_controller,
                                    backgroundColor: Colors.orange,
                                    color: Colors.grey[400],
                                    onTimerFinished: timerFinished,
                                  ));
                            },
                          ),
                        ),
                        Align(
                          alignment: FractionalOffset.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
//                            Text(
//                              "Count Down",
//                              style: themeData.textTheme.subhead,
//                            ),
                              AnimatedBuilder(
                                  animation: count_down_controller,
                                  builder: (BuildContext context,
                                      Widget child) {
                                    return Text(
                                      timerString,
                                      style: TextStyle(
                                        fontSize: 40
                                      ),
                                    );
                                  }),
                              FloatingActionButton(
                                backgroundColor: Colors.orange,
                                child: Icon(count_down_controller.isAnimating
                                    ? Icons.pause
                                    : Icons.play_arrow),
                                onPressed: (){
                                  if (count_down_controller.isAnimating) {
                                    setState(() {
                                      //start_time = _timer.tick;
                                      _timer.cancel();
                                      count_down_controller.stop(canceled: true);
                                    });
                                  } else {
                                    startTimer();
                                    //setState(() {
                                    //TODO: FIX THIS
                                    if (GlobalParameters.said_word_counter == 1)
                                      {
                                        if (start_time-1 == int.parse((widget.dictation.duration/2).toStringAsFixed(0)))
                                          {
                                            speak_func();
                                          }

                                      }
                                    setState(() {
                                      count_down_controller.reverse(
                                          from: count_down_controller.value == 0.0
                                              ? 1.0
                                              : count_down_controller.value);
                                    });

                                  }
                                },
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ) : SizedBox.shrink(),

              ////////////////////////////////////////////////////////////////////
            ],
          ),
        ),
      ),
    );
  }
  void hint()
  {
    hint_pressed = true;
    String hint_word = "";
    if (shown_word_translation.length > 1)
      {
        if (check_if_in_hebrew(shown_word_translation) == true)
          shown_word_translation = remove_decoration(shown_word_translation);

        int word_length = shown_word_translation.length;
        //hint_word = word_length*"_ ";
        for (int i = 0;i < word_length;i ++)
        {
          hint_word += "_";
        }
        var rnd = new Random();
        int random_number = rnd.nextInt(word_length);
        String hint_letter = shown_word_translation[random_number];
        String hint_string = "";
        if (word_type == "word")
          {
            if ((widget.dictation.from_language == "Arabic") ||
                (widget.dictation.from_language == "Aramaic") ||
                (widget.dictation.from_language == "Azeri") ||
                (widget.dictation.from_language == "Maldivian") ||
                (widget.dictation.from_language == "Dhivehi") ||
                (widget.dictation.from_language == "Hebrew") ||
                (widget.dictation.from_language == "Hebrew") ||
                (widget.dictation.from_language == "Kurdish") ||
                (widget.dictation.from_language == "Persian") ||
                (widget.dictation.from_language == "Farsi") ||
                (widget.dictation.from_language == "Urdu"))
              {
                for(int i=0; i<hint_word.length; i++) {
                  var char = hint_word[i];
                  if (i == random_number)
                  {
                    char = hint_letter;
                  }
                  hint_string += char;
                }
              }
            else{
              for(int i=hint_word.length-1; i>=0; i--) {
                var char = hint_word[i];
                if (i == random_number)
                {
                  char = hint_letter;
                }
                hint_string += char;
              }

            }
          }
        else{
          if ((widget.dictation.to_language == "Arabic") ||
              (widget.dictation.to_language == "Aramaic") ||
              (widget.dictation.to_language == "Azeri") ||
              (widget.dictation.to_language == "Maldivian") ||
              (widget.dictation.to_language == "Dhivehi") ||
              (widget.dictation.to_language == "Hebrew") ||
              (widget.dictation.to_language == "Hebrew") ||
              (widget.dictation.to_language == "Kurdish") ||
              (widget.dictation.to_language == "Persian") ||
              (widget.dictation.to_language == "Farsi") ||
              (widget.dictation.to_language == "Urdu"))
          {

            for(int i=0; i<hint_word.length; i++) {
              var char = hint_word[i];
              if (i == random_number)
              {
                char = hint_letter;
              }
              hint_string += char;
            }
          }
          else{
            for(int i=hint_word.length-1; i>=0; i--) {
              var char = '_';
              if (i == random_number)
              {
                char = hint_letter;
              }
              hint_string += char;
            }
          }
        }
//        for(int i=0; i<hint_word.length; i++) {
//          var char = hint_word[i];
//          if (i == random_number)
//            {
//              char = hint_letter;
//            }
//          hint_string += char;
//        }
        setState(() {
          //user_hint = hint_string.split('').reversed.join();
          user_hint = hint_string;
        });

        //hint_word[random_number] = "";
        //hint_word = replaceCharAt(hint_word, random_number, hint_letter);
        print(hint_word);
      }
    else
      {
        setState(() {
          user_hint = "_";
        });
      }

  }
  void filter_multible_same_words()
  {
    widget.dictation.words_list = widget.dictation.words_list.toSet().toList();
    //var result = new Collection(widget.dictation.words_list).distinct();
//    widget.dictation.words_list.
//    for (int i = 0;i < widget.dictation.words_list.length;i ++)
//      {
//
//      }
  }
  void show_next_word()
  {
    count_down_controller.stop();
    _timer.cancel();
    timerFinished();
  }
  void timerFinished()
  {
    //setState(() {

    //Future.delayed(const Duration(milliseconds: 1500), () {

// Here you can write your code
      if (GlobalParameters.tested_words_count == widget.dictation.words_list.length-1)
        {

          Navigator.pop(context);
          //Navigator.pop(context);
          _timer.cancel();
          _controller.clear();
          count_down_controller.stop();
          GlobalParameters.tested_words_count=0;
          user_text_val = "";
          GlobalParameters.said_word_counter = 0;
          last_said = true;
          GlobalParameters.last_dictation = widget.dictation;
          //count_down_controller.dispose();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return AutoDictationScore(widget.dictation);
              },
            ),
          );

        }
      else
        {
          setState(() {
            next_word = true;
            _controller.clear();
            GlobalParameters.tested_words_count++;
            user_text_val = "";
            GlobalParameters.said_word_counter = 0;
            start_time = widget.dictation.duration;
            //shown_word = "bird";
            count_down_controller = AnimationController(
              vsync: this,
              duration: Duration(seconds: widget.dictation.duration),
            );
            count_down_controller.reverse(
                from: count_down_controller.value == 0.0
                    ? 1.0
                    : count_down_controller.value);
            startTimer();

          });
        }

      //speak_func();
    //});
    //WidgetsBinding.instance.addPostFrameCallback((_){



      // Add Your Code here.

    //});

    //});
  }

  Widget quiz_right_widget()
  {
    return Container();
  }
  void on_skip()
  {
    GlobalParameters.tested_words.add(Check_word(shown_word,"skipped",word_type));
    _controller.clear();
    GlobalParameters.tested_words_count++;
  }
  void check_user_input(Check_word filled_word)
  {

    switch(filled_word.type)
    {
      case "word":
        {


          for (int i = 0;i < widget.dictation.words_list.length;i ++)
          {
            if (widget.dictation.words_list[i].word.toLowerCase() == filled_word.shown_word.toLowerCase())
            {
              String filled_word_translation;
              String real_translation;
              if (filled_word.translation == null)
                filled_word_translation = "";
              else
              {
                bool is_in_hebrew = check_if_in_hebrew(filled_word.translation);
                if (is_in_hebrew == true)
                {
                  filled_word_translation = remove_decoration(filled_word.translation);
                }
                else{
                  filled_word_translation = filled_word.translation;
                }
              }


              if (widget.dictation.words_list[i].translation == null)
                real_translation = "";
              else
              {
                bool is_in_hebrew = check_if_in_hebrew(widget.dictation.words_list[i].translation);
                if (is_in_hebrew == true)
                {
                  real_translation = remove_decoration(widget.dictation.words_list[i].translation);
                }
                else{
                  real_translation = widget.dictation.words_list[i].translation;
                }

//                  bool is_in_english = check_if_in_english(widget.dictation.words_list[i].translation);
//                  if (is_in_english == false)
//                  {
//                      real_translation = remove_decoration(widget.dictation.words_list[i].translation);
//                  }
//                  else
//                    {
//                      real_translation = widget.dictation.words_list[i].translation;
//                    }
              }


              if (real_translation.toLowerCase() == filled_word_translation.toLowerCase())
                show_snack_bar(_scaffoldKey,"correct",Colors.green);
              else
                show_snack_bar(_scaffoldKey,"wrong",Colors.redAccent);
              //break;
            }
          }
        }
        break;
      case "translation":
        {
          for (int i = 0;i < widget.dictation.words_list.length;i ++)
          {

            if (filled_word.translation != null)
            {
              String word_input;
              String real_word;
              if (filled_word.shown_word == null)
                word_input = "";
              else
              {
                bool is_in_hebrew = check_if_in_hebrew(filled_word.translation);
                if (is_in_hebrew == true)
                {
                  word_input = remove_decoration(filled_word.translation);
                }
                else{
                  word_input = filled_word.translation;
                }
              }


              if (widget.dictation.words_list[i].word == null)
                real_word = "";
              else
              {
                bool is_in_hebrew = check_if_in_hebrew(widget.dictation.words_list[i].word);
                if (is_in_hebrew == true)
                {
                  real_word = remove_decoration(widget.dictation.words_list[i].word);
                }
                else{
                  real_word = widget.dictation.words_list[i].word;
                }
              }


              if (widget.dictation.words_list[i].translation.toLowerCase() == filled_word.shown_word.toLowerCase())
              {
                if (word_input == real_word)
                  show_snack_bar(_scaffoldKey,"correct",Colors.green);
                else
                  show_snack_bar(_scaffoldKey,"wrong",Colors.redAccent);
              }
            }
            else{
              show_snack_bar(_scaffoldKey,"wrong",Colors.redAccent);
              break;
            }
          }
        }
        break;
    }


//    switch(filled_word.type)
//    {
//      case "word":
//        {
//          for (int i = 0;i < widget.dictation.words_list.length;i ++)
//          {
//
//            if (widget.dictation.words_list[i].word.toLowerCase() == filled_word.shown_word.toLowerCase())
//            {
//              String filled_word_translation;
//              String real_translation;
//              if (filled_word.translation == null)
//                filled_word_translation = "";
//              else
//                filled_word_translation = remove_decoration(filled_word.translation);
//
//
//              if (widget.dictation.words_list[i].translation == null)
//                real_translation = "";
//              else
//                real_translation = remove_decoration(widget.dictation.words_list[i].translation);
//
//
//              if (filled_word_translation == real_translation)
//                show_snack_bar(_scaffoldKey,"correct",Colors.green);
//              else
//                show_snack_bar(_scaffoldKey,"wrong",Colors.redAccent);
//
//
//              break;
//            }
//          }
//        }
//        break;
//      case "translation":
//        {
//          for (int i = 0;i < widget.dictation.words_list.length;i ++)
//          {
//            if (widget.dictation.words_list[i].translation.toLowerCase() == filled_word.shown_word.toLowerCase())
//            {
//              String word_input;
//              String real_word;
//              if (filled_word.shown_word == null)
//                word_input = "";
//              else
//                word_input = remove_decoration(filled_word.shown_word);
//
//              if (widget.dictation.words_list[i].word == null)
//                real_word = "";
//              else
//                real_word = remove_decoration(widget.dictation.words_list[i].word);
//
//
//              if (word_input == real_word)
//                show_snack_bar(_scaffoldKey,"correct",Colors.green);
//              else
//                show_snack_bar(_scaffoldKey,"wrong",Colors.redAccent);
////              if (filled_word.translation.toLowerCase() == widget.dictation.words_list[i].word.toLowerCase())
////              {
////                //TODO:Show correct snackbar
////                show_snack_bar(_scaffoldKey,"correct",Colors.green);
//////                setState(() {
//////                  GlobalParameters.snackBarValue = "correct";
//////                  GlobalParameters.snackBarColor = Colors.green;
//////                });
//////
//////                _scaffoldKey.currentState.showSnackBar(GlobalParameters.snackBar);
////              }
////              else{
////                //TODO:Show wrong snackbar
////                show_snack_bar(_scaffoldKey,"wrong",Colors.redAccent);
//////                setState(() {
//////                  GlobalParameters.snackBarValue = "wrong";
//////                  GlobalParameters.snackBarColor = Colors.redAccent;
//////                });
//////                _scaffoldKey.currentState.showSnackBar(GlobalParameters.snackBar);
////              }
//              break;
//            }
//            else if (filled_word.shown_word == "")
//            {
//              //TODO:Show wrong snackbar
//              show_snack_bar(_scaffoldKey,"wrong",Colors.redAccent);
////              setState(() {
////                GlobalParameters.snackBarValue = "wrong";
////                GlobalParameters.snackBarColor = Colors.redAccent;
////              });
////              _scaffoldKey.currentState.showSnackBar(GlobalParameters.snackBar);
//              //correct = false;
//            }
//          }
//        }
//        break;
//    }
  }
  void on_submitted()
  {
    //
    if ((user_text_val != "") || ((user_text_val != null)))
      check_user_input(Check_word(user_text_val,shown_word,word_type));
    //
    next_word = true;
    //filter_multible_same_words();
    hint_pressed = false;
    setState(() {
      user_hint = "";
    });
    GlobalParameters.tested_words_count++;
    if (user_text_val == null){
      GlobalParameters.tested_words.add(Check_word(user_text_val,shown_word,word_type));
    }
    else{
      GlobalParameters.tested_words.add(Check_word(user_text_val,shown_word,word_type));
    }


    if ((GlobalParameters.tested_words_count == widget.dictation.words_list.length) || ((GlobalParameters.tested_words_count == widget.dictation.last_wrong_words.length) && (widget.practice == true)))
    {
      setState(() {
        finished = true;
        GlobalParameters.tested_words_count++;

      });
      Future.delayed(const Duration(milliseconds: 2000), () {
        finish_page();
      });
      setState(() {
        GlobalParameters.tested_words_count --;
      });
      //TODO: add check answers page
    }


//    else if (GlobalParameters.tested_words_count == widget.dictation.words_list.length)
//      {
//
//      }
    else
      {
        setState(() {
          _controller.clear();
          //GlobalParameters.tested_words_count++;
          if (GlobalParameters.tested_words_count == widget.dictation.words_list.length-1)
          {
            submit_button_text = "Finish";
          }
//          if (user_text_val == null)
//              GlobalParameters.tested_words.add(Check_word("",shown_word,word_type));
//          else
//              GlobalParameters.tested_words.add(Check_word(user_text_val,shown_word,word_type));
          user_text_val = "";
        });
      }


  }
  void finish_page()
  {

    setState(() {

      submit_button_text = "Finish";
    });
//      if (user_text_val == null)
//        GlobalParameters.tested_words.add(Check_word("",shown_word,word_type));
//      else
//        GlobalParameters.tested_words.add(Check_word(user_text_val,shown_word,word_type));
    //GlobalParameters.tested_words_count++;
    _controller.clear();
    List<Check_word> last_tested_words = new List<Check_word>();
    GlobalParameters.tested_words.forEach((cell)
    {
      last_tested_words.add(cell);
    });
    widget.dictation.last_dictation_tested_words.removeRange(0, widget.dictation.last_dictation_tested_words.length);
    GlobalParameters.tested_words.forEach((cell)
    {
      widget.dictation.last_dictation_tested_words.add(cell);
    });
    GlobalParameters.tested_words.clear();
    last_tested_words.forEach((cell)
    {
      GlobalParameters.tested_words.add(cell);
    });
    // = last_tested_words;
    SaveInFile.save_in_file();
    //widget.dictation.date = GlobalParameters.last_dictation_date;
    //GlobalParameters.recentDictations.add(widget.dictation);
    List<Dictation> updated_recentDictations = new List<Dictation>();
    int added_count = 0;
    if (GlobalParameters.recentDictations.length > GlobalParameters.recent_dictations_length)
    {
      for (int i = GlobalParameters.recentDictations.length-1;i > GlobalParameters.recentDictations.length-GlobalParameters.recent_dictations_length-1;i --)
      {
//              if (added_count <= GlobalParameters.recent_dictations_length)
//                {
        if (GlobalParameters.Dictations.contains(GlobalParameters.recentDictations[i]))
        {
          updated_recentDictations.add(GlobalParameters.recentDictations[i]);
          added_count++;
        }
        //}
      }
      GlobalParameters.recentDictations.clear();
      updated_recentDictations.forEach((cell){
        GlobalParameters.recentDictations.add(cell);
      });
    }
    else
      {
        GlobalParameters.recentDictations.add(widget.dictation);
      }
    //
    SaveInFile.save_recent_dictations();
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return OnFinished(widget.dictation,GlobalParameters.tested_words,"check");
        },
      ),
    );
    //GlobalParameters.tested_words.clear();
    last_tested_words.clear();
  }
  Widget custom_button(String text,Function on_pressed)
  {
    return RaisedButton(
      onPressed: () {
        on_pressed();
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
      padding: const EdgeInsets.all(0.0),
      child: Ink(
        decoration: const BoxDecoration(
          gradient:  LinearGradient(
            colors: <Color>[
              Colors.orange,
              //Color(0xFF1976D2),
              kInfectedColor,
            ],
          ),
          borderRadius: BorderRadius.all(Radius.circular(80.0)),
        ),
        child: Container(
          constraints: const BoxConstraints(minWidth: 88.0, minHeight: 36.0), // min sizes for Material buttons
          alignment: Alignment.center,
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 17
            ),
          ),
        ),
      ),
    );
  }
  Widget word_generator()
  {
    if (hint_pressed == false)
      {
        switch (widget.dictation.test_type) {
          case "Show the word"://"Quiz only on the translations":
            {
              shown_word_type("word");

//          shown_word = "${widget.dictation.words_list[GlobalParameters.tested_words_count].word}";
//          word_type = "word";
            }
            break;
          case "Show the translation"://"Quiz only on the words":
            {
              shown_word_type("translation");
//          shown_word = "${widget.dictation.words_list[GlobalParameters.tested_words_count].translation}";
//          word_type = "translation";
            }
            break;
          case "Randomly select"://"Quiz on both":
            {
              var rng = new Random();
              int random_number = rng.nextInt(2);
              if (random_number == 1)
              {
                shown_word_type("word");
              }
              else
              {
                shown_word_type("translation");
              }
            }
            break;
        }
        if (widget.dictation.say_word == true)
        {
          if ((GlobalParameters.said_word_counter == 0) && (last_said == false))
          {
            GlobalParameters.current_shown_word = shown_word;
            speak_func();


          }
        }



      }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          shown_word,
          style: TextStyle(
              fontSize: 35
          ),
        ),
        can_speak(),
        //Text(user_hint),
      ],
    );
  }
  Widget can_speak()
  {
    if (check_if_in_english(shown_word) == true)
      {
        return IconButton(
          icon: Icon(Icons.volume_up),
          onPressed: (){
            GlobalParameters.current_shown_word = shown_word;
            speak_func();

          },
        );
      }
    return SizedBox.shrink();
  }

  void shown_word_type(String type)
  {
    if ((showed_words.length != widget.dictation.words_list.length) && (widget.dictation.say_word == false) && (next_word == true))
    {
      var rng = new Random();
      int random_number = rng.nextInt(widget.dictation.words_list.length);
      while (showed_words.contains(random_number) == true)
      {
        random_number = rng.nextInt(widget.dictation.words_list.length);
      }
      showed_words.add(random_number);
      if (type == "word")
        {
          shown_word = "${widget.dictation.words_list[random_number].word}";
          shown_word_translation = "${widget.dictation.words_list[random_number].translation}";
          word_type = "word";
        }
      else if (type == "translation")
      {
        shown_word = "${widget.dictation.words_list[random_number].translation}";
        shown_word_translation = "${widget.dictation.words_list[random_number].word}";
        word_type = "translation";
      }

    }
    else if ((showed_words.length != widget.dictation.words_list.length) && (widget.dictation.say_word == true) && (next_word == true))
      {
        if (_timer.tick == 0)
          {
            var rng = new Random();
            int random_number = rng.nextInt(widget.dictation.words_list.length);
            while (showed_words.contains(random_number) == true)
            {
              random_number = rng.nextInt(widget.dictation.words_list.length);
            }
            showed_words.add(random_number);
            if (type == "word")
            {
              shown_word = "${widget.dictation.words_list[random_number].word}";
              shown_word_translation = "${widget.dictation.words_list[random_number].translation}";
              word_type = "word";
            }
            else if (type == "translation")
            {
              shown_word = "${widget.dictation.words_list[random_number].translation}";
              shown_word_translation = "${widget.dictation.words_list[random_number].word}";
              word_type = "translation";
            }

          }
      }
    next_word = false;
  }
//  void shown_word_type_2()
//  {
//    //((showed_words.length != widget.dictation.words_list.length) && (widget.dictation.say_word == false) && (next_word == true))
//    if (showed_words.length != widget.dictation.words_list.length)
//    {
//      var rng = new Random();
//      int random_number = rng.nextInt(widget.dictation.words_list.length);
//      while (showed_words.contains(random_number) == true)
//      {
//        random_number = rng.nextInt(widget.dictation.words_list.length);
//      }
//      showed_words.add(random_number);
//      shown_word = "${widget.dictation.words_list[random_number].translation}";
//      shown_word_translation = "${widget.dictation.words_list[random_number].word}";
//      word_type = "translation";
//    }
//  }
  void speak_func()
  {
    GlobalParameters.said_word_counter ++;
    _speak(GlobalParameters.current_shown_word);
  }
  Widget quiz_left_widget()
  {
    return finished == false ? Container(
      child: IconButton(
        icon: Icon(Icons.clear,size: 40,color: Colors.white,),
        onPressed: ()async{
          await areYouSure();
          if (shouldPop)
          {
              Navigator.pop(context);
          }
        },
      ),
    ) : Container(height: 45,width: 45,);
  }
  void areYouSure () async
  {

    bool shouldUpdate = await showDialog(
        context: context,
        builder: (BuildContext context){
          return StatefulBuilder(
            builder: (context, setState)
            {
              return AlertDialog(

                //titlePadding: EdgeInsets.all(0),
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20),
                  ),//+ Border.all(color: Colors.white),///contentPadding: EdgeInsets.all(0.0),
                  title: Container(
                      child: Text("Are you sure you want to stop the dictation?",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),)
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
                            //_controller.clear();
//                            GlobalParameters.tested_words_count = 0;
//                            GlobalParameters.tested_words.clear();
                            //GlobalParameters.last_dictation = null;
                            if (widget.dictation.say_word == true)
                              {
                                _timer.cancel();
                                _controller.clear();
                                count_down_controller.stop();
                                GlobalParameters.tested_words_count=0;
                                user_text_val = "";
                                GlobalParameters.said_word_counter = 0;
                              }

                            submit_button_text = "Submit";
                            //if (Navigator.canPop(context))
                            Navigator.pop(context,true);
                            //shouldPop = true;
                            //Navigator.of(context, rootNavigator: true).pop();
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) {
                            //       return MainPage();
                            //     },
                            //   ),
                            // );

                            //Navigator.pop(context, rootNavigator: true);
                            //if (Navigator.canPop(context))
                            //Navigator.pop(context);
                            //Navigator.pop(DictationQuiz(widget.dictation));
                            //Navigator.pop(context);
                        },
                      ),
                      FlatButton(
                        child: Text("No",style: TextStyle(
                            fontSize: 20,
                            color: kPrimaryColor
                        ),),
                        onPressed: (){
                          Navigator.pop(context,false);
                        },
                      ),
                    ],
                  )
              );
            },
          );

        }

    );
    setState(() {
      shouldUpdate ? shouldPop = true : shouldPop = false;
      finishedCheckingForPop = true;
    });
  }
  Future _speak(String speak_text) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(1);

    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);
    var result = await flutterTts.speak(speak_text);
    //if (result == 1) setState(() => ttsState = TtsState.playing);
  }
  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) => setState(
            () {
              if ((start_time-2).toString() == (widget.dictation.duration/2).toStringAsFixed(0))
                {
                  speak_func();
                }
          if (start_time < 1) {
            timer.cancel();
            timerFinished();
          } else {
            start_time = start_time - 1;
          }
        },
      ),
    );
  }
}