import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SizeHelper {
  static SizedBox height({double? height}) {
    return SizedBox(
      height: height ?? 2.h,
    );
  }

  static SizedBox width({double? width}) {
    return SizedBox(
      width: width ?? 2.w,
    );
  }
}
