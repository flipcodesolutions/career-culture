import 'package:flutter/material.dart';
import 'package:mindful_youth/app_const/app_colors.dart';
import 'package:mindful_youth/utils/border_helper/border_helper.dart';
import 'package:mindful_youth/utils/text_style_helper/text_style_helper.dart';
import 'package:mindful_youth/widgets/custom_text.dart';
import 'package:sizer/sizer.dart';

class CustomDropDownWidget<T> extends StatefulWidget {
  const CustomDropDownWidget({
    super.key,
    this.label,
    this.hintText,
    this.width,
    required this.dropdownMenuEntries,
    this.onSelected,
    this.enabled = true,
    this.initialSelection,
  });
  final String? label;
  final String? hintText;
  final double? width;
  final List<DropdownMenuEntry<T>> dropdownMenuEntries;
  final void Function(T?)? onSelected;
  final bool enabled;
  final T? initialSelection;
  @override
  State<CustomDropDownWidget> createState() => _CustomDropDownWidgetState();
}

class _CustomDropDownWidgetState<T> extends State<CustomDropDownWidget<T>> {
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
        DropdownMenu<T>(
          initialSelection: widget.initialSelection,
          width: widget.width ?? 90.w,
          hintText: widget.hintText,
          inputDecorationTheme: InputDecorationTheme(
            border: BorderHelper.inputBorder,
            errorBorder: BorderHelper.inputBorderError,
            focusedBorder: BorderHelper.inputBorderFocused,
            disabledBorder: BorderHelper.inputBorderDisabled,
          ),
          dropdownMenuEntries: widget.dropdownMenuEntries,
          onSelected: widget.onSelected,
          enabled: widget.enabled,
          menuHeight: 40.h,
        ),
      ],
    );
  }
}
