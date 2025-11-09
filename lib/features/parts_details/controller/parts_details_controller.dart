import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class PartsDetailsController extends GetxController {
  final partName = ''.obs;
  final category = ''.obs;
  final compatibleVehicles = ''.obs;
  final condition = ''.obs;
  final brand = ''.obs;
  final partNumber = ''.obs;
  final price = ''.obs;
  final quantity = ''.obs;
  final description = ''.obs;
  final warrantyInfo = ''.obs;
  final deliveryOption = ''.obs;
  final sellerName = ''.obs;
  final location = ''.obs;
  final contactNumber = ''.obs;
  final isConfirmed = false.obs;
  final selectedImage = Rxn<XFile>();
  final picker = ImagePicker();

  Future<void> pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) selectedImage.value = picked;
  }
}
