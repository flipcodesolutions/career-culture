import 'package:flutter/material.dart';
import 'package:mindful_youth/app_const/app_colors.dart';
import 'package:mindful_youth/utils/border_helper/border_helper.dart';
import 'package:mindful_youth/utils/text_style_helper/text_style_helper.dart';
import 'package:mindful_youth/widgets/custom_text.dart';
import 'package:sizer/sizer.dart';

class CustomDropDownWidget extends StatefulWidget {
  const CustomDropDownWidget({
    super.key,
    this.label,
    this.hintText,
    this.width,
  });
  final String? label;
  final String? hintText;
  final double? width;
  @override
  State<CustomDropDownWidget> createState() => _CustomDropDownWidgetState();
}

class _CustomDropDownWidgetState extends State<CustomDropDownWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label?.isNotEmpty == true)
          CustomText(
            text: widget.label ?? "",
            style: TextStyleHelper.smallHeading.copyWith(
              color: AppColors.primary,
            ),
          ),
        DropdownMenu(
          width: widget.width ?? 90.w,
          hintText: widget.hintText,
          inputDecorationTheme: InputDecorationTheme(
            border: BorderHelper.inputBorder,
            errorBorder: BorderHelper.inputBorderError,
            focusedBorder: BorderHelper.inputBorderFocused,
            disabledBorder: BorderHelper.inputBorderDisabled,
          ),
          dropdownMenuEntries: [DropdownMenuEntry(value: "", label: "HI")],
        ),
      ],
    );
  }
}
