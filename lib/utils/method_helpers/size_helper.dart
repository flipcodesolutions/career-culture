import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SizeHelper {
  static SizedBox height({double? height,Widget? child}) {
    return SizedBox(
      height: height ?? 2.h,
      child: child,
    );
  }

  static SizedBox width({double? width,Widget? child}) {
    return SizedBox(
      width: width ?? 2.w,child: child,
    );
  }
}
