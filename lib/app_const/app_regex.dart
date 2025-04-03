class AppRegex {
  static  RegExp emailReg =
      RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  static  RegExp onlyDigitReg =
      RegExp(r'^\d+$');
}
