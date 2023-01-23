import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';

class Code extends StatelessWidget {
  Code({
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
            color: const Color.fromARGB(255, 21, 255, 0),
            child: Text(text,
                textAlign: TextAlign.justify,
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Gilroy_Medium",
                    fontSize: size.height / 50)),
          )
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                padding: EdgeInsets.all(size.width / 20),
                decoration: BoxDecoration(
                    color: const Color.fromRGBO(59, 24, 95, 1),
                    borderRadius: BorderRadius.circular(20)),
                child: Center(
                    child: last == 0
                        ? Text(
                            text,
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Gilroy_Medium",
                                fontSize: size.height / 50),
                          )
                        : AnimatedTextKit(
                            animatedTexts: [
                              TyperAnimatedText(text,
                                  textAlign: TextAlign.justify,
                                  textStyle: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "Gilroy_Medium",
                                      fontSize: size.height / 50)),
                            ],
                            totalRepeatCount: 1,
                          ))),
          );
  }
}
