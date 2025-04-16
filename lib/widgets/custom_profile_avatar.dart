import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';
import '../app_const/app_colors.dart';
import '../app_const/app_size.dart';
import '../app_const/app_strings.dart';
import 'custom_container.dart';
import 'custom_image.dart';
import 'custom_text.dart';

class CustomProfileAvatar extends StatefulWidget {
  final Uint8List? initialBytes;
  final void Function(Uint8List bytes)? onImagePicked;

  const CustomProfileAvatar({super.key, this.initialBytes, this.onImagePicked});

  @override
  State<CustomProfileAvatar> createState() => _CustomProfileAvatarState();
}

class _CustomProfileAvatarState extends State<CustomProfileAvatar> {
  final ImagePicker _picker = ImagePicker();
  Uint8List? _imageBytes;

  @override
  void initState() {
    super.initState();
    _imageBytes = widget.initialBytes;
  }

  void _showPickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSize.size20),
        ),
      ),
      enableDrag: true,
      showDragHandle: true,
      useSafeArea: true,
      constraints: BoxConstraints(minHeight: AppSize.size10, maxHeight: 25.h),
      builder:
          (_) => Padding(
            padding: EdgeInsets.all(AppSize.size20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildImageOption(
                  icon: Icons.camera_alt_rounded,
                  label: AppStrings.camera,
                  onTap: () => _pickImage(ImageSource.camera),
                ),
                _buildImageOption(
                  icon: Icons.photo_library_rounded,
                  label: AppStrings.gallery,
                  onTap: () => _pickImage(ImageSource.gallery),
                ),
              ],
            ),
          ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    Navigator.pop(context); // Close the bottom sheet
    final XFile? pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 70,
    );

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _imageBytes = bytes;
      });
      if (widget.onImagePicked != null) {
        widget.onImagePicked!(bytes);
      }
    } else {
      print("No image selected");
    }
  }

  Widget _buildImageOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomContainer(
            width: AppSize.size60,
            height: AppSize.size60,
            shape: BoxShape.circle,
            backGroundColor: AppColors.grey.withOpacity(0.2),
            child: Icon(icon, size: 28, color: AppColors.secondary),
          ),
          SizedBox(height: AppSize.size10),
          CustomText(text: label),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      height: 20.h,
      width: 100.w,
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            CustomContainer(
              width: AppSize.size100 + AppSize.size50,
              height: AppSize.size100 + AppSize.size50,
              shape: BoxShape.circle,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppSize.size100),
                child:
                    _imageBytes != null
                        ? GestureDetector(
                          onTap:
                              () => showDialog(
                                context: context,
                                builder:
                                    (context) => Dialog(
                                      child: InteractiveViewer(
                                        child: Image.memory(_imageBytes!),
                                      ),
                                    ),
                              ),
                          child: Image.memory(_imageBytes!, fit: BoxFit.cover),
                        )
                        : CustomImageWithLoader(
                          fit: BoxFit.cover,
                          imageUrl:
                              "https://img.freepik.com/free-vector/user-circles-set_78370-4704.jpg?t=st=1744778069~exp=1744781669~hmac=a88a2dbd6225ce1f2caf1382b814e2cf2f547172d909e75a5e8bc978d5d8ff03&w=826",
                        ),
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () => _showPickerOptions(context),
                  child: CustomContainer(
                    width: AppSize.size40,
                    height: AppSize.size40,
                    shape: BoxShape.circle,
                    backGroundColor: AppColors.white,
                    child: Icon(
                      Icons.camera_alt,
                      size: 20,
                      color: AppColors.secondary,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
