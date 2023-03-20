import 'package:chatgpt_flutter_app/core/constants/colors.dart';
import 'package:chatgpt_flutter_app/model/message_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class UserMessageRawWidget extends StatefulWidget {
  const UserMessageRawWidget(
      {Key? key,
      required this.data,
      this.withPopupAnimation = false,
      required this.onEdit,
      required this.onSave})
      : super(key: key);
  final MessageModel data;
  final bool withPopupAnimation;
  final Function(String text) onEdit;
  final Function(String text) onSave;
  @override
  State<UserMessageRawWidget> createState() => _UserMessageRawWidgetState();
}

class _UserMessageRawWidgetState extends State<UserMessageRawWidget> {
 

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
            height: 25,
            width: 25,
            decoration: BoxDecoration(
              color: ColorsConstant.c.withOpacity(.8),
              borderRadius: BorderRadius.circular(6),
            ),
            child: SvgPicture.asset('assets/user-icon.svg'),
          ),
        ),
        const SizedBox(
          width: 5,
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
                decoration: BoxDecoration(
                  color: ColorsConstant.c,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(6),
                    topRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                ),
                padding: const EdgeInsets.only(
                    top: 7, right: 15, left: 11, bottom: 9),
                child: Text(
                  widget.data.content,
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: 'Inter',
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
        TweenAnimationBuilder(
          tween: Tween<double>(begin: 1, end: 0),
          curve: Curves.linearToEaseOut,
          duration:
              widget.withPopupAnimation ? 600.milliseconds : 0.milliseconds,
          builder: (_, double a, c) {
            return Transform.translate(
              offset: Offset(a * 80, 0),
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
                  right: Get.size.width - offset.dx,
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                     
                        _getMenuItem('Edit', 'assets/edit-icon.svg', () {
                          widget.onEdit(widget.data.content);
                        }),
                        _getMenuItem('Copy', 'assets/copy.svg', () {
                          Clipboard.setData(
                              ClipboardData(text: widget.data.content));
                        }),
                        _getMenuItem('Save', 'assets/save.svg', () {
                          widget.onSave(widget.data.content);
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
        // textStyle: MaterialStateProperty.all(TextStyle(

        // ))
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
