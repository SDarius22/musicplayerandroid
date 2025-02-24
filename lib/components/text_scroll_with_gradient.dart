import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:musicplayerandroid/utils/text_scroll/text_scroll.dart';

class TextScrollWithGradient extends StatelessWidget{
  const TextScrollWithGradient({super.key, required this.text, required this.style,});
  final String text;
  final TextStyle style;
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: FractionalOffset.center,
          end: FractionalOffset.bottomCenter,
          colors: [
            Colors.black.withOpacity(0.0),
            Colors.black.withOpacity(0.4),
            Colors.black,
          ],
          stops: const [0.0, 0.5, 1.0]
        )
      ),
      child: TextScroll(
        text,
        mode: TextScrollMode.bouncing,
        velocity: const Velocity(pixelsPerSecond: Offset(20, 0)),
        style: style,
        pauseOnBounce: const Duration(seconds: 2),
        delayBefore: const Duration(seconds: 2),
        pauseBetween: const Duration(seconds: 2),
      ),
    );
  }

}