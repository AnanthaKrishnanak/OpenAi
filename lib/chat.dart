import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  ChatMessage({
    super.key,
    required this.text,
    required this.sender,
    required this.last,
  });

  final String text;
  final String sender;
  int last;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return sender == "user"
        ? Bubble(
            margin: const BubbleEdges.only(top: 10),
            padding: const BubbleEdges.all(20),
            alignment: Alignment.topRight,
            nip: BubbleNip.rightTop,
            color: const Color.fromRGBO(255, 0, 136, 1),
            child: Text(text,
                textAlign: TextAlign.justify,
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Gilroy_Medium",
                    fontSize: size.height / 50)),
          )
        : Bubble(
            margin: BubbleEdges.only(top: size.height / 55),
            padding: BubbleEdges.only(
                left: size.width / 20,
                bottom: size.width / 20,
                right: size.width / 20),
            alignment: Alignment.topLeft,
            nip: BubbleNip.leftTop,
            color: const Color(0xfff5f9ff),
            child: last == 0
                ? Text(
                    text,
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: "Gilroy_Medium",
                        fontSize: size.height / 50),
                  )
                : AnimatedTextKit(
                    animatedTexts: [
                      TyperAnimatedText(text,
                          textAlign: TextAlign.justify,
                          textStyle: TextStyle(
                              color: Colors.black,
                              fontFamily: "Gilroy_Medium",
                              fontSize: size.height / 50)),
                    ],
                    totalRepeatCount: 1,
                  ));
  }
}
