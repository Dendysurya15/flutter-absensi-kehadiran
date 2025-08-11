import 'package:get/get.dart';

import '../controllers/absence_controller.dart';

class AbsenceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AbsenceController>(
      () => AbsenceController(),
    );
  }
}
