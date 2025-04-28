import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:mindful_youth/app_const/app_size.dart';
import 'package:mindful_youth/models/login_model/convener_list_model.dart';
import 'package:mindful_youth/widgets/no_data_found.dart';
import '../app_const/app_colors.dart';
import '../app_const/app_strings.dart';
import '../utils/border_helper/border_helper.dart';
import '../utils/method_helpers/validator_helper.dart';
import '../utils/text_style_helper/text_style_helper.dart';
import 'custom_container.dart';
import 'custom_text.dart';

class CustomSearchableDropDown extends StatelessWidget {
  const CustomSearchableDropDown({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Convener> conveners = [
      Convener(name: "John Doe", email: "john@example.com"),
      Convener(name: "Jane Smith", email: "jane@example.com"),
      Convener(name: "Alex Johnson", email: "alex@example.com"),
    ];
    return DropdownSearch<Convener>(
      items: (filter, loadProps) => conveners, // <-- Just pass List<Convener>
      compareFn: (item1, item2) => item1.name == item2.name,
      itemAsString: (item) => item.name ?? "",
      popupProps: PopupProps.menu(
        menuProps: MenuProps(
          align: MenuAlign.bottomCenter,
          backgroundColor: AppColors.white,
        ),
        fit: FlexFit.loose,
        itemBuilder:
            (context, convener, isDisabled, isSelected) => CustomContainer(
              padding: EdgeInsets.all(AppSize.size10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomText(
                    text: convener.name ?? "",
                    style: TextStyleHelper.smallHeading.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  // CustomText(text: convener?.city ?? ""),
                  CustomText(text: convener.email ?? ""),
                ],
              ),
            ),
        emptyBuilder:
            (context, searchEntry) =>
                CustomContainer(child: NoDataFoundWidget()),
        showSearchBox: true, // <-- Enables search box
        searchFieldProps: TextFieldProps(
          decoration: inputDecoration(hintText: AppStrings.searchHere),
        ),
      ),
      decoratorProps: DropDownDecoratorProps(
        decoration: inputDecoration(labelText: AppStrings.selectConvener),
      ),
      dropdownBuilder:
          (context, convener) => CustomContainer(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomText(
                  text: convener?.name ?? "",
                  style: TextStyleHelper.smallHeading.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                // CustomText(text: convener?.city ?? ""),
                CustomText(text: convener?.email ?? ""),
              ],
            ),
          ),
      // validator:
      //     (value) => ValidatorHelper.validateValue(
      //       value: value?.name ?? "",
      //       context: context,
      //     ),
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
