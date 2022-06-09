import 'package:dictation_app/Globals/GlobalParameters.dart';
import 'package:dictation_app/Globals/constant.dart';
import 'package:dictation_app/Widgets/my_header.dart';
import 'package:flutter/material.dart';

class OnPaperFinished extends StatefulWidget {

  Dictation dictation;
  List<Check_word> tested_words = new List<Check_word>();
  String last_dictation;
  OnPaperFinished(this.dictation,this.tested_words,this.last_dictation);
  @override
  _OnPaperFinishedState createState() => _OnPaperFinishedState();
}

class _OnPaperFinishedState extends State<OnPaperFinished> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
            textBottom:Text(""),
            offset: 2,
            height: 250,
            left_height: 30,
            right_height: 100,
            color_1: Colors.orange,
            color_2: Colors.redAccent,
            left_widget: Container(),
            right_widget: Container(),
          ),
        ],
      ),
    );
  }

}