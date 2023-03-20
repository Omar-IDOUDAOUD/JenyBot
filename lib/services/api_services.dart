import 'package:chatgpt_flutter_app/core/constants/api_constants.dart';
import 'package:chatgpt_flutter_app/model/message_model.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService extends GetxService {
  Future<MessageModel> sendRequestAndGetResponse(
      String content, String apiKey, String modelName) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey'
    };
    Map body = {
      "model": '$modelName',
    };
    final modelData = ApiConstants.GPT_MODELS_URLS
        .firstWhere((element) => element['model'] == modelName);

    body.addIf(
      modelData['method'] == 1,
      "prompt",
      content,
    );
    body.addIf(
      modelData['method'] == 2,
      "messages",
      [
        {"role": "user", "content": content}
      ],
    );

    try {
      final request = await http.post(
        Uri.parse(modelData['url']),
        headers: headers,
        body: json.encode(body),
      );


      final Map response = json.decode(request.body);

      if (response.containsKey('error'))
        return MessageModel(
            owner: MessageOwner.gpt,
            content: "ERROR: ${response['error']['message']}",
            error: true);

      final String answer = modelData['method'] == 1 
      ? response['choices'][0]['text'] 
      : response['choices'][0]['message']['content'];  
      return MessageModel(owner: MessageOwner.gpt, content: answer.trim());
    } catch (e) {
      return MessageModel(
          owner: MessageOwner.gpt, content: "ERROR: $e", error: true);
    }
  }
}
