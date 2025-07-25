import 'package:flutter/material.dart';
import 'package:mindful_youth/app_const/app_image_strings.dart';
import 'package:mindful_youth/screens/home_screen/home_screen.dart';
import 'package:mindful_youth/screens/login/sign_up/educational_details.dart';
import 'package:mindful_youth/utils/method_helpers/gradient_helper.dart';
import '../../app_const/app_colors.dart';
import '../../app_const/app_icons.dart';

class ListHelper {
  static final List<Map<String, dynamic>> navDestinations = [
    {'icon': AppIconsData.home, 'label': 'Home'},
    {'icon': AppIconsData.wall, 'label': 'Wall'},
    {'icon': AppIconsData.programs, 'label': 'Program'},
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
  static const List<String> degreesList = [
    "10 TH Pass",
    "12 Th Pass",
    "Accounting",
    "Advanced Diploma",
    "Animation",
    "Anthropology",
    "Architecture",
    "Artificial Intelligence",
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
    "Biology",
    "Biomedical Engineering",
    "Business Administration",
    "Certified Management Accountant (CMA)",
    "Chartered Accountant (CA)",
    "Chemistry",
    "Civil Engineering",
    "Company Secretary (CS)",
    "Computer Science",
    "Culinary Arts",
    "Cybersecurity",
    "Data Science",
    "Dentistry",
    "Design",
    "Diploma",
    "Doctor of Dental Surgery (DDS)",
    "Doctor of Medicine (MD)",
    "Doctor of Philosophy (PhD)",
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
    "High School Certificate",
    "History",
    "Hospitality Management",
    "Human Resources",
    "Information Technology",
    "Interior Design",
    "Intermediate / 12th Grade",
    "Islamic Studies",
    "Journalism",
    "Law",
    "Linguistics",
    "Marketing",
    "Mass Communication",
    "Mathematics",
    "Mechanical Engineering",
    "Master of Arts (MA)",
    "Master of Business Administration (MBA)",
    "Master of Commerce (MCom)",
    "Master of Computer Applications (MCA)",
    "Master of Education (M.Ed)",
    "Master of Engineering (ME)",
    "Master of Science (MSc)",
    "Master of Technology (MTech)",
    "Medicine",
    "Nursing",
    "Pharmacy",
    "Philosophy",
    "Physics",
    "Political Science",
    "Post Graduate Diploma",
    "Psychology",
    "Public Health",
    "Robotics",
    "Sanskrit",
    "Social Work",
    "Sociology",
    "Statistics",
    "Theology",
    "Vocational Training Certificate",
  ];
  static List<String> alphabats = [
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',
    'W',
    'X',
    'Y',
    'Z',
  ];

  static List<TestimonialCard> testimonialList() {
    return [
      TestimonialCard(
        name: "DISHA R TAUNK, Coimbatore",
        designation: "Yoga & Sports Motivator",
        testimonial:
            "The youth enrichment program is the need of the hour. Going by the changes that our youth below 30 are seen, it becomes imperative to get them into Hindusim , our festivals, and not be drawn towards fake narratives circulated This program would help our youth to garner in terest in our cultures, festivals, becoming strong holistically- 360° acceptance and becoming in a similar manner ,as mentioned in this unique program. A must for all age groups!",
        imageUrl: AppImageStrings.dishartaunk,
      ),
      TestimonialCard(
        name: "Jitendra Upadhyay, Ahmedabad",
        designation: "Educationist",
        testimonial:
            'The Mindful Youth Program will be very helpful to college students to develop their overall skills which will help them attract bright placement opportunities. I strongly recommend all students to join this application.',
        imageUrl: AppImageStrings.jitendraUpadhyay,
      ),
      TestimonialCard(
        name: "Alpa Shah, Ahmedabad",
        designation: "Media Influencer ",
        testimonial:
            'Self learning is the best learning. I am sure this journey will help subscribers to rediscover their ownselves.',
        imageUrl: AppImageStrings.alpaShah,
      ),
    ];
  }

  static List<TestimonialCard> mentorsList() {
    return [
      TestimonialCard(
        name: "Dr. Trikaldash Bapu",
        designation: "Saint & Philospher",
        testimonial:
            'Journey is as important as destination. Life is all about celebrating every single moment. My best wishes & Jay SiyaRam to all Sanatani Learners.',
        imageUrl: AppImageStrings.trikaldash,
      ),
      TestimonialCard(
        name: "Dasharath Patel",
        designation: "Philanthoropist",
        testimonial:
            'Mindful Youth is a unique program for all young professionals, teachers and students to make their understanding about key topics more deeper and sensible.',
        imageUrl: AppImageStrings.dashrathPatel,
      ),
      TestimonialCard(
        name: "Dr. K G Mehta",
        designation: "Director, Ved Bhavan",
        testimonial:
            'Mindful Youth is a unique program for all young professionals, teachers and students to make their understanding about key topics more deeper and sensible. It is our duty & responsibility.',
        imageUrl: AppImageStrings.kgMehta,
      ),
    ];
  }
}
