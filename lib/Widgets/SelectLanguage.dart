import 'package:dictation_app/Globals/GlobalParameters.dart';
import 'package:flutter/material.dart';

import 'new_dictation.dart';

class SelectLanguage extends StatefulWidget {
  Dictation dictation;
  String language;
  SelectLanguage(this.language,this.dictation);
  @override
  _SelectLanguageState createState() => _SelectLanguageState();
}

class _SelectLanguageState extends State<SelectLanguage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Choose language"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                //scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: GlobalParameters.languages_names.length,
                itemBuilder: (BuildContext context, int index) =>
                    LanguageCard(context, index)),
          ],
        ),
      ),
    );
  }
  Widget LanguageCard(BuildContext context,int index)
  {
    return Column(
      children: <Widget>[
        ListTile(
          onTap: (){
            if (widget.language == "word")
              {
                  GlobalParameters.add_dictation_word_language = GlobalParameters.languages_names[index];
              }

            if (widget.language == "translation"){
                GlobalParameters.add_dictation_translation_language = GlobalParameters.languages_names[index];
            }

            Navigator.pop(context);
          },
          title: Text(GlobalParameters.languages_names[index]),
          trailing: is_selected(index),
        ),
        Divider(color: Colors.grey,)
      ],
    );
  }
  Widget is_selected(int index)
  {
    if (widget.language == "word")
      {
        if (GlobalParameters.add_dictation_word_language == GlobalParameters.languages_names[index])
          {
            return Icon(Icons.check,color: Colors.blue,);
          }
        if (GlobalParameters.add_dictation_translation_language == GlobalParameters.languages_names[index])
        {
          return Icon(Icons.check,color: Colors.grey,);
        }
      }
    else if (widget.language == "translation")
    {
      if (GlobalParameters.add_dictation_word_language == GlobalParameters.languages_names[index])
      {
        return Icon(Icons.check,color: Colors.grey,);
      }
      if (GlobalParameters.add_dictation_translation_language == GlobalParameters.languages_names[index])
      {
        return Icon(Icons.check,color: Colors.blue,);
      }
    }
//    if (GlobalParameters.add_dictation_word_language == GlobalParameters.languages_names[index])
//    {
//      if (widget.language == "word")
//        return Icon(Icons.check,color: Colors.blue,);
//      else if (widget.language == "translation")
//        return Icon(Icons.check,color: Colors.blue,);
//    }
//    else if (GlobalParameters.add_dictation_translation_language == GlobalParameters.languages_names[index])
//    {
//      return Icon(Icons.check,color: Colors.redAccent,);
//    }
//    if (widget.language == "word")
//      {
//        if (GlobalParameters.add_dictation_word_language == GlobalParameters.languages_names[index])
//          {
//            return Icon(Icons.check,color: Colors.blue,);
//          }
//      }
//    else if (widget.language == "translation")
//    {
//      if (GlobalParameters.add_dictation_translation_language == GlobalParameters.languages_names[index])
//      {
//        return Icon(Icons.check,color: Colors.blue,);
//      }
//    }
    return SizedBox.shrink();
  }
}