import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerHelper {
  // File? _image;
  static final ImagePicker _picker = ImagePicker();

  static Future<void> _pickImage(
    ImageSource source,
    Function(File?) onImagePicked,
  ) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      onImagePicked(File(pickedFile.path));
    }
  }

  static void showImagePicker(
    BuildContext context,
    Function(File?) onImagePicked,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext ctx) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  _pickImage(ImageSource.gallery, onImagePicked);
                  Navigator.of(ctx).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () {
                  _pickImage(ImageSource.camera, onImagePicked);
                  Navigator.of(ctx).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
  /// get converted the selected file to save it in platform file var list
  static Future<PlatformFile> convertFileToPlatformFile(File file) async {
    final Uint8List bytes = await file.readAsBytes();
    final String name = file.path.split('/').last;
    final int size = bytes.length;

    return PlatformFile(name: name, size: size, bytes: bytes, path: file.path);
  }
}
