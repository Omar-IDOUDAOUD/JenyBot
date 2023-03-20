import 'package:chatgpt_flutter_app/controller/home_controller.dart';
import 'package:chatgpt_flutter_app/core/constants/colors.dart';
import 'package:chatgpt_flutter_app/view/home/widgets/saved_messaged_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class CostumeDrawer extends StatefulWidget {
  const CostumeDrawer({Key? key}) : super(key: key);

  @override
  State<CostumeDrawer> createState() => _CostumeDrawerState();
}

class _CostumeDrawerState extends State<CostumeDrawer> {
  final HomeController _controller = Get.find();
  late TextEditingController _apiKeyTextEditingController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    

    _apiKeyTextEditingController = TextEditingController();
    _apiKeyTextEditingController.text = _controller.apiKey;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _apiKeyTextEditingController.dispose();
     
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.size.width * 0.7,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            offset: const Offset(10, 0),
            color: Colors.black54.withOpacity(.3),
            blurRadius: 50,
          )
        ],
        color: ColorsConstant.e,
        borderRadius: const BorderRadius.horizontal(
          right: Radius.circular(35),
        ),
      ),
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: Get.back,
            child: SvgPicture.asset(
              'assets/drawer-back-icon.svg',
              height: 14,
            ),
          ),
          const SizedBox(height: 25),
          const Text(
            'Flutter Chat-Bot System App Provided By OPEN AI\'s API',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Divider(
            color: Colors.white,
            height: 1,
            thickness: 0.1,
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            'SETTINGS',
            style: TextStyle(
              color: Colors.white.withOpacity(.3),
              fontSize: 10,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              SvgPicture.asset('assets/theme-icon.svg'),
              const SizedBox(
                width: 10,
              ),
              const Text(
                'Dark Theme',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontFamily: 'Inter',
                ),
              ),
              const Spacer(),
              Transform.scale(
                alignment: Alignment.centerRight,
                scale: 0.6,
                child: CupertinoSwitch(
                  value: true,
                  activeColor: ColorsConstant.h,
                  onChanged: (v) {},
                ),
              ),
            ],
          ),
          Row(
            children: [
              SvgPicture.asset('assets/api-key-icon.svg'),
              const SizedBox(
                width: 10,
              ),
              const Text(
                'Api Key',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontFamily: 'Inter',
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  _controller.apiKey = _apiKeyTextEditingController.text;
                },
                style: ButtonStyle(
                  elevation: MaterialStateProperty.all(0),
                  backgroundColor: MaterialStateProperty.all(
                      ColorsConstant.g.withOpacity(.1)),
                ),
                child: Text(
                  'Save',
                  style: TextStyle(
                    fontSize: 12,
                    color: ColorsConstant.g,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            controller: _apiKeyTextEditingController,
            maxLines: 5,
            minLines: 1,
            expands: false,
            cursorColor: Colors.white,
            style: const TextStyle(
              fontSize: 12,
              fontFamily: 'Arial',
              color: Colors.white,
            ),
            decoration: InputDecoration(
              hintText: 'Set a key token...',
              hintStyle: TextStyle(
                color: Colors.white.withOpacity(.5),
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
              contentPadding: const EdgeInsets.all(12),
              isCollapsed: true,
              filled: true,
              fillColor: Colors.white.withOpacity(.2),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            'SAVED MESSAGES',
            style: TextStyle(
              color: Colors.white.withOpacity(.3),
              fontSize: 10,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {
              Get.bottomSheet(
                const SavedMessagesBottomSheet(),
                backgroundColor: ColorsConstant.e,
                elevation: 20,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(30),
                  ),
                ),
              );
            },
            style: ButtonStyle(
              padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(horizontal: 8)),
              elevation: MaterialStateProperty.all(0),
              backgroundColor:
                  MaterialStateProperty.all(ColorsConstant.j.withOpacity(.1)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  'assets/save.svg',
                  color: ColorsConstant.j,
                  height: 12,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  'Show Saved Messages',
                  style: TextStyle(
                    fontSize: 12,
                    color: ColorsConstant.j,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
