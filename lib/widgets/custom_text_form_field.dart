import 'package:flutter/material.dart';
import '../app_const/app_colors.dart';
import '../utils/border_helper/border_helper.dart'; // For keyboard input types

// Custom Text Form Field widget
class CustomTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool autocorrect;
  final Color? cursorColor;
  final TextInputType? keyboardType;
  final bool obscureText;
  final int? maxLength;
  final int? maxLines;
  final int? minLines;
  final bool readOnly;
  final TextStyle? style;
  final TextAlign textAlign;
  final String? Function(String?)? validator;
  final String? labelText;
  final String? hintText;
  final InputDecoration? decoration;
  final bool enabled;
  final void Function(String)? onChanged;
  final Widget? suffix;
  final List<Widget>? adaptiveTextSelectionToolbarChildren;
  const CustomTextFormField({
    super.key,
    required this.controller,
    this.focusNode,
    this.autocorrect = true,
    this.cursorColor,
    this.keyboardType,
    this.obscureText = false,
    this.maxLength,
    this.maxLines = 1,
    this.minLines = 1,
    this.readOnly = false,
    this.style,
    this.textAlign = TextAlign.start,
    required this.validator,
    this.decoration,
    this.enabled = true,
    this.hintText,
    this.labelText,
    this.onChanged,
    this.suffix,
    this.adaptiveTextSelectionToolbarChildren,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autocorrect: autocorrect,
      controller: controller,
      contextMenuBuilder: (context, editableTextState) {
        return AdaptiveTextSelectionToolbar(
          anchors: editableTextState.contextMenuAnchors,
          children: adaptiveTextSelectionToolbarChildren,
        );
      },
      buildCounter:
          (
            context, {
            required currentLength,
            required isFocused,
            required maxLength,
          }) => null,
      cursorColor: AppColors.primary,
      cursorErrorColor: AppColors.error,
      enabled: enabled,
      onChanged: onChanged,
      decoration:
          decoration ??
          BorderHelper.textFormFieldPrimary(
            suffix: suffix,
            label: labelText,
            hintText: hintText ?? "",
          ),
      focusNode: focusNode,
      keyboardType: keyboardType ?? TextInputType.text,
      obscureText: obscureText,
      onTapOutside: (event) => Navigator.of(context).focusNode.unfocus(),
      maxLength: maxLength,
      maxLines: maxLines,
      minLines: minLines,
      readOnly: readOnly,
      style: style,
      textAlign: textAlign,
      validator: validator,
    );
  }
}
