

import 'package:get/get.dart';

class FilterController extends GetxController {
  var distanceValue = 0.0.obs;
  var minAge = 18.0.obs;
  var maxAge = 30.0.obs;
  var genderIndex = (-1).obs;
  var interestIndex = (-1).obs;

  void resetFilters() {
    distanceValue.value = 0.0;
    minAge.value = 18.0;
    maxAge.value = 30.0;
    genderIndex.value = -1;
    interestIndex.value = -1;
  }
}
