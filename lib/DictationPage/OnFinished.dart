import 'dart:ffi';
import 'dart:math';
//import 'dart:html';

import 'package:confetti/confetti.dart';
import 'package:dictation_app/DictationPage/DictationQuiz.dart';
import 'package:dictation_app/Globals/Enums.dart';
import 'package:dictation_app/Globals/GlobalParameters.dart';
import 'package:dictation_app/Globals/GlobalFunctions.dart';
import 'package:dictation_app/Globals/GlobalColors.dart';
import 'package:dictation_app/Globals/constant.dart';
import 'package:dictation_app/SaveInFile.dart';
import 'package:dictation_app/Widgets/CircleProgress.dart';
import 'package:dictation_app/Widgets/my_header.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class OnFinished extends StatefulWidget {

  Dictation dictation;
  List<Check_word> tested_words = new List<Check_word>();
  String last_dictation;

  OnFinished(this.dictation,this.tested_words,this.last_dictation);
  @override
  _OnFinishedState createState() => _OnFinishedState();
}

class _OnFinishedState extends State<OnFinished> with SingleTickerProviderStateMixin{
  //grade animation
  AnimationController progressController;
  Animation<double> animation;
  //
  List<String> words = new List<String>();
  List<Word> wrong_words = new List<Word>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String correct_word;
  bool correct;
  bool add_to_wrong_words = true;
  int wrong_counter = 0;
  double user_grade = 0;
  int words_counter = 0;
  Color card_color = Colors.grey;
  List<Word> wrong_words_updated_list = new List<Word>();
  ConfettiController _controllerTopCenter;

  void initState(){
    super.initState();
    progressController = AnimationController(vsync: this,duration: Duration(milliseconds: 1000));
    animation = Tween<double>(begin: 0,end: user_grade).animate(progressController)..addListener(() {
      setState(() {});
    });
    GlobalParameters.correct_counter = 0;
//    GlobalParameters.recentDictations.add(widget.dictation);
//    SaveInFile.save_recent_dictations();
    _controllerTopCenter =
        ConfettiController(duration: const Duration(seconds: 5));

  }
  @override
  void dispose() {
    _controllerTopCenter.dispose();
    super.dispose();
  }
  //user_grade == 100 ? confetti() : SizedBox.shrink(),
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Stack(
           children: <Widget>[
             Column(
               children: <Widget>[
                 MyHeader(
                   textTop: Positioned(
                     //top: 10,
                     //left: 100,
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
//                   textBottom: Positioned(
//                     //top: 10,
//                     //left: 50,
//                     child: Text(
//                       "\n\n${GlobalParameters.correct_counter} out of ${widget.dictation.words_list.length} are correct",
//                       style: kHeadingTextStyle.copyWith(
//                           color: Colors.white,
//                           fontSize: 25,
//                           fontStyle: FontStyle.italic
//                       ),
//                     ),
//                   ),
                   offset: 2,
                   height: 250,
                   left_height: 30,
                   right_height: 100,
                   color_1: GlobalParameters.DarkMode ? Colors.orange[700] : Colors.orange,
//                   GlobalParameters.DarkMode ? Colors.orange[800] : Colors.orange[300],
//                   Colors.orange,
                   color_2: Colors.redAccent,
                   left_widget: close_dictation(),
                   right_widget: Container(),
                 ),
                 Center(
                   child: Padding(
                     padding: EdgeInsets.all(15.0),
                     child: new LinearPercentIndicator(
                       //width: MediaQuery.of(context).size.width - 50,
                       animation: true,
                       lineHeight: 30.0,
                       animationDuration: 1000,
                       percent: GlobalParameters.correct_counter == 0 ? 0 : GlobalParameters.correct_counter / widget.dictation.words_list.length,
                       center:  GlobalParameters.correct_counter != 0 ? Text("${GlobalParameters.correct_counter} / ${widget.dictation.words_list.length}",style: TextStyle(
                         color: Colors.black
                       ),): Text("0 / ${widget.dictation.words_list.length}"),
                       linearStrokeCap: LinearStrokeCap.roundAll,
                       progressColor: Colors.green,
                     ),
                   ),
                 ),
                 Center(
                   child: CustomPaint(
                     foregroundPainter: CircleProgress(animation.value), // this will add custom painter after child
                     child: Container(
                       width: 100,
                       height: 100,
                       child: GestureDetector(
                           child: Center(child: Text("${animation.value.toInt()}%",style: TextStyle(
                               fontSize: 30,
                               fontWeight: FontWeight.bold
                           ),))),
                     ),
                   ),
                 ),
                 wrong_words_count() != 0 ? Padding(
                   padding: const EdgeInsets.all(20.0),
                   child: Column(
                     mainAxisAlignment: MainAxisAlignment.spaceAround,
                     children: <Widget>[
                       Row(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: <Widget>[
                           custom_button("Practice on the wrong words",quiz_on_the_wrong_words),
                         ],
                       ),
                       Padding(
                         padding: const EdgeInsets.all(5),
                       ),
                       Row(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: <Widget>[
                           custom_button("Quiz again",quiz_again,Padding(
                             padding: const EdgeInsets.fromLTRB(10,0,0,0),
                             child: Icon(Icons.refresh),//,color: Colors.black,
                           ),),
                         ],
                       ),
                     ],
                   ),
                 ): Row(
                   mainAxisAlignment:  MainAxisAlignment.spaceAround,
                   children: <Widget>[
                     Container(),
                     Padding(
                       padding: const EdgeInsets.all(20.0),
                       child: custom_button("Quiz again",quiz_again,Icon(Icons.refresh)),
                     ),
                     Container(),
                   ],
                 ),
                 Column(
                   children: <Widget>[
                     ListView.builder(
                         physics: NeverScrollableScrollPhysics(),
                         //scrollDirection: Axis.vertical,
                         shrinkWrap: true,
                         itemCount: widget.tested_words.length,
                         itemBuilder: (BuildContext context, int index) =>
                             ResultCard(context, index)),
                   ],
                 ),
//          DataTable(
//            columns: <DataColumn>[
//
//              DataColumn(
//                label:
//                Text(
//                  'Word',
//                  style: TextStyle(
//                      fontStyle: FontStyle
//                          .italic),
//                ),
//              ),
//              DataColumn(
//
//                label: Text(
//                  'User input',
//                  style: TextStyle(
//                      fontStyle: FontStyle
//                          .italic),
//                ),
//              ),
//              DataColumn(
//                label: Text(
//                  'Check',
//                  style: TextStyle(
//                      fontStyle: FontStyle
//                          .italic),
//                ),
//              ),
//            ],
//            rows:
//             // Loops through dataColumnText, each iteration assigning the value to element
//                widget.tested_words.map(
//              ((element) => DataRow(
//                cells: <DataCell>[
//                  //DataCell(Text(element["Name"])), //Extracting from Map element the value
//                  DataCell(Text(element.shown_word,style: TextStyle(
//                    fontSize: 20
//                  ),),
//                  ),
//                  DataCell(check_user_input(element)),
//                  DataCell(correct_or_not_icon(element)),
//                ],
//              )),
//            ).toList(),
//          ),


               ],
             ),
             user_grade == 100 ? confetti() : SizedBox.shrink(),
           ],
        ),
      ),
    );
  }
  List<Word> filter_multible_same_words()
  {
    List<Word> wrong_list = List<Word>();
    wrong_list = wrong_words_updated_list.toSet().toList();
//    widget.dictation.words_list.
//    for (int i = 0;i < wrong_words_updated_list.length;i ++)
//      {
//        for (int j = 0;j < wrong_words_updated_list.length;j ++)
//        {
//          if (wrong_words_updated_list[i].word == wrong_words_updated_list[j].word)
//            {
//
//            }
//        }
//      }
    return wrong_list;
  }
  Widget ResultCard(BuildContext context,int index)
  {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        side: new BorderSide(color: widget.tested_words[index] != null ? check_if_correct(widget.tested_words[index]) : Colors.redAccent,
            width: 4.0),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(10,10,0,0),
                child: correct_or_not_icon(widget.tested_words[index]),
              ),
            ],
          ),
          Center(
            child: Text(widget.tested_words[index].shown_word,style: TextStyle(
                fontSize: 25,
                //color: Colors.black
            ),),
          ),
//          Padding(
//            padding: const EdgeInsets.all(8.0),
//            child: Row(
//              mainAxisAlignment: MainAxisAlignment.spaceBetween,
//              children: <Widget>[
//                Padding(
//                  padding: const EdgeInsets.fromLTRB(8,0,0,0),
//                  child: correct_or_not_icon(widget.tested_words[index]),
//                ),
//                Text(widget.tested_words[index].shown_word,style: TextStyle(
//                    fontSize: 25,
//                  color: Colors.black
//                ),),
//                Text(""),
//              ],
//            ),
//          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Icon(Icons.check,size: 35,color: Colors.green,),
                  show_correct_word(widget.tested_words[index],widget.last_dictation == "check" ? widget.dictation.test_type : widget.dictation.last_dictation_type),//
                ],
              ),
              Column(//
                children: <Widget>[
                  Icon(Icons.person,size: 35,color: Colors.grey,),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0,0,0,10),
                    child: Container(
                      child: Text(check_user_input(widget.tested_words[index],ReturnedType.Value),style: TextStyle(
                          fontSize: 25,
                          //color: Colors.black
                        //backgroundColor: correct_or_not,
                      ),textAlign: TextAlign.end,),
                    ),
                  ),
                ],
              )
            ],
          )
        ],
      ),
      //color: check_if_correct(widget.tested_words[index]),
    );
  }
  void quiz_again()
  {
    GlobalParameters.tested_words_count = 0;
    GlobalParameters.tested_words.clear();
    widget.tested_words.clear();
    Navigator.pop(context);
    //Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return DictationQuiz(widget.dictation);
        },
      ),
    );
  }
  void quiz_on_the_wrong_words()
  {
//    Dictation dictation;
//    String name = "${widget.dictation.name} - Practice words";
    wrong_words_updated_list = filter_multible_same_words();
    widget.dictation.last_wrong_words = wrong_words_updated_list;

    List<Check_word> empty_list = new List<Check_word>();

    String name = "Practice";
    Dictation wrong_words_dictation = Dictation(name,widget.dictation.last_wrong_words,widget.dictation.say_word,widget.dictation.test_type,
    widget.dictation.duration,widget.dictation.last_wrong_words,widget.dictation.date,empty_list);
    GlobalParameters.tested_words_count = 0;
    wrong_words_dictation.last_dictation_tested_words.clear();
    //widget.tested_words.clear();
    GlobalParameters.tested_words.clear();
    add_to_wrong_words = false;
    SaveInFile.save_in_file();
    Navigator.pop(context);
    //Navigator.pop(context);
    //Navigator.pop(context);

//    List<Check_word> check_word_list = new List<Check_word>();
//    GlobalParameters.last_dictation_date = "${GlobalParameters.now.day}/${GlobalParameters.now.month}/${GlobalParameters.now.year}";
//    GlobalParameters.last_dictation = widget.dictation;
//    GlobalParameters.last_saved_dictation = LastDictation(
//        GlobalParameters.last_dictation.name,
//        GlobalParameters.last_dictation.words_list,
//        GlobalParameters.last_dictation.say_word,
//        GlobalParameters.last_dictation.test_type,
//        GlobalParameters.last_dictation_date,
//        check_word_list,
//        GlobalParameters.last_dictation.duration);
//    widget.dictation.date = GlobalParameters.last_dictation_date;
//    DateTime now = DateTime.now();
//    widget.dictation.last_dictation_time = now.toString();
//    SaveInFile.save_in_file();
//    SaveInFile.save_last_dictation();
//    GlobalParameters.tested_words_count = 0;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return DictationQuiz(wrong_words_dictation,null,true);
        },
      ),
    );
//    dictation.words_list = wrong_words;
//    dictation.say_word = false;
//    dictation.duration = 6;
    //dictation.test_type = "Quiz only on the translations";
    //GlobalParameters.Dictations.add(Dictation(name,wrong_words,false,"Quiz only on the translations",6));
//    GlobalParameters.snackBarValue = "Dictation has been added";
//    _scaffoldKey.currentState.showSnackBar(GlobalParameters.snackBar);
  }
//  Color check_if_correct(Check_word check_word)
//  {
//    if(correct == true)
//    {
//      return Colors.green[400];
//    }
//    else
//      {
//        return Colors.redAccent[100];
//      }
//  }
  Color check_if_correct(Check_word check_word)
  {
    Color color;
    String result = check_user_input(check_word,ReturnedType.CorrectOrWrong);
    if (result == "correct")
      {
        color = Colors.green[300];
      }
    else if (result == "wrong")
    {
      color = Colors.red[300];
      for (int i = 0;i < widget.dictation.words_list.length;i ++)
      {
        if (widget.dictation.words_list[i].word == check_word.shown_word)
        {
          wrong_words_updated_list.add(widget.dictation.words_list[i]);
//          return Text("${widget.dictation.words_list[i].translation}",style: TextStyle(
//              fontSize: 25,
//              color: Colors.green
//          ),);
        }
      }
//      widget.dictation.words_list.indexOf(Word(check_word.))
//      wrong_words_updated_list.add();
    }
    return color;
  }
  Widget confetti()
  {
    //https://pub.dev/packages/confetti/example
    if (widget.last_dictation == "check") {
      var rng = new Random();
      int random_number = rng.nextInt(4);
      switch (random_number) {
        case 0:
          {
            return Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _controllerTopCenter,
                blastDirection: pi / 2, //-pi / 2
                emissionFrequency: 1,
                numberOfParticles: 1,
//        maxBlastForce: 100,
//        minBlastForce: 80,
//        gravity: 1,
              ),
            );
          }
          break;
        case 1:
          {
            return Align(
              alignment: Alignment.centerLeft,
              child: ConfettiWidget(
                confettiController: _controllerTopCenter,
                blastDirection: 0,
                // radial value - RIGHT
                emissionFrequency: 0.6,
                // set the maximum potential size for the confetti (width, height)
                numberOfParticles: 1,
                gravity: 0.1,
              ),
            );
          }
          break;
        case 2:
          {
            return Align(
              alignment: Alignment.bottomCenter,
              child: ConfettiWidget(
                confettiController: _controllerTopCenter,
                blastDirection: -pi / 2,
                emissionFrequency: 0.01,
                numberOfParticles: 20,
                maxBlastForce: 100,
                minBlastForce: 80,
                gravity: 0.3,
              ),
            );
          }
          break;
        case 3:
          {
            return Align(
              alignment: Alignment.center,
              child: ConfettiWidget(
                confettiController: _controllerTopCenter,
                blastDirectionality: BlastDirectionality
                    .explosive,
                // don't specify a direction, blast randomly
                //shouldLoop: true, // start again as soon as the animation is finished
                colors: const [
                  Colors.green,
                  Colors.blue,
                  Colors.pink,
                  Colors.orange,
                  Colors.purple
                ], // manually specify the colors to be used
              ),
            );
          }
          break;
      }
    }

    return SizedBox.shrink();

//    return Align(
//      alignment: Alignment.topCenter,
//      child: ConfettiWidget(
//        confettiController: _controllerTopCenter,
//        blastDirection: pi / 2,
//        maxBlastForce: 5, // set a lower max blast force
//        minBlastForce: 2, // set a lower min blast force
//        emissionFrequency: 0.05,
//        numberOfParticles: 50, // a lot of particles at once
//        gravity: 1,
//      ),
//    );
  }
  Widget correct_or_not_icon(Check_word check_word)
  {
//    if (correct == true)
//      GlobalParameters.correct_counter = 0;
    Widget returned_widget = SizedBox.shrink();
    if (check_user_input(check_word,ReturnedType.CorrectOrWrong) == "correct")
      returned_widget = Icon(Icons.check,color: Colors.green,size: 30,);
    else {
      returned_widget = Row(
        children: <Widget>[
          Icon(Icons.clear, color: Colors.redAccent, size: 30,),
        ],
      );
    }
    if (words_counter <  widget.dictation.words_list.length)
      {
        if (correct == true)
        {
          //setState(() {
          if (GlobalParameters.correct_counter < widget.dictation.words_list.length)
            GlobalParameters.correct_counter++;
          //});
          //returned_widget = Icon(Icons.check,color: Colors.green,size: 30,);
        }
        else
        {
          wrong_counter ++;
//          returned_widget = Row(
//            children: <Widget>[
//              Icon(Icons.clear, color: Colors.redAccent, size: 30,),
//            ],
//          );
        }
        words_counter ++;
      }

//    if (widget.last_dictation == "last dictation")
//      {
//        if (words_counter == widget.dictation.last_dictation_tested_words.length) {
//          calculate_user_grade();
//        }
//      }
    if ((words_counter == widget.dictation.words_list.length) || (words_counter == widget.dictation.last_dictation_tested_words.length))
    {
      calculate_user_grade();

      //});

    }
    return returned_widget;
  }
  void calculate_user_grade()
  {
    double every_word_points;
    every_word_points = 100/words_counter;
    // setState(() {
    //every_word_points.round();
    user_grade = every_word_points*GlobalParameters.correct_counter;

    //user_grade.double.parse(num1.toStringAsFixed(2));
    //user_grade.toDouble();
    //assign_func();
    //setState(() {
      user_grade = double.parse(user_grade.toStringAsFixed(0));
    //});
    if (user_grade == 100)
      {
        _controllerTopCenter.play();
      }


    if ((user_grade != 0) && (user_grade.round() == user_grade))
    {
      //WidgetsBinding.instance.addPostFrameCallback((_){
        //setState(() {
          animation = Tween<double>(begin: 0,end: user_grade).animate(progressController)..addListener((){});
          //animation.value = user_grade;
          progressController.forward();
        //});
      //});


    }
  }
  Widget show_correct_word(Check_word check_word, String test_type)
  {
    for (int i = 0;i < widget.dictation.words_list.length;i ++)
    {
      if (widget.dictation.test_type == "Show the word")
      {
        if (widget.dictation.words_list[i].word == check_word.shown_word)
        {
          return Text("${widget.dictation.words_list[i].translation}",style: TextStyle(
              fontSize: 25,
              color: Colors.green
          ),);
        }
      }
      else if (widget.dictation.test_type == "Show the translation")
      {
        if (widget.dictation.say_word == false)
        {
          if (widget.dictation.words_list[i].translation == check_word.shown_word)
          {
            return Text("${widget.dictation.words_list[i].word}",style: TextStyle(
                fontSize: 25,
                color: Colors.green
            ),);
          }
        }
        else
        {
          if (widget.dictation.words_list[i].translation == check_word.shown_word)
          {
            return Text("${widget.dictation.words_list[i].word}",style: TextStyle(
                fontSize: 25,
                color: Colors.green
            ),);
          }
        }
      }
    }

    return Text("",style: TextStyle(
        fontSize: 25,
        color: Colors.black
    ),);
  }
  Widget close_dictation()
  {

    return IconButton(
      icon: Icon(Icons.clear,size: 40,color: Colors.white,),
      onPressed: (){

        if (widget.last_dictation == "check")
          {
            widget.tested_words.forEach((cell) {
              GlobalParameters.last_dictation_tested_words.add(cell);
            });
            //GlobalParameters.last_dictation_tested_words = widget.tested_words;
            //_controller.clear();
            //GlobalParameters.last_saved_dictation.last_dictation_tested_words = widget.tested_words;
            //widget.dictation.last_dictation_tested_words.clear();
            widget.tested_words.forEach((cell)
            {
              GlobalParameters.last_saved_dictation.last_dictation_tested_words.add(cell);
              //widget.dictation.last_dictation_tested_words.add(cell);
            });
            print("finished recent: ${GlobalParameters.recentDictations.length.toString()}");
//            if (GlobalParameters.recentDictations.length < GlobalParameters.recent_dictations_length)
//            {
//              GlobalParameters.recentDictations.add(widget.dictation);
//            }
            //SaveInFile.save_recent_dictations();
            SaveInFile.save_last_dictation();
            GlobalParameters.tested_words_count = 0;
            GlobalParameters.tested_words.clear();
            //submit_button_text = "Submit";
            Navigator.pop(context);
            //Navigator.pop(context);
            //Navigator.pop(context);
            //Navigator.pop(context);
          }
        else
          {

            Navigator.pop(context);
          }

      },
    );
  }
  int wrong_words_count()
  {
    int wrong_words_count = 0;
    for (int i = 0;i < widget.tested_words.length;i ++)
      {
        String res = check_user_input(widget.tested_words[i],ReturnedType.CorrectOrWrong);
        if (res == "wrong")
        {
          wrong_words.add(Word(widget.dictation.words_list[i].word, widget.dictation
              .words_list[i].translation));
          wrong_words_count ++;
        }
      }
    return wrong_words_count;
  }
  String check_user_input(Check_word filledWord,ReturnedType returnType)
  {











    String user_text = "";
    Color correct_or_not;
    String result_color = "";
    List<Word> last_wrong_words = new List<Word>();
//    wrong_words.forEach((cell){
//      last_wrong_words.add(cell);
//    });
    wrong_words.clear();

    switch(filledWord.type)
        {
      case "word":
        {
          for (int i = 0;i < widget.dictation.words_list.length;i ++)
          {
            if (widget.dictation.words_list[i].word.toLowerCase() == filledWord.shown_word.toLowerCase())
            {
              String filled_word_translation;
              String real_translation;
              if (filledWord.translation == null)
                  filled_word_translation = "";
              else
              {
                bool is_in_hebrew = check_if_in_hebrew(filledWord.translation);
                if (is_in_hebrew == true)
                {
                  filled_word_translation = remove_decoration(filledWord.translation);
                }
                else{
                  filled_word_translation = filledWord.translation;
                }


//                bool is_in_english = check_if_in_english(filled_word.translation);
//                if (is_in_english == false)
//                  {
//                    filled_word_translation = remove_decoration(filled_word.translation);
//                  }
//                else{
//                  filled_word_translation = filled_word.translation;
//                }
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


              if (filled_word_translation.toLowerCase() == real_translation.toLowerCase())
              {
                user_text = filled_word_translation;
                correct_or_not = Colors.green[300];
                correct = true;
                result_color = "correct";
                words.add(widget.dictation.words_list[i].word);
              }
              else{
                user_text = filled_word_translation;
                correct_or_not = Colors.red[300];
                correct = false;
                result_color = "wrong";
                words.add(widget.dictation.words_list[i].word);
                bool already_exist = false;
                if (add_to_wrong_words == true)
                  {
                    for (int i = 0;i < wrong_words.length;i ++)
                      {
                        for (int j = 0;j < widget.dictation.words_list.length;j ++)
                          {
                            if (wrong_words[i] == Word(widget.dictation.words_list[j].word,widget.dictation.words_list[j].translation))
                            {
                              already_exist = true;
                            }
                          }
                      }
                    if (already_exist == false)
                      {
                        wrong_words.add(Word(widget.dictation.words_list[i].word, widget.dictation
                            .words_list[i].translation));
                        already_exist = true;
                      }
                  }
                //correct = false;
                break;
              }

            }
          }
        }
        break;
      case "translation":
        {
          for (int i = 0;i < widget.dictation.words_list.length;i ++)
          {

            if (filledWord.translation != null)
              {
                String word_input;
                String real_word;
                if (filledWord.shown_word == null)
                  word_input = "";
                else
                {
                  bool is_in_hebrew = check_if_in_hebrew(filledWord.translation);
                  if (is_in_hebrew == true)
                  {
                    word_input = remove_decoration(filledWord.translation);
                  }
                  else{
                    word_input = filledWord.translation;
                  }


//              bool is_in_english = check_if_in_english(filled_word.shown_word);
//              if (is_in_english == false)
//              {
//                word_input = remove_decoration(filled_word.shown_word);
//              }
//              else{
//                word_input = filled_word.shown_word;
//              }

                  //word_input = remove_decoration(filled_word.shown_word);
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



//              bool is_in_english = check_if_in_english(widget.dictation.words_list[i].word);
//              if (is_in_english == false)
//              {
//                real_word = remove_decoration(widget.dictation.words_list[i].word);
//              }
//              else{
//                real_word = widget.dictation.words_list[i].word;
//              }
                  //real_word = remove_decoration(widget.dictation.words_list[i].word);
                }


                if (widget.dictation.words_list[i].translation.toLowerCase() == filledWord.shown_word.toLowerCase())
                {

                  if (real_word == word_input)
                  {
                    user_text = word_input;
                    correct_or_not = Colors.green[300];
                    correct = true;
                    result_color = "correct";
                    words.add(widget.dictation.words_list[i].translation);
                  }
                  else{
                    user_text = word_input;
                    correct_or_not = Colors.red[300];
                    correct = false;
                    result_color = "wrong";
                    words.add(widget.dictation.words_list[i].translation);
                    bool already_exist = false;
                    if (add_to_wrong_words == true)
                    {
                      for (int i = 0;i < wrong_words.length;i ++)
                      {
                        for (int j = 0;j < widget.dictation.words_list.length;j ++)
                        {
                          if (wrong_words[i] == Word(widget.dictation.words_list[j].word,widget.dictation.words_list[j].translation))
                          {
                            already_exist = true;
                          }
                        }
                      }
                      if (already_exist == false)
                      {
                        wrong_words.add(Word(widget.dictation.words_list[i].word, widget.dictation
                            .words_list[i].translation));
                        already_exist = true;
                      }
                    }
                    //correct = false;
                  }
                  break;
                }
              }
            else{
              user_text = "";
              correct_or_not = Colors.red[300];
              correct = false;
              result_color = "wrong";
              words.add(widget.dictation.words_list[i].translation);
              bool already_exist = false;
              if (add_to_wrong_words == true)
              {
                for (int i = 0;i < wrong_words.length;i ++)
                {
                  for (int j = 0;j < widget.dictation.words_list.length;j ++)
                  {
                    if (wrong_words[i] == Word(widget.dictation.words_list[j].word,widget.dictation.words_list[j].translation))
                    {
                      already_exist = true;
                    }
                  }
                }
                if (already_exist == false)
                {
                  wrong_words.add(Word(widget.dictation.words_list[i].word, widget.dictation
                      .words_list[i].translation));
                  already_exist = true;
                }
              }
              //correct = false;
              break;
            }

          }

          /////////////////////////////////////////////////////////////////////////////////////


//          for (int i = 0;i < widget.dictation.words_list.length;i ++)
//          {
//            if (widget.dictation.words_list[i].translation.toLowerCase() == filled_word.shown_word.toLowerCase())
//            {
//              if (filled_word.translation.toLowerCase() == widget.dictation.words_list[i].word.toLowerCase())
//                {
//                  user_text = filled_word.translation;
//                  correct_or_not = Colors.green[300];
//                  result_color = "correct";
//                  //GlobalParameters.correct_counter++;
//                  correct = true;
//                }
//              else{
//                user_text = filled_word.translation;
//                correct_or_not = Colors.red[300];
//                result_color = "wrong";
//                //wrong_words.add(Word(widget.dictation.words_list[i].word,widget.dictation.words_list[i].translation));
//
//                words.add(widget.dictation.words_list[i].word);
//                bool already_exist = false;
//                if (add_to_wrong_words == true)
//                {
//                  for (int i = 0;i < wrong_words.length;i ++)
//                  {
//                    for (int j = 0;j < widget.dictation.words_list.length;j ++)
//                    {
//                      if (wrong_words[i] == Word(widget.dictation.words_list[j].word,widget.dictation.words_list[j].translation))
//                      {
//                        already_exist = true;
//                      }
//                    }
//
//                  }
//                  if (already_exist == false)
//                  {
//                    wrong_words.add(Word(widget.dictation.words_list[i].word,widget.dictation.words_list[i].translation));
//                  }
//
//                }
//                correct = false;
//              }
//              break;
//            }
//            else if (filled_word.shown_word == "")
//            {
//              correct = false;
//            }
//          }
        }
        break;
    }
//    for (int i = 0;i < wrong_words.length;i ++)
//      {
//        bool add_word = false;
//        Word word;
//        for (int j = 0;j < last_wrong_words.length;j ++)
//        {
//          if (last_wrong_words[j].word != wrong_words[i].word)
//            {
//              add_word = true;
//              word = last_wrong_words[j];
//            }
//        }
//        if (add_word == true)
//          {
//            wrong_words.add(word);
//          }
//      }
//    last_wrong_words.forEach((cell){
//      if (wrong_words.contains(cell) == false)
//        {
//          wrong_words.a
//        }
//    });
    if (returnType == ReturnedType.Value)
      {
        return user_text;
      }
    else if (returnType == ReturnedType.CorrectOrWrong)
    {
      return result_color;
    }

//    return Container(
//      child: Text(user_text,style: TextStyle(
//          fontSize: 25,
//          color: Colors.black
//        //backgroundColor: correct_or_not,
//      ),textAlign: TextAlign.end,),
//    );


  }


  Widget custom_button(String text,Function on_pressed,[Widget icon])
  {
    return RaisedButton(
      onPressed: () {
        on_pressed();
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
      padding: const EdgeInsets.all(0.0),
      child: Container(
        decoration: BoxDecoration(
          gradient:  LinearGradient(
            colors: <Color>[
              GlobalParameters.DarkMode ? Colors.orange[800] : Colors.orange[300],
              Colors.orange,
              //Color(0xFF1976D2),
              //kInfectedColor,
            ],
          ),
          borderRadius: BorderRadius.all(Radius.circular(80.0)),
        ),
        child: Container(
          constraints: const BoxConstraints(minWidth: 88.0, minHeight: 36.0), // min sizes for Material buttons
          alignment: Alignment.center,
          child: Row(
            children: <Widget>[
              icon != null ? icon : SizedBox.shrink(),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 17,
                    //color: GlobalParameters.DarkMode ? Colors.black : Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}