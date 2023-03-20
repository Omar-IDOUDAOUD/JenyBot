import 'package:chatgpt_flutter_app/controller/home_controller.dart';
import 'package:chatgpt_flutter_app/core/constants/api_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ModelSelectionBottomSheet extends StatefulWidget {
  const ModelSelectionBottomSheet({Key? key}) : super(key: key);

  @override
  State<ModelSelectionBottomSheet> createState() =>
      _ModelSelectionBottomSheetState();
}

class _ModelSelectionBottomSheetState extends State<ModelSelectionBottomSheet> {
  final HomeController _controller = Get.find();
 
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, right: 15, left: 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Select Model',
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
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 15),
              shrinkWrap: true,
              itemCount: ApiConstants.GPT_MODELS_URLS.length,
              itemBuilder: (_, i) {
                final modelName =
                    ApiConstants.GPT_MODELS_URLS.elementAt(i)['model'];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _controller.gptSelectedModelName =
                          ApiConstants.GPT_MODELS_URLS.elementAt(i)['model'];
                    });
                    Get.back();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                      color: _controller.gptSelectedModelName == modelName
                          ? Colors.white.withOpacity(.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Text(
                          modelName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                        const Spacer(),
                        if (_controller.gptSelectedModelName == modelName)
                          const Icon(
                            Icons.check_rounded,
                            color: Colors.white,
                            size: 15,
                          )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
