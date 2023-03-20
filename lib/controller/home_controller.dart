import 'dart:async';
import 'dart:convert';

import 'package:chatgpt_flutter_app/core/constants/api_constants.dart';
import 'package:chatgpt_flutter_app/model/message_model.dart';
import 'package:chatgpt_flutter_app/services/api_services.dart';
import 'package:chatgpt_flutter_app/view/home/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends GetxController {
  List<FutureOr<MessageModel>> conversation = [];
  ScrollController conversationScrollController =
      ScrollController(keepScrollOffset: true);
  String _gptSelectedModelName = ApiConstants.GPT_MODELS_URLS.first['model'];
  String get gptSelectedModelName => _gptSelectedModelName;
  set gptSelectedModelName(v) {
    createNewConversation();
    _gptSelectedModelName = v;
  }

  String? _apiKey;
  String get apiKey => _apiKey!;
  set apiKey(String v) {
    _preferences!.setString('API-KEY-TOKEN', v);
    _apiKey = v;
  }

  final ApiService _apiService = Get.find();

  @override
  void onInit() async {
    super.onInit();
    _preferences = await SharedPreferences.getInstance();

    _apiKey = _preferences!.getString('API-KEY-TOKEN') ?? 'NO_TOKEN_PROVIDED';
  }

  Future<void> sendMessage(String message) async {
    startScrollingDown(100.milliseconds);
    conversation.add(MessageModel(owner: MessageOwner.user, content: message));
    update([CONVERSATION_LIST_ID]);
    await 400.milliseconds.delay();
    conversation
        .add(_getResponse(message));
    update([CONVERSATION_LIST_ID]);
    stopScrollingDown();
  }

  bool _canScrollingDown = false;

  void startScrollingDown(Duration periodicDuration) {
    _canScrollingDown = true;
    Timer.periodic(periodicDuration, (time) {
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
    return await _apiService.sendRequestAndGetResponse(
        message, _apiKey!, gptSelectedModelName);
  }

  void createNewConversation() {
    conversation.clear();
    update([CONVERSATION_LIST_ID]);
  }

  List<Map>? _savedMessages ;

  SharedPreferences? _preferences;
  void saveMessage({required String msg, required MessageOwner owner}) async {
    _loadSavedMessages();

    _savedMessages!.add(
      {
        'message': msg,
        'owner': owner == MessageOwner.user ? 'user' : 'Assistant',
      },
    );

    _preferences!.setStringList('SAVED-MESSAGES-LIST',
        _savedMessages!.map((e) => json.encode(e).toString()).toList());
  }

  List<Map> getSavedMessages() {
    _loadSavedMessages();
    return _savedMessages!;
  }

  void _loadSavedMessages() {
    if (_savedMessages == null) {
      List jsonData = _preferences!.getStringList('SAVED-MESSAGES-LIST') ?? [];
      _savedMessages = jsonData.map((e) => json.decode(e) as Map).toList();
    }
  }
}
