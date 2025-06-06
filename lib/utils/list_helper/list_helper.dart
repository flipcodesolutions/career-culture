import 'package:flutter/material.dart';
import 'package:mindful_youth/screens/login/sign_up/educational_details.dart';
import 'package:mindful_youth/utils/method_helpers/gradient_helper.dart';
import '../../app_const/app_colors.dart';
import '../../app_const/app_icons.dart';

class ListHelper {
  static final List<Map<String, dynamic>> navDestinations = [
    {'icon': AppIconsData.home, 'label': 'Home'},
    {'icon': AppIconsData.wall, 'label': 'Wall'},
    {'icon': AppIconsData.programs, 'label': 'Programs'},
    {'icon': AppIconsData.event, 'label': 'Events'},
    {'icon': AppIconsData.profile, 'label': 'Account'},
  ];

  /// Returns a list with dynamically updated icon colors based on navIndex
  static List<Map<String, dynamic>> getNavDestinations(int navIndex) {
    return navDestinations
        .asMap()
        .map(
          (index, item) => MapEntry(index, {
            ...item,
            'iconColor': index == navIndex ? null : AppColors.black,
          }),
        )
        .values
        .toList();
  }

  /// programs gradient helper list
  static List<Gradient> programListGradient = [
    GradientHelper.bodyGradient,
    GradientHelper.mindGradient,
    GradientHelper.soulGradient,
  ];
  //// static list of degree for user to choose when [EducationalDetails] filling
  static const List<String> degreeTypes = [
    "Advanced Diploma",
    "Associate Degree",
    "Bachelor of Architecture (B.Arch)",
    "Bachelor of Arts (BA)",
    "Bachelor of Commerce (BCom)",
    "Bachelor of Computer Applications (BCA)",
    "Bachelor of Dental Surgery (BDS)",
    "Bachelor of Education (B.Ed)",
    "Bachelor of Engineering (BE)",
    "Bachelor of Fine Arts (BFA)",
    "Bachelor of Laws (LLB)",
    "Bachelor of Medicine, Bachelor of Surgery (MBBS)",
    "Bachelor of Pharmacy (BPharm)",
    "Bachelor of Science (BSc)",
    "Bachelor of Technology (BTech)",
    "Certified Management Accountant (CMA)",
    "Chartered Accountant (CA)",
    "Company Secretary (CS)",
    "Diploma",
    "Doctor of Dental Surgery (DDS)",
    "Doctor of Medicine (MD)",
    "Doctor of Philosophy (PhD)",
    "High School Certificate",
    "Intermediate / 12th Grade",
    "Master of Arts (MA)",
    "Master of Business Administration (MBA)",
    "Master of Commerce (MCom)",
    "Master of Computer Applications (MCA)",
    "Master of Education (M.Ed)",
    "Master of Engineering (ME)",
    "Master of Science (MSc)",
    "Master of Technology (MTech)",
    "Post Graduate Diploma",
    "Vocational Training Certificate",
  ];
  //// static list of degree for user to choose when [EducationalDetails] filling
  static const List<String> fieldsOfStudy = [
    "10 TH Pass",
    "12 Th Pass",
    "Accounting",
    "Animation",
    "Anthropology",
    "Architecture",
    "Artificial Intelligence",
    "Biology",
    "Biomedical Engineering",
    "Business Administration",
    "Chemistry",
    "Civil Engineering",
    "Computer Science",
    "Culinary Arts",
    "Cybersecurity",
    "Data Science",
    "Dentistry",
    "Design",
    "Economics",
    "Education",
    "Electrical Engineering",
    "Electronics and Communication",
    "English Literature",
    "Environmental Science",
    "Ethics",
    "Fashion Design",
    "Finance",
    "Fine Arts",
    "Geography",
    "History",
    "Hospitality Management",
    "Human Resources",
    "Information Technology",
    "Interior Design",
    "Islamic Studies",
    "Journalism",
    "Law",
    "Linguistics",
    "Marketing",
    "Mass Communication",
    "Mathematics",
    "Mechanical Engineering",
    "Medicine",
    "Nursing",
    "Pharmacy",
    "Philosophy",
    "Physics",
    "Political Science",
    "Psychology",
    "Public Health",
    "Robotics",
    "Sanskrit",
    "Social Work",
    "Sociology",
    "Statistics",
    "Theology",
  ];
}
