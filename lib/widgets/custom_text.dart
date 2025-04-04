import 'package:flutter/material.dart';
import '../utils/text_style_helper/text_style_helper.dart';

class CustomText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final bool useOverflow;
  const CustomText(
      {super.key,
      required this.text,
      this.style,
      this.textAlign,
      this.textDirection,
      this.useOverflow = true});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style ?? TextStyleHelper.smallText,
      textAlign: textAlign,
      textDirection: textDirection,
      overflow: useOverflow ? TextOverflow.ellipsis : null,
    );
  }
}

// class CustomLocaleText extends StatelessWidget {
//   final String text;
//   final TextStyle? style;
//   final TextAlign? textAlign;
//   final TextDirection? textDirection;
//   final bool useOverflow;
//   const CustomLocaleText(
//       {super.key,
//       required this.text,
//       this.style,
//       this.textAlign,
//       this.textDirection,
//       this.useOverflow = true});

//   @override
//   Widget build(BuildContext context) {
//     return Selector<LocalizationProvider, String>(
//       builder: (context, localeText, child) => Text(
//         localeText,
//         style: style ?? TextStyleHelper.smallText,
//         textAlign: textAlign,
//         textDirection: textDirection,
//         overflow: useOverflow ? TextOverflow.ellipsis : null,
//       ),
//       selector: (context, localeProvider) => localeProvider.translate(text),
//     );
//   }
// }
