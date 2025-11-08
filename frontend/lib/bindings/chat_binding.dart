import 'package:frontend/controllers/mongo_controller.dart';
import 'package:get/get.dart';
import '../controllers/chat_controller.dart';

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ChatController());
    Get.put(MongoController());
  }
}
