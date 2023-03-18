import 'package:chatgpt_flutter_app/core/constants/api_constants.dart';
import 'package:chatgpt_flutter_app/model/message_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService extends GetxService {
  Future<MessageModel> sendRequestAndGetResponse(
      String content,  ) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${ApiConstants.API_KEY}'
    };
    final body = {
      "model": 'gpt-3.5-turbo',
      "messages": [
        {"role": "user", "content": content}
      ]
    };
    print('body: ${json.encode(body)}');

    try {
      final request = await http.post(
        Uri.parse(ApiConstants.API_BASE_URL + '/chat/completions'),
        headers: headers,
        body: json.encode(body),
      );

      print('request: ${request.body}');

      final Map response = json.decode(request.body);

      if (response.containsKey('error'))
        return MessageModel(
            owner: MessageOwner.gpt,
            content: "ERROR: ${response['error']['message']}",
            error: true);

      final String answer = response['choices'][0]['message']['content'];
      print('answer: $answer');
      return MessageModel(owner: MessageOwner.gpt, content: answer.trim());
    } catch (e) {
      return MessageModel(
          owner: MessageOwner.gpt, content: "ERROR: $e", error: true);
    }
  }

 
}
