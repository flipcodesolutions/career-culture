import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mindful_youth/app_const/app_size.dart';
import 'package:mindful_youth/widgets/custom_container.dart';
import 'package:sizer/sizer.dart';
import '../app_const/app_colors.dart';
import '../utils/border_helper/border_helper.dart'; // For keyboard input types

class CustomTextFormField extends StatefulWidget {
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
    this.suggestions,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  // late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();

    if (widget.onChanged != null) {
      widget.controller?.addListener(() {
        widget.onChanged!(widget.controller?.text ?? "");
      });
    }
  }

  @override
  void dispose() {
    if (widget.focusNode == null) _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final inputDecoration =
        widget.decoration ??
        BorderHelper.textFormFieldPrimary(
          suffix: widget.suffix,
          label: widget.labelText,
          hintText: widget.hintText ?? "",
        );

    if (widget.suggestions != null && widget.suggestions!.isNotEmpty) {
      return RawAutocomplete<String>(
        textEditingController: widget.controller,
        focusNode: _focusNode,
        optionsBuilder: (TextEditingValue value) {
          if (value.text.isEmpty) return const Iterable<String>.empty();
          return widget.suggestions!.where(
            (option) => option.toLowerCase().contains(value.text.toLowerCase()),
          );
        },
        fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
          return TextFormField(
            controller: controller,
            focusNode: focusNode,
            autocorrect: widget.autocorrect,
            onFieldSubmitted: (_) => onFieldSubmitted(),
            decoration: inputDecoration,
            cursorColor: AppColors.primary,
            keyboardType: widget.keyboardType,
            obscureText: widget.obscureText,
            onTapOutside: (_) => FocusScope.of(context).unfocus(),
            maxLength: widget.maxLength,
            maxLines: widget.maxLines,
            minLines: widget.minLines,
            readOnly: widget.readOnly,
            style: widget.style,
            textAlign: widget.textAlign,
            validator: widget.validator,
            buildCounter:
                (
                  _, {
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
    }

    return TextFormField(
      controller: widget.controller,
      focusNode: _focusNode,
      autocorrect: widget.autocorrect,
      cursorColor: AppColors.primary,
      cursorErrorColor: AppColors.error,
      keyboardType: widget.keyboardType ?? TextInputType.text,
      obscureText: widget.obscureText,
      readOnly: widget.readOnly,
      enabled: widget.enabled,
      maxLength: widget.maxLength,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      style: widget.style,
      textAlign: widget.textAlign,
      validator: widget.validator,
      decoration: inputDecoration,
      onTapOutside: (_) => FocusScope.of(context).unfocus(),
      buildCounter:
          (
            _, {
            required currentLength,
            required isFocused,
            required maxLength,
          }) => null,
      contextMenuBuilder: (context, editableTextState) {
        return AdaptiveTextSelectionToolbar(
          anchors: editableTextState.contextMenuAnchors,
          children:
              widget.adaptiveTextSelectionToolbarChildren ??
              [
                TextSelectionToolbarTextButton(
                  padding: const EdgeInsets.all(8),
                  onPressed: () async {
                    final clipboardData = await Clipboard.getData('text/plain');
                    final textToPaste = clipboardData?.text ?? '';
                    final currentValue = editableTextState.textEditingValue;
                    final selection = currentValue.selection;

                    if (selection.isValid) {
                      final newText = currentValue.text.replaceRange(
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

                    editableTextState.hideToolbar();
                  },
                  child: const Text('Paste'),
                ),
              ],
        );
      },
    );
  }
}
