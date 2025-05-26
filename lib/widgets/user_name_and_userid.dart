import 'package:flutter/material.dart';
import 'package:mindful_youth/utils/shared_prefs_helper/shared_prefs_helper.dart';
import 'package:mindful_youth/widgets/custom_text.dart';
import 'package:mindful_youth/widgets/cutom_loader.dart';
import '../app_const/app_strings.dart';

class UserNameAndUIdRow extends StatefulWidget {
  const UserNameAndUIdRow({super.key});

  @override
  State<UserNameAndUIdRow> createState() => _UserNameAndUIdRowState();
}

class _UserNameAndUIdRowState extends State<UserNameAndUIdRow> {
  String? userName;
  String? userId;
  bool isLoading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNameAndId();
  }

  void getNameAndId() async {
    userId = await SharedPrefs.getSharedString(AppStrings.userId);
    userName = await SharedPrefs.getSharedString(AppStrings.userName);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CustomLoader())
        : Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 3,
              child: CustomText(text: "${AppStrings.hello} , $userName"),
            ),
            Spacer(),
            Expanded(child: CustomText(text: "${AppStrings.uId} : $userId")),
          ],
        );
  }
}
