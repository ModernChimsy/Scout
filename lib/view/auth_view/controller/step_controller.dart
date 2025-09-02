import 'package:get/get.dart';

class StepController extends GetxController {
  RxInt currentStep = 1.obs;

  void nextStep() {
    if (currentStep.value < 3) {
      currentStep.value++;
    }
  }

  void previousStep() {
    if (currentStep.value > 1) {
      currentStep.value--;
    }
  }
}
