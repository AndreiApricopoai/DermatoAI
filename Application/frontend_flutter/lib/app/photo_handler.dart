import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend_flutter/api/models/requests/prediction_requests/create_prediction_request.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class PhotoHandler {
  final ImagePicker _picker = ImagePicker();

  Future<CreatePredictionRequest?> pickImage(BuildContext context) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return null;
    final processedImage = await _processImage(File(image.path));
    return CreatePredictionRequest(image: processedImage);
  }

  Future<CreatePredictionRequest?> takePhoto(BuildContext context) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image == null) return null;
    final processedImage = await _processImage(File(image.path));
    return CreatePredictionRequest(image: processedImage);
  }

  Future<File> _processImage(File file) async {
    final img.Image originalImage = img.decodeImage(file.readAsBytesSync())!;
    
    if (originalImage.width == 600 && originalImage.height == 450) {
      // If the image is already 600x450, return the original file
      return file;
    }

    final img.Image rotatedImage = _rotateImageIfNeeded(originalImage);
    final img.Image resizedImage = _resizeImage(rotatedImage);

    final Directory directory = await getApplicationDocumentsDirectory();
    final String targetPath = path.join(directory.path, "${DateTime.now().millisecondsSinceEpoch}.jpg");
    final File resizedFile = File(targetPath)..writeAsBytesSync(img.encodeJpg(resizedImage, quality: 100));

    return resizedFile;
  }

  img.Image _rotateImageIfNeeded(img.Image image) {
    if (image.width < image.height) {
      return img.copyRotate(image, angle: 90);
    }
    return image;
  }

  img.Image _resizeImage(img.Image image) {
    // Calculate aspect ratio
    double aspectRatio = image.width / image.height;

    // Calculate new dimensions to fit within 600x450 while maintaining aspect ratio
    int targetWidth = 600;
    int targetHeight = (600 / aspectRatio).round();

    if (targetHeight > 450) {
      targetHeight = 450;
      targetWidth = (450 * aspectRatio).round();
    }

    return img.copyResize(image, width: targetWidth, height: targetHeight, interpolation: img.Interpolation.cubic);
  }
}
