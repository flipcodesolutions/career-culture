import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  const CustomContainer(
      {super.key,
      this.alignment,
      this.child,
      this.constraints,
      this.height,
      this.width,
      this.margin,
      this.padding,
      this.borderColor,
      this.borderWidth,
      this.image,
      this.backGroundColor,
      this.borderRadius,
      this.boxShadow,
      this.shape = BoxShape.rectangle,
      this.gradient,
      this.border});
  final AlignmentGeometry? alignment;
  final Widget? child;
  final BoxConstraints? constraints;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Color? borderColor;
  final double? borderWidth;
  final DecorationImage? image;
  final Color? backGroundColor;
  final BorderRadiusGeometry? borderRadius;
  final List<BoxShadow>? boxShadow;
  final BoxShape shape;
  final Gradient? gradient;
  final BoxBorder? border;
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      constraints: constraints,
      height: height,
      width: width,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
          border: border ??
              Border.all(
                color: borderColor ?? Colors.transparent,
                width: borderWidth ?? 2,
              ),
          borderRadius: borderRadius,
          color: backGroundColor,
          image: image,
          shape: shape,
          gradient: gradient,
          boxShadow: boxShadow),
      child: child,
    );
  }
}

class CustomAnimatedContainer extends StatelessWidget {
  const CustomAnimatedContainer(
      {super.key,
      this.alignment,
      this.child,
      this.constraints,
      this.height,
      this.width,
      this.margin,
      this.padding,
      this.borderColor,
      this.borderWidth,
      this.image,
      this.backGroundColor,
      this.borderRadius,
      this.boxShadow,
      this.shape = BoxShape.rectangle,
      this.gradient,
      this.duration,
      this.curve});
  final AlignmentGeometry? alignment;
  final Widget? child;
  final BoxConstraints? constraints;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Color? borderColor;
  final double? borderWidth;
  final DecorationImage? image;
  final Color? backGroundColor;
  final BorderRadiusGeometry? borderRadius;
  final List<BoxShadow>? boxShadow;
  final BoxShape shape;
  final Gradient? gradient;
  final Duration? duration;
  final Curve? curve;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: duration ?? Duration(milliseconds: 300),
      alignment: alignment,
      constraints: constraints,
      height: height,
      width: width,
      margin: margin,
      padding: padding,
      curve: curve ?? Curves.ease,
      decoration: BoxDecoration(
          border: Border.all(
            color: borderColor ?? Colors.transparent,
            width: borderWidth ?? 2,
          ),
          borderRadius: borderRadius,
          color: backGroundColor,
          image: image,
          shape: shape,
          gradient: gradient,
          boxShadow: boxShadow),
      child: child,
    );
  }
}
