import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chatgpt_flutter_app/controller/home_controller.dart';
import 'package:chatgpt_flutter_app/core/constants/colors.dart';
import 'package:chatgpt_flutter_app/model/message_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class GptMessageRawWidget extends StatefulWidget {
  const GptMessageRawWidget(
      {Key? key,
      required this.data,
      this.withPopupAnimation = false,
      required this.onEdit,
      required this.onSave})
      : super(key: key);
  final Future<MessageModel> data;
  final bool withPopupAnimation;
  final Function(String text) onEdit;
  final Function(String text) onSave;
  @override
  State<GptMessageRawWidget> createState() => _GptMessageRawWidgetState();
}

class _GptMessageRawWidgetState extends State<GptMessageRawWidget> {
  String? _text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TweenAnimationBuilder(
          tween: Tween<double>(begin: 1, end: 0),
          curve: Curves.linearToEaseOut,
          duration:
              widget.withPopupAnimation ? 600.milliseconds : 0.milliseconds,
          builder: (_, double a, c) {
            return Transform.translate(
              offset: Offset(-a * 80, 0),
              child: c,
            );
          },
          child: GestureDetector(
            key: _menuIconKey,
            onTap: _openMenu,
            child: ColoredBox(
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 15),
                child: SvgPicture.asset('assets/menu-icon.svg', width: 10),
              ),
            ),
          ),
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
                alignment: Alignment.topRight,
                child: c,
              );
            },
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                decoration: BoxDecoration(
                  color: ColorsConstant.d,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(6),
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                ),
                padding: const EdgeInsets.only(
                    top: 7, right: 11, left: 15, bottom: 9),
                child: FutureBuilder<MessageModel>(
                  future: widget.data,
                  builder: (_, snapshot) {
                    if (!snapshot.hasData)
                      return CupertinoActivityIndicator(
                          color: Colors.white.withOpacity(.7));
                    // else if (!snapshot.hasData && snapshot.connectionState == ConnectionState.done) return SizedBox.shrink();
                    _text = snapshot.data!.content;
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
                            textStyle: TextStyle(
                              fontSize: 14,
                              color: snapshot.data!.error
                                  ? Colors.red
                                  : Colors.white,
                            ),
                          ),
                        ],
                      );
                    }
                    return Text(
                      snapshot.data!.content,
                      style: TextStyle(
                        fontSize: 14,
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
          width: 5,
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
            height: 25,
            width: 25,
            decoration: BoxDecoration(
              color: ColorsConstant.d,
              borderRadius: BorderRadius.circular(6),
            ),
            child: SvgPicture.asset('assets/chatgpt_icon.svg'),
          ),
        ),
      ],
    );
  }

  final GlobalKey _menuIconKey = GlobalKey();
  OverlayEntry? _menuOverlayEntry;

  void _openMenu() {
    RenderBox renderBox =
        _menuIconKey.currentContext!.findRenderObject() as RenderBox;
    Offset offset = renderBox.localToGlobal(Offset.zero);

    _menuOverlayEntry = OverlayEntry(
      builder: (_) {
        return GestureDetector(
          onTap: _closeMenu,
          child: ColoredBox(
            color: Colors.transparent,
            child: Stack(
              children: [
                Positioned(
                  top: offset.dy,
                  left: offset.dx,
                  child: Container(
                    width: 100,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(0, 10),
                          color: Colors.black54.withOpacity(.3),
                          blurRadius: 20,
                        )
                      ],
                      borderRadius: BorderRadius.circular(10),
                      color: ColorsConstant.f,
                    ),
                    padding: const EdgeInsets.all(5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _getMenuItem('Edit', 'assets/edit-icon.svg', () {
                          widget.onEdit(_text ?? '<empthy>');
                        }),
                        _getMenuItem('Copy', 'assets/copy.svg', () {
                          if (_text != null)
                            Clipboard.setData(ClipboardData(text: _text));
                        }),
                        _getMenuItem('Save', 'assets/save.svg', () {
                          if (_text != null) widget.onSave(_text!);
                        }),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
    Overlay.of(context)!.insert(_menuOverlayEntry!);
  }

  void _closeMenu() {
    _menuOverlayEntry!.remove();
  }

  Widget _getMenuItem(String text, String icon, Function() onTap) {
    return ElevatedButton(
      onPressed: () {
        _closeMenu();
        onTap();
      },
      style: ButtonStyle(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,

        shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
        padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 8)),
        elevation: MaterialStateProperty.all(0),
        backgroundColor: MaterialStateProperty.all(Colors.transparent),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SvgPicture.asset(
            icon,
            color: Colors.white,
            height: 12,
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
