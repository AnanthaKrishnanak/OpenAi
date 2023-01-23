import 'dart:async';

import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:progress_indicators/progress_indicators.dart';

import '../chat.dart';

class TextGeneration extends StatefulWidget {
  const TextGeneration({super.key});

  @override
  State<TextGeneration> createState() => _TextGenerationState();
}

class _TextGenerationState extends State<TextGeneration> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
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
      _messages.forEach((element) {
        setState(() {
          element.last = 0;
        });
      });
    }
    ChatMessage message = ChatMessage(
      text: _controller.text,
      sender: "user",
      last: 1,
    );

    setState(() {
      _messages.insert(0, message);
      _isLoading = true;
    });

    final request = CompleteReq(
        prompt: _controller.text.toString(),
        model: kTranslateModelV3,
        max_tokens: 200);
    _controller.clear();
    int i = 0;
    _subscription =
        chatGPT!.onCompleteStream(request: request).listen((response) {
      ChatMessage botMessage = ChatMessage(
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
    });
     Timer(const Duration(seconds: 15), () {
          setState(() {
            _isLoading = false;
            ChatMessage botMessage = ChatMessage(
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
              color: const Color.fromRGBO(255, 0, 136, 1),
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
            "Chat with AI",
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
                    color: const Color.fromRGBO(255, 0, 136, 1),
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
