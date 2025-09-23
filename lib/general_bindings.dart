import 'package:get/get.dart';

import 'features/home/HomeController.dart';

class GeneralBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(HomeController(), permanent: true);
  }
}
