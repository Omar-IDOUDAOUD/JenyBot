import 'package:chatgpt_flutter_app/controller/home_controller.dart';
import 'package:chatgpt_flutter_app/services/api_services.dart';
import 'package:get/get.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<ApiService>(ApiService());
    Get.put<HomeController>(HomeController());
  }
}
