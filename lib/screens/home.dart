import 'package:chat_gpt_02/screens/code_generation.dart';
import 'package:chat_gpt_02/screens/image_generation.dart';
import 'package:chat_gpt_02/screens/text_generation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
        toolbarHeight: 100,
        elevation: 0,
        title: Text(
          "Open AI",
          style: TextStyle(
              fontFamily: "Gilroy_Bold",
              fontSize: size.height / 35,
              color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(children: [
          GestureDetector(
            onTap: () {
              Get.to(const TextGeneration(), transition: Transition.cupertino);
            },
            child: Padding(
              padding: EdgeInsets.only(
                  top: size.width / 20,
                  left: size.width / 20,
                  right: size.width / 20),
              child: Container(
                height: size.height / 8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color(0xfff5f9ff),
                ),
                child: Center(
                    child: ListTile(
                  leading: Icon(
                    Iconsax.edit,
                    size: size.height / 15,
                    color: const Color.fromRGBO(255, 0, 136, 1),
                  ),
                  title: Text(
                    "Text generation",
                    style: TextStyle(
                        fontFamily: "Gilroy_Bold", fontSize: size.height / 45),
                  ),
                  subtitle: Text(
                    "Generate and edit text",
                    style: TextStyle(
                        color: const Color(0xffacafc3),
                        fontFamily: "Gilroy_Medium",
                        fontSize: size.height / 55),
                  ),
                )),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Get.to(const ImageGeneration(), transition: Transition.cupertino);
            },
            child: Padding(
              padding: EdgeInsets.all(size.width / 20),
              child: Container(
                height: size.height / 8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color(0xfff5f9ff),
                ),
                child: Center(
                    child: ListTile(
                  leading: Icon(
                    Iconsax.image,
                    size: size.height / 15,
                    color: const Color.fromRGBO(58, 0, 255, 1),
                  ),
                  title: Text(
                    "Image generation",
                    style: TextStyle(
                        fontFamily: "Gilroy_Bold", fontSize: size.height / 45),
                  ),
                  subtitle: Text(
                    "Generate and edit images",
                    style: TextStyle(
                        color: const Color(0xffacafc3),
                        fontFamily: "Gilroy_Medium",
                        fontSize: size.height / 55),
                  ),
                )),
              ),
            ),
          ),GestureDetector(
            onTap: () {
              Get.to(const CodeGeneration(), transition: Transition.cupertino);
            },
            child: Padding(
              padding: EdgeInsets.only(left:size.width / 20,right: size.width/20),
              child: Container(
                height: size.height / 8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color(0xfff5f9ff),
                ),
                child: Center(
                    child: ListTile(
                  leading: Icon(
                    Iconsax.code,
                    size: size.height / 15,
                    color: const Color.fromARGB(255, 21, 255, 0),
                  ),
                  title: Text(
                    "Code generation",
                    style: TextStyle(
                        fontFamily: "Gilroy_Bold", fontSize: size.height / 45),
                  ),
                  subtitle: Text(
                    "Solve computer problems",
                    style: TextStyle(
                        color: const Color(0xffacafc3),
                        fontFamily: "Gilroy_Medium",
                        fontSize: size.height / 55),
                  ),
                )),
              ),
            ),
          ),
          SizedBox(
            height: size.height / 55,
          ),
          Row(
            children: [
              SizedBox(
                width: size.width / 20,
              ),
              Text(
                "Limitaions",
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: "Gilroy_Bold",
                    fontSize: size.height / 45),
              ),
            ],
          ),
        
        
          Limitaions(
            size: size,
            text: "May occasionally generate incorrect information",
          ),
         
          Limitaions(
            size: size,
            text: "Limited knowledge of world and events after 2021",
          ),
         
          Limitaions(
            size: size,
            text: "May occasionally produce harmful instructions or biased content",
          )
        ]),
      ),
    );
  }
}

class Limitaions extends StatelessWidget {
  const Limitaions({
    Key? key,
    required this.size,
    required this.text,
  }) : super(key: key);

  final Size size;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top:size.width / 20,left: size.width / 20,right: size.width / 20),
      child: Container(
        width: size.width * 0.9,
        padding: EdgeInsets.all(size.width / 25),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color(0xfff5f9ff),
        ),
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.black54,
                fontFamily: "Gilroy_Medium",
                fontSize: size.height / 55),
          ),
        ),
      ),
    );
  }
}
