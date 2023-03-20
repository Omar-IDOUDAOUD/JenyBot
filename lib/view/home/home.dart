import 'dart:async';
import 'dart:ui';

import 'package:chatgpt_flutter_app/controller/home_controller.dart';
import 'package:chatgpt_flutter_app/core/constants/colors.dart';
import 'package:chatgpt_flutter_app/model/message_model.dart';
import 'package:chatgpt_flutter_app/view/home/widgets/gpt_message_raw.dart';
import 'package:chatgpt_flutter_app/view/home/widgets/models_selection_bottom_sheet.dart';
import 'package:chatgpt_flutter_app/view/home/widgets/question_input_field.dart';
import 'package:chatgpt_flutter_app/view/home/widgets/user_message_raw.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'widgets/drawer.dart';

const String CONVERSATION_LIST_ID = "CONVERSATION_LIST_ID";

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final HomeController _controller = Get.find();
  

  late TextEditingController _questionTextEditingController;
  late FocusNode _questionInputFocusNode;

  @override
  void initState() {
    // TODO: implement initState
    super.initState(); 
    _questionInputFocusNode = FocusNode();
    _questionTextEditingController = TextEditingController(); 
  }

  @override
  void dispose() { 
    _questionInputFocusNode.dispose();
    _questionTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SafeArea(child: const CostumeDrawer()),
      drawerScrimColor: Colors.black54.withOpacity(.2),
      backgroundColor: ColorsConstant.a,
      appBar: AppBar(
        shadowColor: Colors.black54,
        automaticallyImplyLeading: false,
        leading: Builder(builder: (context) {
          return GestureDetector(
            onTap: Scaffold.of(context).openDrawer,
            child: Padding(
              padding: const EdgeInsets.only(left: 25),
              child: SvgPicture.asset(
                'assets/drawer-icon.svg',
                fit: BoxFit.contain,
              ),
            ),
          );
        }),
        leadingWidth: 40,
        backgroundColor: ColorsConstant.b,
        title: const Text(
          'Chat-Bot App',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: 'Inter',
          ),
        ),
        elevation: 30,
        titleSpacing: 20,
        toolbarHeight: 60,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Get.bottomSheet(
                const ModelSelectionBottomSheet(),
                backgroundColor: ColorsConstant.e,
                elevation: 20,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(30),
                  ),
                ),
              );
            },
            child: SvgPicture.asset('assets/models-icon.svg', height: 13),
          ),
          const SizedBox(
            width: 20,
          ),
          GestureDetector(
            onTap: () {
              _controller.createNewConversation();
            },
            child: SvgPicture.asset('assets/add.svg', height: 13),
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
                      onEdit: (t) {
                        _questionTextEditingController.text = t;
                        FocusScope.of(context)
                            .requestFocus(_questionInputFocusNode);
                      },
                      onSave: (content) {
                        _controller.saveMessage(
                            msg: content, owner: MessageOwner.user);
                      },
                    );
                  return GptMessageRawWidget(
                    data: _controller.conversation.elementAt(i)
                        as Future<MessageModel>,
                    withPopupAnimation:
                        i == _controller.conversation.length - 1,
                    onEdit: (t) {
                      _questionTextEditingController.text = t;
                      FocusScope.of(context).unfocus();
                      _questionInputFocusNode.requestFocus();
                    },
                    onSave: (content) {
                      _controller.saveMessage(
                          msg: content, owner: MessageOwner.gpt);
                    },
                  );
                },
              );
            },
          )),
          Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: QuestionInputField(
                focusNode: _questionInputFocusNode,
                textEditingController: _questionTextEditingController,
              )),
        ],
      ),
    );
  }
}
