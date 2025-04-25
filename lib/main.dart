import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mindful_youth/app_const/app_size.dart';
import 'package:mindful_youth/app_const/app_strings.dart';
import 'package:mindful_youth/provider/all_event_provider/all_event_provider.dart';
import 'package:mindful_youth/provider/assessment_provider/assessment_provider.dart';
import 'package:mindful_youth/provider/home_screen_provider/home_screen_provider.dart';
import 'package:mindful_youth/provider/on_boarding_provider/on_boarding_provider.dart';
import 'package:mindful_youth/provider/programs_provider/chapter_provider/chapter_provider.dart';
import 'package:mindful_youth/provider/programs_provider/post_provider/post_provider.dart';
import 'package:mindful_youth/provider/programs_provider/programs_provider.dart';
import 'package:mindful_youth/provider/score_board_provider/score_board_provider.dart';
import 'package:mindful_youth/provider/user_provider/login_provider.dart';
import 'package:mindful_youth/provider/user_provider/sign_up_provider.dart';
import 'package:mindful_youth/provider/wall_provider/wall_provider.dart';
import 'package:mindful_youth/screens/spalsh_screen/spalsh_screen.dart';
import 'package:mindful_youth/utils/app_theme/app_theme_helper.dart';
import 'package:mindful_youth/utils/border_helper/border_helper.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'app_const/app_colors.dart';
import 'provider/user_provider/user_provider.dart';
import 'utils/text_style_helper/text_style_helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  /// will wait until every thing is initialized
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

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
        ChangeNotifierProvider(create: (context) => AssessmentProvider()),
        ChangeNotifierProvider(create: (context) => AllEventProvider()),
        ChangeNotifierProvider(create: (context) => WallProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => LoginProvider()),
        ChangeNotifierProvider(create: (context) => SignUpProvider()),
        ChangeNotifierProvider(create: (context) => ScoreBoardProvider()),
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
                confirmButtonStyle: ButtonStyle(
                  foregroundColor: WidgetStatePropertyAll(AppColors.secondary),
                ),
                cancelButtonStyle: ButtonStyle(
                  foregroundColor: WidgetStatePropertyAll(AppColors.secondary),
                ),
                backgroundColor: AppColors.cream,
                todayBackgroundColor: WidgetStatePropertyAll(
                  AppColors.secondary,
                ),
                todayForegroundColor: WidgetStatePropertyAll(AppColors.white),
                surfaceTintColor: AppColors.cream,
                inputDecorationTheme: InputDecorationTheme(
                  floatingLabelStyle: TextStyleHelper.smallHeading.copyWith(
                    color: AppColors.primary,
                  ),
                  disabledBorder: BorderHelper.inputBorderDisabled,
                  border: BorderHelper.inputBorder,
                  errorBorder: BorderHelper.inputBorderError,
                  focusedBorder: BorderHelper.inputBorderFocused,
                ),
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
              checkboxTheme: CheckboxThemeData(
                checkColor: WidgetStatePropertyAll(AppColors.white),
                overlayColor: WidgetStatePropertyAll(AppColors.lightPrimary),
              ),
              dropdownMenuTheme: DropdownMenuThemeData(
                textStyle: TextStyleHelper.smallHeading,
              ),
            ),
            home: SplashScreen(),
          ),
    );
  }
}
