import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

enum ImagePickerStatus { initial, uploading, error }

class ImagePickerState extends Equatable {
  final XFile? pickedImage;
  final String imagePath;
  final String? currentImageUrl;
  final String? errorMessage;
  final ImagePickerStatus currentStatus;

  const ImagePickerState({
    this.currentImageUrl = '',
    this.imagePath = '',
    this.currentStatus = ImagePickerStatus.initial,
    this.pickedImage,
    this.errorMessage = '',
  });

  ImagePickerState copyWith({
    XFile? pickedImage,
    String? imagePath,
    String? currentImageUrl,
    String? errorMessage,
    ImagePickerStatus? currentStatus,
  }) {
    return ImagePickerState(
      pickedImage: pickedImage ?? this.pickedImage,
      imagePath: imagePath ?? this.imagePath,
      currentImageUrl: currentImageUrl ?? this.currentImageUrl,
      errorMessage: errorMessage,
      currentStatus: currentStatus ?? this.currentStatus,
    );
  }

  @override
  List<Object?> get props => [
        pickedImage,
        imagePath,
        currentImageUrl,
        errorMessage,
        currentStatus,
      ];
}
