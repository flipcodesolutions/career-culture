import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mindful_youth/app_const/app_size.dart';
import 'package:mindful_youth/widgets/custom_container.dart';
import 'package:sizer/sizer.dart';
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

  // 🔽 New autocomplete parameter
  final List<String>? suggestions;

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
    this.validator,
    this.decoration,
    this.enabled = true,
    this.hintText,
    this.labelText,
    this.onChanged,
    this.suffix,
    this.adaptiveTextSelectionToolbarChildren,
    this.suggestions, // ✅ Add this
  });

  @override
  Widget build(BuildContext context) {
    final inputDecoration =
        decoration ??
        BorderHelper.textFormFieldPrimary(
          suffix: suffix,
          label: labelText,
          hintText: hintText ?? "",
        );

    if (suggestions != null && suggestions!.isNotEmpty) {
      return RawAutocomplete<String>(
        textEditingController: controller ?? TextEditingController(),
        focusNode: focusNode ?? FocusNode(),
        optionsBuilder: (TextEditingValue textEditingValue) {
          if (textEditingValue.text == '') {
            return const Iterable<String>.empty();
          }
          return suggestions?.where((String option) {
                return option.toLowerCase().contains(
                  textEditingValue.text.toLowerCase(),
                );
              }) ??
              const Iterable<String>.empty();
        },
        fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
          return TextFormField(
            controller: controller,
            focusNode: focusNode,
            autocorrect: autocorrect,
            onFieldSubmitted: (value) => onFieldSubmitted(),
            decoration: inputDecoration,
            cursorColor: AppColors.primary,
            keyboardType: keyboardType,
            obscureText: obscureText,
            onTapOutside: (event) => Navigator.of(context).focusNode.unfocus(),
            maxLength: maxLength,
            maxLines: maxLines,
            minLines: minLines,
            readOnly: readOnly,
            style: style,
            textAlign: textAlign,
            validator: validator,
            onChanged: onChanged,
            buildCounter:
                (
                  context, {
                  required currentLength,
                  required isFocused,
                  required maxLength,
                }) => null,
          );
        },
        optionsViewBuilder: (context, onSelected, options) {
          return Align(
            alignment: Alignment.topLeft,
            child: CustomContainer(
              width: 70.w,
              constraints: BoxConstraints(maxHeight: 25.h),
              backGroundColor: AppColors.lightPrimary,
              margin: EdgeInsets.only(right: 12.w),
              child: Material(
                color: Colors.transparent,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    final option = options.elementAt(index);
                    return CustomContainer(
                      borderRadius: BorderRadius.circular(AppSize.size10),
                      backGroundColor: AppColors.lightWhite,
                      margin: EdgeInsets.symmetric(vertical: 0.2.h),
                      child: ListTile(
                        title: Text(option),
                        onTap: () => onSelected(option),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      );
    } else {
      return TextFormField(
        autocorrect: autocorrect,
        controller: controller,
        contextMenuBuilder: (context, editableTextState) {
          return AdaptiveTextSelectionToolbar(
            anchors: editableTextState.contextMenuAnchors,
            children:
                adaptiveTextSelectionToolbarChildren ??
                [
                  TextSelectionToolbarTextButton(
                    padding: const EdgeInsets.all(8),
                    onPressed: () async {
                      final clipboardData = await Clipboard.getData(
                        'text/plain',
                      );
                      final textToPaste = clipboardData?.text ?? '';
                      final controller = editableTextState.textEditingValue;
                      final selection = controller.selection;

                      if (selection.isValid) {
                        final newText = controller.text.replaceRange(
                          selection.start,
                          selection.end,
                          textToPaste,
                        );

                        editableTextState.userUpdateTextEditingValue(
                          TextEditingValue(
                            text: newText,
                            selection: TextSelection.collapsed(
                              offset: selection.start + textToPaste.length,
                            ),
                          ),
                          SelectionChangedCause.toolbar,
                        );
                      }

                      // Hide toolbar after paste
                      editableTextState.hideToolbar();
                    },
                    child: const Text('Paste'),
                  ),
                ],
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
        decoration: inputDecoration,
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
}
