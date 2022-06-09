import 'package:dictation_app/Globals/GlobalParameters.dart';
import 'package:dictation_app/Globals/constant.dart';
import 'package:dictation_app/SaveInFile.dart';
import 'package:flutter/material.dart';

String language_key(type,word_language,translation_language)
{
  for (int i = 0;i < GlobalParameters.languages_keys.length;i ++)
  {
    if (type == "word")
    {
      if (GlobalParameters.languages_names[i] == word_language)
      {
        return GlobalParameters.languages_keys[i];
      }
    }
    else if (type == "translation")
    {
      if (GlobalParameters.languages_names[i] == translation_language)
      {
        return GlobalParameters.languages_keys[i];
      }
    }

  }
  return "auto";
}
bool check_if_in_english(String text)
{
  String letters = "ABCDEFGHIKLMNOPQRSTVXYZabcdefghijklmnopqrstuvwxyz";
  int letter_counter = 0;
  for (int i = 0;i < text.length;i ++)
  {
    if (letters.contains(text[i]))
    {
      letter_counter ++;
    }
  }
  if (letter_counter == text.length)
  {
    return true;
  }
  return false;
}
bool check_if_in_hebrew(String text)
{
  //String letters = "ABCDEFGHIKLMNOPQRSTVXYZabcdefghijklmnopqrstuvwxyz";
  int letter_counter = 0;
  for (int i = 0;i < text.length;i ++)
  {
    if (GlobalParameters.hebrew_letters.contains(text[i]))
    {
      letter_counter ++;
    }
  }
  if (letter_counter == text.length)
  {
    return true;
  }
  return false;
}
void SwitchToDarkMode()
{

}
void SwitchToLightMode()
{

}
Widget custom_button(Widget buttonChild,Function on_pressed,Color firstColor,Color secondColor)
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
            firstColor,
            secondColor,
          ],
        ),
        borderRadius: BorderRadius.all(Radius.circular(80.0)),
      ),
      child: Container(
        constraints: const BoxConstraints(minWidth: 88.0, minHeight: 36.0),
          child: buttonChild,

      ),
//      Container(
//        constraints: const BoxConstraints(minWidth: 88.0, minHeight: 36.0), // min sizes for Material buttons
//        alignment: Alignment.center,
//        child: Text(
//          text,
//          textAlign: TextAlign.center,
//          style: TextStyle(
//              fontSize: 17
//          ),
//        ),
//      ),
    ),
  );
}
