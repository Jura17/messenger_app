import 'dart:io';

import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:messenger_app/features/settings/cubits/image_picker_state.dart';

import 'package:messenger_app/features/users/data/repositories/userdata_repository.dart';
import 'package:path_provider/path_provider.dart';

class ImagePickerCubit extends Cubit<ImagePickerState> {
  final UserdataRepository _userdataRepository;
  ImagePickerCubit({required UserdataRepository userdataRepo})
      : _userdataRepository = userdataRepo,
        super(const ImagePickerState());

  Future<void> pickImage() async {
    try {
      final ImagePicker imagePicker = ImagePicker();
      final XFile? pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        final imagePath = (await saveImagePermanently(pickedImage)).path;
        debugPrint("from cubit, pickedImage not null: ${pickedImage}");
        emit(state.copyWith(pickedImage: pickedImage, imagePath: imagePath));
      }
    } catch (e) {
      emit(state.copyWith(currentStatus: ImagePickerStatus.error));
      if (e is PlatformException) {
        debugPrint("Show permission dialog");
      }
    }
  }

  Future<File> saveImagePermanently(XFile imageFile) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = imageFile.name; // Keep original name
    final imagePath = File('${directory.path}/$name');
    return File(imageFile.path).copy(imagePath.path);
  }
}
