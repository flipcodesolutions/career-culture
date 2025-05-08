import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:mindful_youth/widgets/no_data_found.dart';
import '../app_const/app_colors.dart';
import '../app_const/app_strings.dart';
import '../utils/border_helper/border_helper.dart';
import '../utils/text_style_helper/text_style_helper.dart';
import 'custom_container.dart';

class CustomSearchableDropDown<T> extends StatelessWidget {
  const CustomSearchableDropDown({
    super.key,
    this.onSaved,
    required this.list,
    this.compareFn,
    required this.itemAsString,
    required this.itemBuilder,
    required this.dropdownBuilder,
    required this.validator,
    required this.onChanged,
    this.selectedItem,
  });
  final void Function(T?)? onSaved;
  final bool Function(T, T)? compareFn;
  final List<T> list;
  final String Function(T)? itemAsString;
  final Widget Function(BuildContext, T, bool, bool)? itemBuilder;
  final Widget Function(BuildContext, T?)? dropdownBuilder;
  final String? Function(T?)? validator;
  final void Function(T?)? onChanged;
  final T? selectedItem;
  @override
  Widget build(BuildContext context) {
    return DropdownSearch<T>(
      onSaved: onSaved,
      items: (filter, loadProps) => list, // <-- Just pass List<Convener>
      compareFn: compareFn,
      itemAsString: itemAsString,
      popupProps: PopupProps.menu(
        menuProps: MenuProps(
          align: MenuAlign.bottomCenter,
          backgroundColor: AppColors.white,
        ),
        fit: FlexFit.tight,
        itemBuilder: itemBuilder,
        emptyBuilder:
            (context, searchEntry) =>
                CustomContainer(child: NoDataFoundWidget(text: AppStrings.noConvenerFound,)),
        showSearchBox: true, // <-- Enables search box
        searchFieldProps: TextFieldProps(
          decoration: inputDecoration(hintText: AppStrings.searchHere),
        ),
      ),
      decoratorProps: DropDownDecoratorProps(
        decoration: inputDecoration(labelText: AppStrings.selectConvener),
      ),
      dropdownBuilder: dropdownBuilder,
      validator: validator,
      onChanged: onChanged,
      selectedItem: selectedItem,
    );
  }

  InputDecoration inputDecoration({String? hintText, String? labelText}) {
    return InputDecoration(
      floatingLabelBehavior: FloatingLabelBehavior.always,
      hintText: hintText,
      labelText: labelText,
      labelStyle: TextStyleHelper.mediumHeading.copyWith(
        color: AppColors.primary,
      ),
      border: BorderHelper.inputBorder,
      errorBorder: BorderHelper.inputBorderError,
      enabledBorder: BorderHelper.inputBorder,
      focusedBorder: BorderHelper.inputBorderFocused,
      disabledBorder: BorderHelper.inputBorderDisabled,
      focusedErrorBorder: BorderHelper.inputBorderError,
    );
  }
}
