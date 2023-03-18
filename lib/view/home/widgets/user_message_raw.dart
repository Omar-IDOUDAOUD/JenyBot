import 'package:chatgpt_flutter_app/core/constants/colors.dart';
import 'package:chatgpt_flutter_app/model/message_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class UserMessageRawWidget extends StatefulWidget {
  const UserMessageRawWidget(
      {Key? key, required this.data, this.withPopupAnimation = false})
      : super(key: key);
  final MessageModel data;
  final bool withPopupAnimation;
  @override
  State<UserMessageRawWidget> createState() => _UserMessageRawWidgetState();
}

class _UserMessageRawWidgetState extends State<UserMessageRawWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TweenAnimationBuilder(
          tween: Tween<double>(begin: 0, end: 1),
          curve: Curves.elasticOut,
          duration:
              widget.withPopupAnimation ? 600.milliseconds : 0.milliseconds,
          builder: (_, double a, c) {
            return Transform.scale(
              scale: a,
              alignment: Alignment.topRight,
              child: c,
            );
          },
          child: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: ColorsConstant.b,
              borderRadius: BorderRadius.circular(4),
            ),
            child: SvgPicture.asset('assets/user-icon.svg'),
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        Expanded(
          child: TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: 1),
            curve: Curves.elasticOut,
            duration:
                widget.withPopupAnimation ? 600.milliseconds : 0.milliseconds,
            builder: (_, double a, c) {
              return Transform.scale(
                scale: a,
                alignment: Alignment.topLeft,
                child: c,
              );
            },
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                constraints: const BoxConstraints(
                  minHeight: 40,
                ),
                decoration: BoxDecoration(
                  color: ColorsConstant.c,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                child: Text(
                  widget.data.content as String,
                  style: const TextStyle(
                    fontSize: 12,
                    fontFamily: 'Arial',
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
