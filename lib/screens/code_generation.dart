import 'dart:async';

import 'package:chat_gpt_02/screens/code.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:progress_indicators/progress_indicators.dart';

import '../chat.dart';

class CodeGeneration extends StatefulWidget {
  const CodeGeneration({super.key});

  @override
  State<CodeGeneration> createState() => _CodeGenerationState();
}

class _CodeGenerationState extends State<CodeGeneration> {
  final TextEditingController _controller = TextEditingController();
  final List<Code> _messages = [];
  ChatGPT? chatGPT;

  StreamSubscription? _subscription;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    chatGPT = ChatGPT.instance.builder(
      "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",
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void search() {
    if (_controller.text.isEmpty) return;
    if (_messages.isNotEmpty) {
      for (var element in _messages) {
        setState(() {
          element.last = 0;
        });
      }
    }
    Code message = Code(
      text: _controller.text,
      sender: "user",
      last: 1,
    );

    setState(() {
      _messages.insert(0, message);
      _isLoading = true;
    });
    try {
      final request = CompleteReq(
          prompt: _controller.text.toString(),
          model: kTranslateModelV3,
          max_tokens: 200);
      _controller.clear();
      int i = 0;
      _subscription =
          chatGPT!.onCompleteStream(request: request).listen((response) {
     
        Code botMessage = Code(
          text: response!.choices[0].text,
          last: _messages.length,
          sender: "ai",
        );
        setState(() {
          i += 1;
        });
        setState(() {
          if (i > 1) {
            return;
          } else {
            _isLoading = false;
            _messages.insert(0, botMessage);
          }
        });
      });   Timer(const Duration(seconds: 15), () {
          setState(() {
            _isLoading = false;
            Code botMessage = Code(
          text: "Sorry! I can't do that.",
          last: _messages.length,
          sender: "ai",
        );
        setState(() {
          i += 1;
        });
        setState(() {
          if (i > 1) {
            return;
          } else {
            _isLoading = false;
            _messages.insert(0, botMessage);
          }
        });
          });
        });
    } catch (e) {}
  }

  Widget _searchField(double w) {
    return Padding(
      padding: EdgeInsets.only(left: w / 20, right: w / 20),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              onSubmitted: (_) => search(),
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: "Gilroy_Medium",
                  fontSize: w / 24),
              decoration:
                  const InputDecoration.collapsed(hintText: "Write here"),
            ),
          ),
          GestureDetector(
            onTap: () {
              search();
            },
            child: Image.asset(
              "assets/s.png",
              height: w / 15,
              color: const Color.fromARGB(255, 21, 255, 0),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.white,
      statusBarColor: Colors.white,
    ));
    var size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          toolbarHeight: 80,
          automaticallyImplyLeading: false,
          leading: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.black,
              )),
          title: Text(
            "Solve code",
            style: TextStyle(
                color: Colors.black,
                fontFamily: "Gilroy_Bold",
                fontSize: size.height / 35),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding:
                EdgeInsets.only(left: size.width / 20, right: size.width / 20),
            child: Column(
              children: [
                Flexible(
                    child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  reverse: true,
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    return _messages[index];
                  },
                )),
                if (_isLoading)
                  Center(
                      child: JumpingDotsProgressIndicator(
                    fontSize: 60,
                    color: const Color.fromARGB(255, 21, 255, 0),
                  )),
                Padding(
                  padding: EdgeInsets.all(size.width / 30),
                  child: Container(
                    padding: EdgeInsets.all(size.width / 40),
                    height: size.height / 15,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: const Color(0xfff5f9ff)),
                    child: _searchField(size.width),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
