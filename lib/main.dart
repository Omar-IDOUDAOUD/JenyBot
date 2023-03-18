import 'package:chatgpt_flutter_app/view/home/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'binding/home_binding.dart';

void main() {
  runApp(const ChatGptConversationApp());
}

class ChatGptConversationApp extends StatelessWidget {
  const ChatGptConversationApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
      initialBinding: HomeBinding(),
    );
  }
}
