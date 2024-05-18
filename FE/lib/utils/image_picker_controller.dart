import 'package:image_picker/image_picker.dart';

class ImagePickerController {
  final ImagePicker _picker = ImagePicker();
  static final ImagePickerController _instance =
      ImagePickerController._internal();

  factory ImagePickerController(){
    return _instance;
  }

  ImagePickerController._internal();

  Future<XFile?> getImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    return image;
  }
}