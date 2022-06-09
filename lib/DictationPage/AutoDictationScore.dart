import 'package:dictation_app/DictationPage/OnFinished.dart';
import 'package:dictation_app/Globals/GlobalFunctions.dart';
import 'package:dictation_app/Globals/GlobalParameters.dart';
import 'package:flutter/material.dart';

class AutoDictationScore extends StatefulWidget {

  Dictation dictation;
  //List<Check_word> tested_words = new List<Check_word>();
  //String last_dictation;

  AutoDictationScore(this.dictation);
  @override
  _AutoDictationScoreState createState() => _AutoDictationScoreState();
}

class _AutoDictationScoreState extends State<AutoDictationScore>{
  List<Check_word> user_results = new List<Check_word>();
  List<Color> cards_colors = new List<Color>();

  @override
  Widget build(BuildContext context) {
    add_default_colors();
    return Scaffold(

      appBar: AppBar(
        title: Text("Grade your score"),
      ),
      body: Column(
        children: <Widget>[
          ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              //scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: widget.dictation.words_list.length,
              itemBuilder: (BuildContext context, int index) =>
                  ResultCard(context, index)),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: custom_button(Row(
              children: <Widget>[
                Text(
                  "Submit",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 17,
                      color: Colors.white
                  ),
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ), finished, Colors.blue[800], Colors.blue[400]),
          )
        ],
      ),
    );
  }
  void add_default_colors()
  {
    bool start = true;
    cards_colors.forEach((cell){
      if (cell != Colors.grey)
        {
          start = false;
        }
    });
    if (start == true)
      {
        cards_colors.clear();
        widget.dictation.words_list.forEach((cell){
          cards_colors.add(Colors.green);
          if (widget.dictation.test_type == "Show the translation"){
            Check_word word_to_add = Check_word(cell.word,cell.translation,"translation");
            user_results.add(word_to_add);
          }

          if (widget.dictation.test_type == "Show the word")
            {
              Check_word word_to_add = Check_word(cell.word,cell.translation,"Word");
              user_results.add(word_to_add);
            }

        });
      }

  }
  void finished()
  {
    widget.dictation.last_dictation_tested_words = user_results;
    widget.dictation.last_dictation_type = widget.dictation.test_type;
    GlobalParameters.last_dictation = widget.dictation;
    //GlobalParameters.Dictations[dictation_index].last_dictation_tested_words,
    //GlobalParameters.last_saved_dictation = widget.dictation;
    //Navigator.pop(context);
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return OnFinished(widget.dictation,user_results,"check");
        },
      ),
    );
  }
  Widget ResultCard(BuildContext context,int index)
  {

    return Column(
      children: <Widget>[
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
//            FloatingActionButton(
//              heroTag: "${widget.dictation.words_list[index].word} word",
//              backgroundColor: floating_action_button_color(true,index),
//              child: Icon(Icons.check),
//              onPressed: (){
//                Check_word word_to_add = Check_word(widget.dictation.words_list[index].translation,widget.dictation.words_list[index].word,"word");
//                user_results[index] = word_to_add;
//                setState(() {
//                  cards_colors[index] = Colors.green;
//                });
////                Check_word word_to_add = Check_word(widget.dictation.words_list[index].translation,widget.dictation.words_list[index].word,"word");
////                check_if_exists(index);
////                user_results.add(word_to_add);
////                setState(() {
////                  cards_colors[index] = Colors.green;
////                });
//                },
//            ),
//            Card(
//              elevation: 10,
//              shape: RoundedRectangleBorder(
//                side: new BorderSide(color: Colors.white60,
//                    width: 4.0),
//                borderRadius: BorderRadius.circular(20.0),
//              ),
//              child: Stack(
//                children: <Widget>[
////                  Align(
////                    alignment: Alignment.topLeft,
////                    child: Padding(
////                      padding: const EdgeInsets.all(8.0),
////                      child: IconButton(
////                        icon: Icon(Icons.delete_outline,color: Colors.redAccent,),
////                        onPressed: (){
////                          //remove_function(widget.dictation.words_list[index]);
////                        },
////                      ),
////                    ),
////                  ),
//                  Row(
//                    mainAxisAlignment: MainAxisAlignment.center,
//                    children: <Widget>[
//                      Expanded(
//                        child: Column(
//                          children: <Widget>[
//                            Padding(
//                              padding: const EdgeInsets.fromLTRB(10,50,10,15),
//                              child: widget.dictation.test_type == "Show the word" ? Text("${widget.dictation.words_list[index].word}",style: TextStyle(fontSize: 25),) : Text("${widget.dictation.words_list[index].translation}",style: TextStyle(fontSize: 25)) ,
//                            ),
//                            Padding(
//                              padding: const EdgeInsets.all(8.0),
//                              child: widget.dictation.test_type == "Show the word" ? Text("${widget.dictation.words_list[index].translation}",style: TextStyle(fontSize: 17),) : Text("${widget.dictation.words_list[index].word}",style: TextStyle(fontSize: 17),),
//                            ),
//                          ],
//                        ),
//                      ),
//                    ],
//                  ),
//                ],
//
//              ),
//            ),
              Expanded(
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    side: new BorderSide(
                        color: cards_colors[index],
                        width: 6.0),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Stack(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20,0,20,0),
                            child: FloatingActionButton(
                              heroTag: "${widget.dictation.words_list[index].word} word",
                              backgroundColor: floating_action_button_color(true,index),
                              child: Icon(Icons.check),
                              onPressed: (){
//                                if (user_results[index].type == "translation") {
//                                  Check_word word_to_add = Check_word("", widget.dictation.words_list[index].translation, "translation");
//                                  user_results[index] = word_to_add;
//                                }
//                                else if (user_results[index].type == "word") {
//                                  Check_word word_to_add = Check_word("", widget.dictation.words_list[index].word, "word");
//                                  user_results[index] = word_to_add;
//                                }
                                Check_word word_to_add = Check_word(widget.dictation.words_list[index].translation,widget.dictation.words_list[index].word,"word");
                                user_results[index] = word_to_add;
                                setState(() {
                                  cards_colors[index] = Colors.green;
                                });
//                Check_word word_to_add = Check_word(widget.dictation.words_list[index].translation,widget.dictation.words_list[index].word,"word");
//                check_if_exists(index);
//                user_results.add(word_to_add);
//                setState(() {
//                  cards_colors[index] = Colors.green;
//                });
                              },
                            ),
                          ),
                          Spacer(),
                          Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(10,35,10,15),
                                child: widget.dictation.test_type == "Show the word" ? Text("${widget.dictation.words_list[index].word}",style: TextStyle(fontSize: 25),) : Text("${widget.dictation.words_list[index].translation}",style: TextStyle(fontSize: 25)) ,
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(10,0,10,25),
                                child: widget.dictation.test_type == "Show the word" ? Text("${widget.dictation.words_list[index].translation}",style: TextStyle(fontSize: 17),) : Text("${widget.dictation.words_list[index].word}",style: TextStyle(fontSize: 17),),
                              ),
                            ],
                          ),
                          Spacer(),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20,0,20,0),
                            child: FloatingActionButton(
                              heroTag: "${widget.dictation.words_list[index].translation} translation",
                              backgroundColor: floating_action_button_color(false,index),
                              child: Icon(Icons.clear),
                              onPressed: (){
                                if (user_results[index].type == "translation") {
                                  Check_word word_to_add = Check_word("", widget.dictation.words_list[index].translation, "translation");
                                  user_results[index] = word_to_add;
                                }
                                else if (user_results[index].type == "word") {
                                  Check_word word_to_add = Check_word("", widget.dictation.words_list[index].word, "word");
                                  user_results[index] = word_to_add;
                                }
                                setState(() {
                                  cards_colors[index] = Colors.redAccent;
                                });

//                check_if_exists(index);
//                user_results.add(word_to_add);
//                setState(() {
//                  cards_colors[index] = Colors.redAccent;
//                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
//            Card(
//
//              shape: RoundedRectangleBorder(
//                side: new BorderSide(
//                    color: cards_colors[index],
//                    width: 4.0),
//                borderRadius: BorderRadius.circular(15.0),
//              ),
//              child: Column(
//                children: <Widget>[
//                  Row(
//                    mainAxisAlignment: MainAxisAlignment.spaceAround,
//                    children: <Widget>[
//                      Column(
//                        children: <Widget>[
//                          Padding(
//                            padding: const EdgeInsets.all(15.0),
//                            child: Text("Word",style: TextStyle(
//                                fontSize: 25
//                            ),),
//                          ),
//                          Padding(
//                            padding: const EdgeInsets.all(8.0),
//                            child: Text(widget.dictation.words_list[index].word,style: TextStyle(
//                                fontSize: 25
//                            ),),
//                          )
//                        ],
//                      ),
//                      Column(
//                        children: <Widget>[
//                          Padding(
//                            padding: const EdgeInsets.all(15.0),
//                            child: Text("Translation",style: TextStyle(
//                              fontSize: 25
//                            ),),
//                          ),
//                          Padding(
//                            padding: const EdgeInsets.all(8.0),
//                            child: Text(widget.dictation.words_list[index].translation,style: TextStyle(
//                                fontSize: 25
//                            ),),
//                          )
//                        ],
//                      ),
//                    ],
//                  )
//                ],
//              ),
//              //color: check_if_correct(widget.tested_words[index]),
//            ),
//            FloatingActionButton(
//              heroTag: "${widget.dictation.words_list[index].translation} translation",
//              backgroundColor: floating_action_button_color(false,index),
//              child: Icon(Icons.clear),
//              onPressed: (){
//                Check_word word_to_add = Check_word("",widget.dictation.words_list[index].word,"word");
//                user_results[index] = word_to_add;
//                setState(() {
//                  cards_colors[index] = Colors.redAccent;
//                });
//
////                check_if_exists(index);
////                user_results.add(word_to_add);
////                setState(() {
////                  cards_colors[index] = Colors.redAccent;
////                });
//              },
//            ),
              //
            ],
          ),
        Divider(endIndent: 10,indent: 10,color: Colors.grey,)
      ],
    );
  }
  Color floating_action_button_color(bool correct,int index)
  {
    if (cards_colors[index] == Colors.redAccent)
      {
        if (correct == false)
          {
            return Colors.redAccent;
          }
      }
    else if (cards_colors[index] == Colors.green)
    {
      if (correct == true)
      {
        return Colors.green;
      }
    }
    return Colors.grey;
  }
  void check_if_exists(int index)
  {
    for (int i = 0; i < user_results.length;i ++) {
      if (user_results[i].shown_word ==
          widget.dictation.words_list[index].word) {
        user_results.remove(user_results[i]);
      }
    }
  }
}