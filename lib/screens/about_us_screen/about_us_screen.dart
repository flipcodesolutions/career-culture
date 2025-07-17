import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:mindful_youth/app_const/app_size.dart';
import 'package:mindful_youth/screens/programs_screen/programs_screens.dart';
import 'package:mindful_youth/utils/text_style_helper/text_style_helper.dart';
import 'package:mindful_youth/widgets/custom_text.dart';
import 'package:mindful_youth/widgets/youtube_player.dart';
import 'package:sizer/sizer.dart';
import '../../app_const/app_colors.dart';
import '../../app_const/app_strings.dart';
import '../../utils/list_helper/list_helper.dart';
import '../../utils/method_helpers/shadow_helper.dart';
import '../../utils/method_helpers/size_helper.dart';
import '../../widgets/custom_container.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({super.key});

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: Border.all(style: BorderStyle.none),
        title: MIndFulYouthACertificateProgramTitle(
          style: TextStyleHelper.mediumHeading.copyWith(
            color: AppColors.primary,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: CustomContainer(
                    borderRadius: BorderRadius.circular(AppSize.size10),
                    backGroundColor: AppColors.lightWhite,
                    boxShadow: ShadowHelper.scoreContainer,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppSize.size10),
                      child: VideoPreviewScreen(
                        videoUrl: "t2G5x0qdNkA",
                        description: "",
                      ),
                    ),
                  ),
                ),
              ),
              CustomContainer(
                backGroundColor: AppColors.lightWhite,
                borderRadius: BorderRadius.circular(AppSize.size10),
                margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                // padding: EdgeInsets.all(AppSize.size10),
                child: Html(
                  data:
                      "<div style='font-family: sans-serif; color: #333; padding: 20px; line-height: 1.6;'> <h2 style='text-align: center; color: #1B5E20;'>About Career Culture</h2> <p><strong>Career Culture</strong> is more than just an app—it's a movement built to inspire and empower today’s youth on their journey of self-discovery and growth.</p> <p>Designed with purpose, the app delivers a seamless and user-friendly experience from the moment you sign up—whether via mobile number, Google, or Facebook. Once logged in, users are welcomed by a personalized dashboard featuring:</p> <ul style='padding-left: 20px;'> <li>Recent activities and updates</li> <li>Upcoming events and opportunities</li> <li>Expert insights and motivational content</li> <li>Quick access to coins, notifications, products, and leaderboards</li> </ul> <p>At the heart of the platform lies the <strong>Mindful Youth Program</strong>—a self-improvement journey built around three foundational pillars:</p> <ul style='padding-left: 20px;'> <li><strong>Body</strong> – Physical well-being and healthy habits</li> <li><strong>Mind</strong> – Emotional awareness and mental clarity</li> <li><strong>Soul</strong> – Purpose, values, and inner growth</li> </ul> <p>Each pillar includes 8 carefully curated chapters, complete with interactive elements such as dual assessment tests and a recommended media gallery to deepen learning and engagement.</p> <p>Beyond the program, Career Culture fosters a vibrant and supportive community. Users can post on the interactive wall, attend real-world or virtual events, and connect with like-minded individuals on similar paths.</p> <p>The app also features a full account section where users can:</p> <ul style='padding-left: 20px;'> <li>Edit and personalize their profile</li> <li>Refer friends and grow the movement</li> <li>Access FAQs and app-related information</li> <li>Manage account settings, including secure account deletion</li> </ul> <p style='margin-top: 24px;'><em>Career Culture is dedicated to nurturing the full potential of youth—helping them grow into mindful, confident, and purpose-driven individuals.</em></p> </div>",
                ),
              ),

              /// testimonial crousal
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: CustomText(
                  text: AppStrings.meetOurMentors,
                  style: TextStyleHelper.mediumHeading.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
              SizeHelper.height(),

              ///
              CarouselSlider(
                items: ListHelper.testimonialList(),
                options: CarouselOptions(
                  autoPlay: true,
                  viewportFraction: 0.9,
                  enlargeCenterPage: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
