import 'package:flutter/material.dart';
import 'package:mindful_youth/widgets/custom_text.dart';
import 'package:sizer/sizer.dart';
import '../app_const/app_colors.dart';
import '../app_const/app_size.dart';
import '../app_const/app_strings.dart';
import 'custom_container.dart';

class SwipeToConfirm extends StatefulWidget {
  final String text;
  final VoidCallback onConfirm;

  const SwipeToConfirm({
    super.key,
    required this.text,
    required this.onConfirm,
  });

  @override
  _SwipeToConfirmState createState() => _SwipeToConfirmState();
}

class _SwipeToConfirmState extends State<SwipeToConfirm>
    with SingleTickerProviderStateMixin {
  double _dragPosition = 0.0;
  bool _isConfirmed = false;
  double _maxDragDistance = 72.w;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        // Background bar
        CustomContainer(
          height: AppSize.size70,
          width: double.infinity,
          backGroundColor: AppColors.grey.withOpacity(0.5),
          borderRadius: BorderRadius.circular(AppSize.size40),
          padding: const EdgeInsets.symmetric(horizontal: AppSize.size10),
          alignment: Alignment.center,
          child: CustomText(
            text: _isConfirmed ? AppStrings.confirmed : widget.text,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ),
        // Swipe button
        Positioned(
          left: _dragPosition,
          child: GestureDetector(
            onHorizontalDragUpdate: (details) {
              setState(() {
                // Update drag position
                _dragPosition += details.delta.dx;
                if (_dragPosition < 0) _dragPosition = 0;
                if (_dragPosition > _maxDragDistance) {
                  _dragPosition = _maxDragDistance;
                }
              });
            },
            onHorizontalDragEnd: (details) {
              // Check if swipe is completed
              if (_dragPosition >= _maxDragDistance * 0.85) {
                setState(() {
                  _isConfirmed = true;
                  widget.onConfirm();
                });
              } else {
                // Reset position if not fully swiped
                setState(() {
                  _dragPosition = 0.0;
                });
              }
            },
            child: CustomAnimatedContainer(
              backGroundColor:
                  _isConfirmed ? AppColors.primary : AppColors.error,
              shape: BoxShape.circle,
              duration: const Duration(milliseconds: 300),
              height: AppSize.size70,
              width: AppSize.size70,
              child: Icon(
                _isConfirmed ? Icons.check : Icons.arrow_forward_ios,
                color: AppColors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
