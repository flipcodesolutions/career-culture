import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mindful_youth/app_const/app_strings.dart';
import 'package:mindful_youth/models/user_profile_upload_model/user_profile_upload_model.dart';
import 'package:mindful_youth/screens/login/sign_up/share_contact_details.dart';
import 'package:mindful_youth/screens/login/sign_up/start_your_journey.dart';
import 'package:mindful_youth/utils/shared_prefs_helper/shared_prefs_helper.dart';
import '../../app_const/app_colors.dart';
import '../../app_const/app_size.dart';
import '../../screens/login/sign_up/educational_details.dart';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';
import '../../service/upload_profile_pic_service/upload_profile_pic_service.dart';
import '../../widgets/custom_container.dart';
import '../../widgets/custom_text.dart';

class UserProvider extends ChangeNotifier {
  /// if provider is Loading
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// list of sign up process
  final List<Widget> _signUpSteps = [
    StartYourJourney(),
    ShareContactDetails(),
    EducationalDetails(),
    // FamilyDetails(),
    // ProvideAnswer(),
    // ChipSelector(),
  ];
  List<Widget> get signUpSteps => _signUpSteps;
  int _currentSignUpPageIndex = 0;
  int get currentSignUpPageIndex => _currentSignUpPageIndex;
  set setCurrentSignupPageIndex(int index) {
    _currentSignUpPageIndex = index;
    notifyListeners();
  }

  /// bool for user is logged in
  bool _isUserLoggedIn = false;
  bool get isUserLoggedIn => _isUserLoggedIn;
  set setIsUserLoggedIn(bool status) {
    _isUserLoggedIn = status;
    notifyListeners();
  }

  /// bool for user is logged in
  bool _isUserApproved = false;
  bool get isUserApproved => _isUserApproved;
  set setIsUserApproved(bool status) {
    _isUserApproved = status;
    notifyListeners();
  }

  Future<void> checkIfUserIsLoggedIn() async {
    String token = await SharedPrefs.getToken();
    if (token.trim().isNotEmpty) {
      _isUserLoggedIn = true;
    } else {
      _isUserLoggedIn = false;
    }
  }

  Future<void> checkIfUserIsApproved() async {
    String status = await SharedPrefs.getSharedString(AppStrings.userApproved);
    if (status.trim().isNotEmpty && status == "yes") {
      _isUserApproved = true;
    } else {
      _isUserApproved = false;
    }
  }

  //////// choose and upload new user pic
  bool isUpdating = false;

  final ImagePicker _picker = ImagePicker();
  Uint8List? _imageBytes;
  Uint8List? get imageBytes => _imageBytes;
  XFile? _selectedImage;
  XFile? get selectedImage => _selectedImage;

  ///
  UploadProfilePicService uploadProfileService = UploadProfilePicService();
  UserProfileUploadModel? _userProfileUploadModel;
  UserProfileUploadModel? get userProfileUploadModel => _userProfileUploadModel;
  void uploadProfilePic({required BuildContext context}) async {
    if (isUpdating) {
      /// set _isLoading true
      _isLoading = true;
      notifyListeners();
      _userProfileUploadModel = await uploadProfileService.uploadProfilePic(
        context: context,
        image: selectedImage,
      );
      if (_userProfileUploadModel?.success == true) {
        await SharedPrefs.saveString(
          AppStrings.images,
          _userProfileUploadModel?.data?.imagePath ?? "",
        );
        isUpdating = false;
        notifyListeners();
      }

      /// set _isLoading false
      _isLoading = false;
      notifyListeners();
    }
  }

  /// image init from memory
  void initImageFromMemory({required Uint8List? bytes}) {
    _imageBytes = bytes;
    notifyListeners();
  }

  void showPickerOptions(BuildContext context) {
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
                  onTap:
                      () => pickImage(
                        context: context,
                        source: ImageSource.camera,
                      ),
                ),
                _buildImageOption(
                  icon: Icons.photo_library_rounded,
                  label: AppStrings.gallery,
                  onTap:
                      () => pickImage(
                        context: context,
                        source: ImageSource.gallery,
                      ),
                ),
              ],
            ),
          ),
    );
  }

  Future<void> pickImage({
    required BuildContext context,
    required ImageSource source,
  }) async {
    Navigator.pop(context); // Close the bottom sheet
    isUpdating = true;
    notifyListeners();
    final XFile? pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 70,
    );

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();

      _imageBytes = bytes;
      notifyListeners();
    } else {
      isUpdating = false;
      notifyListeners();
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
}
