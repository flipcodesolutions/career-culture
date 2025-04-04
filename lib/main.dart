import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mindful_youth/app_const/app_size.dart';
import 'package:mindful_youth/app_const/app_strings.dart';
import 'package:mindful_youth/provider/home_screen_provider/home_screen_provider.dart';
import 'package:mindful_youth/provider/on_boarding_provider/on_boarding_provider.dart';
import 'package:mindful_youth/provider/programs_provider/chapter_provider/chapter_provider.dart';
import 'package:mindful_youth/provider/programs_provider/post_provider/post_provider.dart';
import 'package:mindful_youth/provider/programs_provider/programs_provider.dart';
import 'package:mindful_youth/screens/spalsh_screen/spalsh_screen.dart';
import 'package:mindful_youth/utils/app_theme/app_theme_helper.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'app_const/app_colors.dart';
import 'utils/text_style_helper/text_style_helper.dart';

void main() async {
  /// will wait until every thing is initialized
  WidgetsFlutterBinding.ensureInitialized();

  /// this line will prevent app to rotate horizontally
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await dotenv.load(fileName: ".env");
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => HomeScreenProvider()),
        ChangeNotifierProvider(create: (context) => OnBoardingProvider()),
        ChangeNotifierProvider(create: (context) => ProgramsProvider()),
        ChangeNotifierProvider(create: (context) => ChapterProvider()),
        ChangeNotifierProvider(create: (context) => PostProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder:
          (context, value, child) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: AppStrings.appName,
            // app theme
            theme: ThemeData(
              fontFamily: "Merriweather",
              scaffoldBackgroundColor: AppColors.white,
              appBarTheme: AppBarTheme(
                backgroundColor: AppColors.white,
                surfaceTintColor: AppColors.white,
                foregroundColor: AppColors.primary,
                actionsIconTheme: IconThemeData(color: AppColors.black),
                centerTitle: true,
                shape: Border(
                  bottom: BorderSide(color: AppColors.grey, width: 1),
                ),

                /// change the top status bar color
                systemOverlayStyle: AppThemeHelper.systemTopStatusBar,
              ),
              primaryColor: AppColors.primary,
              splashColor: Colors.transparent,
              datePickerTheme: DatePickerThemeData(
                backgroundColor: AppColors.cream,
                dayBackgroundColor: WidgetStatePropertyAll(AppColors.primary),
                dayForegroundColor: WidgetStatePropertyAll(AppColors.white),
                headerBackgroundColor: AppColors.secondary,
                headerForegroundColor: AppColors.white,
              ),
              searchBarTheme: SearchBarThemeData(
                padding: WidgetStatePropertyAll(
                  EdgeInsets.symmetric(horizontal: 5.w),
                ),
                backgroundColor: WidgetStatePropertyAll(AppColors.white),

                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSize.size30),
                    side: BorderSide(color: AppColors.black, width: 0.5),
                  ),
                ),
              ),
              bottomNavigationBarTheme: BottomNavigationBarThemeData(
                backgroundColor: AppColors.white,
                enableFeedback: false,
                selectedLabelStyle: TextStyleHelper.smallText,
                unselectedLabelStyle: TextStyleHelper.smallText,
                selectedItemColor: AppColors.secondary,
                unselectedItemColor: AppColors.black,
                type: BottomNavigationBarType.fixed,
              ),
              tabBarTheme: TabBarThemeData(
                labelColor: AppColors.secondary,
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: AppColors.secondary,
                indicatorColor: AppColors.secondary,
              ),
            ),
            home: SplashScreen(),
          ),
    );
  }
}
