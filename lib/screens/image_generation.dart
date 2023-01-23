import 'dart:async';

import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:progress_indicators/progress_indicators.dart';

import '../chat.dart';

class ImageGeneration extends StatefulWidget {
  const ImageGeneration({super.key});

  @override
  State<ImageGeneration> createState() => _ImageGenerationState();
}

class _ImageGenerationState extends State<ImageGeneration> {
  final TextEditingController _controller = TextEditingController();
  final List images = [];

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
    chatGPT!.genImgClose();
    _subscription?.cancel();
    super.dispose();
  }

  void search() {
    if (_controller.text.isEmpty) return;
    setState(() {
      _isLoading = true;
    });
    final request = GenerateImage(_controller.text, 1, size: "256x256");
    _controller.clear();
    int i = 0;
    _subscription = chatGPT!
        .generateImageStream(request)
        .asBroadcastStream()
        .listen((response) {
      setState(() {
        i += 1;
      });

      if (i < 2) {
        ChatMessage botMessage = ChatMessage(
          text: response.data!.last!.url!,
          sender: "ai",
          last: 1,
        );

        setState(() {
          _isLoading = false;

          images.insert(0, botMessage);
        });
      }
    });
    Timer(const Duration(seconds: 15), () {
      setState(() {
        _isLoading = false;
   
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
              decoration: const InputDecoration.collapsed(
                  hintText: "What do you want to create?"),
            ),
          ),
          GestureDetector(
            onTap: () {
              search();
            },
            child: Image.asset(
              "assets/s.png",
              height: w / 15,
              color: const Color.fromRGBO(58, 0, 255, 1),
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
            "Generate Images",
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
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: size.height / 55,
                        ),
                        Container(
                          width: size.width * 0.8,
                          padding: EdgeInsets.all(size.width / 40),
                          height: size.height / 3,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: const Color(0xfff5f9ff)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              images[index].text,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child,
                                      loadingProgress) =>
                                  loadingProgress == null
                                      ? child
                                      : const Center(
                                          child: CircularProgressIndicator(
                                          color: Color.fromRGBO(58, 0, 255, 1),
                                          strokeWidth: 1,
                                        )),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                )),
                if (_isLoading)
                  Center(
                    child: JumpingDotsProgressIndicator(
                        fontSize: 60,
                        color: const Color.fromRGBO(58, 0, 255, 1)),
                  ),
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
