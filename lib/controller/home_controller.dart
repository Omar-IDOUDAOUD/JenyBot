import 'dart:async';

import 'package:chatgpt_flutter_app/model/message_model.dart';
import 'package:chatgpt_flutter_app/services/api_services.dart';
import 'package:chatgpt_flutter_app/view/home/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  List<FutureOr<MessageModel>> conversation = [];
  ScrollController conversationScrollController =
      ScrollController(keepScrollOffset: true);

  ApiService _apiService = Get.find();


  Future<void> sendMessage(String message) async {
    startScrollingDown(100.milliseconds);
    conversation.add(MessageModel(owner: MessageOwner.user, content: message));
    update([CONVERSATION_LIST_ID]);
    await 400.milliseconds.delay();
    conversation.add(_getResponse(message));
    update([CONVERSATION_LIST_ID]);
    stopScrollingDown();
  }

  bool _canScrollingDown = false;

  void startScrollingDown(Duration periodicDuration) {
    _canScrollingDown = true;
    Timer.periodic(periodicDuration, (time) {
      print(time.tick);
      if (!_canScrollingDown) {
        time.cancel();
      }
      conversationScrollController.animateTo(
          conversationScrollController.position.maxScrollExtent + 90,
          duration: 600.milliseconds,
          curve: Curves.linearToEaseOut);
    });
  }

  void stopScrollingDown() {
    _canScrollingDown = false;
  }

  Future<MessageModel> _getResponse(String message) async {
    return await _apiService.sendRequestAndGetResponse(message);
  }

  void createNewConversation() {
    conversation.clear();
    update([CONVERSATION_LIST_ID]);
  }
}
