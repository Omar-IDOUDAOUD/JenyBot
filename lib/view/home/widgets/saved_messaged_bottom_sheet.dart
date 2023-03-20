import 'package:chatgpt_flutter_app/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SavedMessagesBottomSheet extends StatefulWidget {
  const SavedMessagesBottomSheet({Key? key}) : super(key: key);

  @override
  State<SavedMessagesBottomSheet> createState() =>
      _SavedMessagesBottomSheetState();
}

class _SavedMessagesBottomSheetState extends State<SavedMessagesBottomSheet> {
  late List<Map> _messages;
  final HomeController _controller = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    super.initState(); 
    _messages = _controller.getSavedMessages();
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, right: 25, left: 25),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Saved Messages',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.only(bottom: 25),
                shrinkWrap: true,
                itemCount: _messages.length,
                separatorBuilder: (_, i) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Divider(
                      color: Colors.white.withOpacity(.5),
                      height: 1,
                    ),
                  );
                },
                itemBuilder: (_, i) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _messages[i]['owner']!,
                        style: TextStyle(
                          color: Colors.white.withOpacity(.5),
                          fontSize: 10,
                        ),
                      ),
                      Text(
                        _messages[i]['message']!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
