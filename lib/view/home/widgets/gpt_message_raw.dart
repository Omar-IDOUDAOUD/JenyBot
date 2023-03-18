import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chatgpt_flutter_app/controller/home_controller.dart';
import 'package:chatgpt_flutter_app/core/constants/colors.dart';
import 'package:chatgpt_flutter_app/model/message_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class GptMessageRawWidget extends StatefulWidget {
  const GptMessageRawWidget(
      {Key? key, required this.data, this.withPopupAnimation = false})
      : super(key: key);
  final Future<MessageModel> data;
  final bool withPopupAnimation;
  @override
  State<GptMessageRawWidget> createState() => _GptMessageRawWidgetState();
}

class _GptMessageRawWidgetState extends State<GptMessageRawWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: TweenAnimationBuilder(
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
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                constraints: const BoxConstraints(
                  minHeight: 40,
                ),
                decoration: BoxDecoration(
                  color: ColorsConstant.d,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(5),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                child: FutureBuilder<MessageModel>(
                  future: widget.data,
                  builder: (_, snapshot) { 
                    if (!snapshot.hasData ) return CircularProgressIndicator();
                    // else if (!snapshot.hasData && snapshot.connectionState == ConnectionState.done) return SizedBox.shrink(); 

                    if (widget.withPopupAnimation) {
                      final HomeController _c = Get.find();
                      _c.startScrollingDown(100.milliseconds);
                      return AnimatedTextKit(
                        displayFullTextOnTap: true,
                        totalRepeatCount: 1,
                        onFinished: () {
                          _c.stopScrollingDown();
                        },
                        onTap: () {
                          _c.stopScrollingDown();
                        },
                        animatedTexts: [
                          TyperAnimatedText(
                            snapshot.data!.content,
                            speed: 15.milliseconds,
                            textStyle:   TextStyle(
                              fontSize: 12,
                              fontFamily: 'Arial',
                              color:snapshot.data!.error ? Colors.red : Colors.white,
                            ),
                          ),
                        ],
                      );
                    }
                    return Text(
                      snapshot.data!.content,
                      style:   TextStyle(
                        fontSize: 12,
                        fontFamily: 'Arial',
                        color: snapshot.data!.error ? Colors.red : Colors.white,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        TweenAnimationBuilder(
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
          child: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: ColorsConstant.b,
              borderRadius: BorderRadius.circular(4),
            ),
            child: SvgPicture.asset('assets/chatgpt_icon.svg'),
          ),
        ),
      ],
    );
  }
}
