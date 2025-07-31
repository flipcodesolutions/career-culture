import 'package:flutter/material.dart';
import 'package:mindful_youth/app_const/app_colors.dart';
import 'package:mindful_youth/app_const/app_size.dart';
import 'package:mindful_youth/screens/login/sign_up/sign_up.dart';
import 'package:mindful_youth/utils/method_helpers/method_helper.dart';
import 'package:mindful_youth/utils/method_helpers/size_helper.dart';
import 'package:mindful_youth/utils/navigation_helper/navigation_helper.dart';
import 'package:mindful_youth/utils/text_style_helper/text_style_helper.dart';
import 'package:mindful_youth/widgets/custom_container.dart';
import 'package:mindful_youth/widgets/cutom_loader.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../provider/user_provider/sign_up_provider.dart';
import '../../provider/user_provider/user_provider.dart';
import '../../widgets/custom_profile_avatar.dart';
import '../../widgets/custom_text.dart';

class ProfileViewPage extends StatelessWidget with NavigateHelper {
  const ProfileViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final SignUpProvider signUpProvider = context.watch<SignUpProvider>();

    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: "My Profile",
          style: TextStyleHelper.mediumHeading,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: AppColors.primary),
            onPressed: () {
              context.read<UserProvider>().setCurrentSignupPageIndex = 0;
              context.read<SignUpProvider>().setIsUpdatingProfile = true;
              push(
                context: context,
                widget: SignUpScreen(),
                transition: OpenUpwardsPageTransitionsBuilder(),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: signUpProvider.buildUserMap(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              final Map<String, dynamic> profileData = snapshot.data ?? {};
              return ListView(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                children: [
                  Hero(tag: "profile", child: CustomProfileAvatar()),
                  const SizedBox(height: 24),
                  _buildSection("Personal Info", [
                    _buildField("First Name", profileData['firstName']),
                    _buildField("Middle Name", profileData['middleName']),
                    _buildField("Last Name", profileData['lastName']),
                    _buildField("Birthdate", profileData['birthdate']),
                    _buildField("Gender", profileData['gender']),
                  ]),
                  _buildSection("Contact", [
                    _buildField("Email", profileData['email']),
                    _buildField("Contact 1", profileData['contact1']),
                    if (profileData['contact2'] != null)
                      _buildField("Contact 2", profileData['contact2']),
                  ]),
                  _buildSection("Address", [
                    _buildField("Address Line 1", profileData['address1']),
                    if (profileData['address2'] != null)
                      _buildField("Address Line 2", profileData['address2']),
                    _buildField("City", profileData['city']),
                    _buildField("District", profileData['district']),
                    _buildField("State", profileData['state']),
                  ]),
                  _buildSection("Education / Work", [
                    _buildField("Degree / Study", profileData['currentStudy']),
                    _buildField("Skill", profileData['degree']),
                    _buildField("College", profileData['college']),
                    if (profileData['company'] != null)
                      _buildField("Company", profileData['company']),
                  ]),
                ],
              );
            }
            return Center(child: CustomLoader());
          },
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> fields) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizeHelper.height(),
        CustomText(text: title, style: TextStyleHelper.mediumHeading),
        SizeHelper.height(height: 1.h),
        CustomContainer(
          backGroundColor: AppColors.lightWhite,
          padding: const EdgeInsets.all(AppSize.size10),
          borderRadius: BorderRadius.circular(AppSize.size10),
          borderColor: AppColors.grey,
          borderWidth: 0.3,
          child: Column(children: fields),
        ),
      ],
    );
  }

  Widget _buildField(String label, String? value) {
    if (value == null || value.trim().isEmpty) return const SizedBox();
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomContainer(
            width: 35.w,
            child: CustomText(
              text: "$label:",
              style: TextStyleHelper.smallHeading,
            ),
          ),
          Expanded(child: CustomText(text: value, useOverflow: false)),
        ],
      ),
    );
  }
}
