import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../app_const/app_colors.dart';
import '../provider/home_screen_provider/home_screen_provider.dart';
import '../utils/list_helper/list_helper.dart';
import 'custom_container.dart';

class NavigationBarWidget extends StatelessWidget {
  final int navIndex;

  const NavigationBarWidget({super.key, required this.navIndex});

  @override
  Widget build(BuildContext context) {
    // List of destinations with labels and icons
    final List<Map<String, dynamic>> destinations =
        ListHelper.getNavDestinations(navIndex);
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.grey.shade300, width: 1),
            ),
          ),
          child: BottomNavigationBar(
            items:
                destinations.map((destination) {
                  // Handle icon color for Profile dynamically
                  return BottomNavigationBarItem(
                    icon: Icon(
                      destination['icon'],
                      color: destination['iconColor'],
                      // Apply icon color if provided
                    ),
                    label: destination['label'],
                  );
                }).toList(),
            currentIndex: context.read<HomeScreenProvider>().navigationIndex,
            onTap: (int index) {
              context.read<HomeScreenProvider>().setNavigationIndex = index;
            },
          ),
        ),
        Positioned(
          top: 0,
          left: (100.w / destinations.length) * navIndex,
          width: 100.w / destinations.length,
          child: CustomContainer(
            height: 3,
            backGroundColor: AppColors.secondary,
          ),
        ),
      ],
    );
  }
}
