import 'package:get/get.dart';

class BaseController<T> extends GetxController {
  T get repository => Get.find<T>();
}
