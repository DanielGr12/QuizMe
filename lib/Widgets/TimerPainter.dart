import 'package:dictation_app/DictationPage/DictationQuiz.dart';
import 'package:dictation_app/DictationPage/OnFinished.dart';
import 'package:dictation_app/Globals/GlobalParameters.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter_tts/flutter_tts.dart';
//class TimerBuilder extends StatefulWidget {
//  @override
//  TimerPainter createState() => TimerPainter();
//}
class TimerPainter extends CustomPainter {
  Function onTimerFinished;
  TimerPainter({
    this.animation,
    this.backgroundColor,
    this.color,
    this.onTimerFinished,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final Color backgroundColor, color;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 15.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2.0, paint);
    paint.color = color;
    double progress = (1.0 - animation.value) * 2 * math.pi;
    canvas.drawArc(Offset.zero & size, math.pi * 1.5, -progress, false, paint);
  }

  @override
  bool shouldRepaint(TimerPainter old) {

    if ((animation.value == 0) && (GlobalParameters.said_word_counter == 1))
    {
      //onTimerFinished();
      //DictationQuiz
      //DictationQuiz.onFinished();
      //_DictationQuizState


    }
    return animation.value != old.animation.value ||
        color != old.color ||
        backgroundColor != old.backgroundColor;
  }
}
