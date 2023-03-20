import 'package:chatgpt_flutter_app/controller/home_controller.dart';
import 'package:chatgpt_flutter_app/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuestionInputField extends StatelessWidget {
  QuestionInputField(
      {Key? key, this.focusNode, required this.textEditingController})
      : super(key: key);
  final FocusNode? focusNode;

  final HomeController _controller = Get.find();
  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: ColorsConstant.a,
          border: Border(
              top: BorderSide(color: Colors.white.withOpacity(.1), width: 2))),
      padding: const EdgeInsets.all(15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: TextField(
              autofocus: true,
              focusNode: focusNode,
              controller: textEditingController,
              onSubmitted: (s) {
                _controller.sendMessage(s);
                textEditingController.text = "";
              },
              maxLines: 6,
              minLines: 1,
              expands: false,
              cursorColor: Colors.white,
              style: const TextStyle(
                fontSize: 14,
                fontFamily: 'Arial',
                color: Colors.white,
              ),
              decoration: InputDecoration(
                hintText: 'Ask a question...',
                hintStyle: TextStyle(
                  color: Colors.white.withOpacity(.5),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
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
              _controller.sendMessage(textEditingController.text);
              textEditingController.text = "";
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
    );
  }
}
