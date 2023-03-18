import 'dart:async';
import 'dart:ui';

import 'package:chatgpt_flutter_app/controller/home_controller.dart';
import 'package:chatgpt_flutter_app/core/constants/colors.dart';
import 'package:chatgpt_flutter_app/model/message_model.dart';
import 'package:chatgpt_flutter_app/view/home/widgets/gpt_message_raw.dart';
import 'package:chatgpt_flutter_app/view/home/widgets/user_message_raw.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

const String CONVERSATION_LIST_ID = "CONVERSATION_LIST_ID";

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final HomeController _controller = Get.find();

  // List<MessageModel> _messages = [];
  TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsConstant.a,
      appBar: AppBar(
        backgroundColor: ColorsConstant.b,
        title: const Text(
          'CHAT-GPT Conversation',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 13,
            fontFamily: 'Arial',
          ),
        ),
        elevation: 0,
        titleSpacing: 25,
        toolbarHeight: 60,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        actions: [
          // IconButton(
          //   icon: Icon(
          //     Icons.category_outlined,
          //     color: Colors.white,
          //     size: 20,
          //   ),
          //   onPressed: () => showModelsBottomSheet(),
          // ),
          // SizedBox(
          //   width: 10,
          // ),
          GestureDetector(
            onTap: () {
              _controller.createNewConversation();
            },
            child: const Icon(
              Icons.add_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(
            width: 20,
          )
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
              child: GetBuilder(
            init: _controller,
            id: CONVERSATION_LIST_ID,
            builder: (_) {
              return ListView.separated(
                controller: _controller.conversationScrollController,
                separatorBuilder: (_, i) => const SizedBox(
                  height: 8,
                ),
                padding: const EdgeInsets.only(
                    top: 25, left: 25, right: 25, bottom: 85),
                itemCount: _controller.conversation.length,
                // reverse: true,
                itemBuilder: (_, i) {
                  if (_controller.conversation.elementAt(i) is MessageModel)
                    return UserMessageRawWidget(
                      data:
                          _controller.conversation.elementAt(i) as MessageModel,
                      withPopupAnimation:
                          i == _controller.conversation.length - 1,
                    );
                  return GptMessageRawWidget(
                    data: _controller.conversation.elementAt(i)
                        as Future<MessageModel>,
                    withPopupAnimation:
                        i == _controller.conversation.length - 1,
                  );
                },
              );
            },
          )),
          Positioned(
            bottom: 25,
            right: 25,
            left: 25,
            // height: 42,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: TextField(
                    controller: _textEditingController,
                    onSubmitted: (s) {
                      _controller.sendMessage(s);
                      _textEditingController.text = "";
                    },
                    maxLines: 30,
                    minLines: 1,
                    expands: false,
                    cursorColor: Colors.white,
                    style: const TextStyle(
                      fontSize: 12,
                      fontFamily: 'Arial',
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Ask a question...',
                      hintStyle: TextStyle(
                        color: Colors.white.withOpacity(.5),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      contentPadding: const EdgeInsets.all(17),
                      isCollapsed: true,
                      filled: true,
                      fillColor: ColorsConstant.b,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () {
                    setState(
                      () {
                        _controller.sendMessage(_textEditingController.text);
                        _textEditingController.text = "";
                      },
                    );
                  },
                  child: SizedBox.square(
                    dimension: 40,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: ColorsConstant.b,
                      ),
                      child: const Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                        size: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // void showModelsBottomSheet() {
  //   Get.bottomSheet(
  //       ListView.builder(
  //             itemCount: ModelsNamesAndUrlsConstants.models.length,
  //             itemBuilder: (_, i) {
  //               return ListTile(
  //                 trailing:
  //                     ModelsNamesAndUrlsConstants.models.keys.elementAt(i) == _controller.selectedModel
  //                         ? Icon(
  //                             Icons.check,
  //                             color: Colors.white,
  //                           )
  //                         : SizedBox.shrink(),
  //                 onTap: () {
  //                   _controller.selectedModel = ModelsNamesAndUrlsConstants.models.keys.elementAt(i);
  //                   Get.back();
  //                 },
  //                 contentPadding: EdgeInsets.symmetric(horizontal: 25),
  //                 title: Text(
  //                   ModelsNamesAndUrlsConstants.models.keys.elementAt(i),
  //                   style: TextStyle(
  //                     color: Colors.white,
  //                     fontWeight: FontWeight.w600,
  //                     fontSize: 13,
  //                   ),
  //                 ),
  //               );
  //             },
  //           ), 
  //       backgroundColor: ColorsConstant.b,
  //       elevation: 20,
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.only(
  //           topLeft: Radius.circular(20),
  //           topRight: Radius.circular(20),
  //         ),
  //       ));
  // }
}
