import 'package:get/get.dart';
class HomeController1 extends GetxController {
  final currentNavIndex = RxInt(0); // Box for the current navigation index

  void changeNavIndex(int index) {
    currentNavIndex.value = index;
  }
}