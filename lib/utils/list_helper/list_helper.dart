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
    // Primary & Secondary Education
    "10th Pass (Secondary School)",
    "12th Pass / High School Certificate",
    "Intermediate / 12th Grade",
    "A-Levels",
    "International Baccalaureate (IB) Diploma",

    // Vocational & Certificate Programs
    "Vocational Training Certificate",
    "Certificate Course",
    "Diploma",
    "Advanced Diploma",
    "Post Graduate Diploma",
    "Technical Certifications",
    "Culinary Arts",
    "Web Development & Design",
    "Cybersecurity Certification",
    "Digital Marketing Certification",
    "Project Management (PMP, PRINCE2)",
    "Machine Learning Certification",
    "DevOps Certification",

    // Associate Degrees
    "Associate Degree (AA, AS, AAS)",

    // Bachelor’s Degrees
    "Bachelor of Arts (BA)",
    "Bachelor of Science (BSc)",
    "Bachelor of Commerce (BCom)",
    "Bachelor of Business Administration (BBA)",
    "Bachelor of Computer Applications (BCA)",
    "Bachelor of Engineering (BE)",
    "Bachelor of Technology (BTech)",
    "Bachelor of Architecture (B.Arch)",
    "Bachelor of Design (B.Des)",
    "Bachelor of Education (B.Ed)",
    "Bachelor of Fine Arts (BFA)",
    "Bachelor of Laws (LLB)",
    "Bachelor of Library Science (B.Lib)",
    "Bachelor of Management Studies (BMS)",
    "Bachelor of Medicine, Bachelor of Surgery (MBBS)",
    "Bachelor of Pharmacy (BPharm)",
    "Bachelor of Social Work (BSW)",
    "Bachelor of Nursing (BSc Nursing)",
    "Bachelor of Veterinary Science (BVSc)",
    "Bachelor of Communication",
    "Bachelor of Mass Media (BMM)",
    "Bachelor of Hotel Management (BHM)",
    "Bachelor of Physiotherapy (BPT)",
    "Bachelor of Statistics (B.Stat)",
    "Bachelor of Environmental Science",

    // Master’s Degrees
    "Master of Arts (MA)",
    "Master of Science (MSc)",
    "Master of Commerce (MCom)",
    "Master of Business Administration (MBA)",
    "Master of Computer Applications (MCA)",
    "Master of Technology (MTech)",
    "Master of Engineering (ME)",
    "Master of Education (M.Ed)",
    "Master of Library Science (M.Lib)",
    "Master of Laws (LLM)",
    "Master of Social Work (MSW)",
    "Master of Public Health (MPH)",
    "Master of Philosophy (MPhil)",
    "Master of Fine Arts (MFA)",

    // Doctoral / Professional Degrees
    "Doctor of Medicine (MD)",
    "Doctor of Dental Surgery (DDS)",
    "Doctor of Philosophy (PhD)",
    "Doctor of Science (ScD)",
    "Doctor of Education (EdD)",
    "Doctor of Pharmacy (PharmD)",
    "Doctor of Psychology (PsyD)",
    "Juris Doctor (JD)",
    "Doctor of Optometry (OD)",
    "Doctor of Veterinary Medicine (DVM)",
    "Doctor of Nursing Practice (DNP)",
    "Doctor of Theology (ThD)",
    "Doctor of Management",

    // Chartered & Professional Certifications
    "Chartered Accountant (CA)",
    "Certified Management Accountant (CMA)",
    "Company Secretary (CS)",
    "Chartered Financial Analyst (CFA)",
    "Certified Public Accountant (CPA)",
    "Certified Financial Planner (CFP)",
    "Certified Information Systems Auditor (CISA)",
    "Certified Ethical Hacker (CEH)",
    "Six Sigma Certifications (Green Belt, Black Belt)",

    // Engineering & Technology Fields
    "Computer Science",
    "Information Technology",
    "Software Engineering",
    "Electrical Engineering",
    "Electronics and Communication Engineering (ECE)",
    "Mechanical Engineering",
    "Civil Engineering",
    "Chemical Engineering",
    "Mechatronics",
    "Biomedical Engineering",
    "Robotics and Automation",
    "Aerospace Engineering",
    "Automobile Engineering",
    "Marine Engineering",
    "Environmental Engineering",
    "Structural Engineering",
    "Industrial Engineering",
    "Nanotechnology",
    "Engineering Physics",

    // Emerging Tech Fields
    "Artificial Intelligence",
    "Machine Learning",
    "Data Science",
    "Blockchain",
    "Cybersecurity",
    "Cloud Computing",
    "Internet of Things (IoT)",
    "Augmented Reality / Virtual Reality (AR/VR)",
    "Human-Computer Interaction",
    "Quantum Computing",
    "Game Development",

    // Health & Life Sciences
    "Medicine",
    "Dentistry",
    "Nursing",
    "Physiotherapy",
    "Pharmacy",
    "Clinical Psychology",
    "Public Health",
    "Occupational Therapy",
    "Optometry",
    "Radiology Technology",
    "Medical Laboratory Technology",
    "Speech Therapy",
    "Audiology",
    "Health Sciences",
    "Midwifery",
    "Biotechnology",
    "Biomedical Sciences",
    "Genetics",
    "Microbiology",
    "Biostatistics",
    "Nutrition and Dietetics",

    // Natural Sciences
    "Physics",
    "Chemistry",
    "Biology",
    "Mathematics",
    "Statistics",
    "Astronomy",
    "Environmental Science",
    "Botany",
    "Zoology",
    "Geology",
    "Oceanography",
    "Meteorology",
    "Earth Science",

    // Social Sciences & Humanities
    "Political Science",
    "Economics",
    "Psychology",
    "Sociology",
    "Social Work",
    "Anthropology",
    "History",
    "Philosophy",
    "Linguistics",
    "International Relations",
    "Development Studies",
    "Geography",
    "Ethics",
    "Theology / Divinity",
    "Islamic Studies",
    "Sanskrit",
    "Women’s and Gender Studies",

    // Business & Management
    "Business Administration",
    "Finance",
    "Marketing",
    "Human Resources",
    "Operations Management",
    "Logistics and Supply Chain",
    "Entrepreneurship",
    "E-Commerce",
    "Real Estate Management",
    "Hotel and Hospitality Management",
    "Retail Management",
    "Public Administration",

    // Arts, Media & Communication
    "Fine Arts",
    "Performing Arts",
    "Fashion Design",
    "Interior Design",
    "Graphic Design",
    "UI/UX Design",
    "Multimedia and Animation",
    "Journalism",
    "Mass Communication",
    "Digital Media",
    "Film and Media Studies",
    "Photography",
    "Music",
    "Dance",
    "Theatre",

    // Law, Criminology & Public Policy
    "Law",
    "Legal Studies",
    "Criminology",
    "Forensic Science",
    "Public Policy",
    "International Law",
    "Cyber Law",
    "Intellectual Property Law",

    // Misc. & Interdisciplinary
    "Urban Planning",
    "Library and Information Science",
    "Education",
    "Early Childhood Education",
    "Adult Education",
    "Special Education",
    "Sports Science",
    "Kinesiology",
    "Rehabilitation Sciences",
    "Youth Services",
    "Tourism and Travel Management",
    "Event Management",
    "Sustainable Development",
    "Agricultural Science",
    "Food Technology",
    "Forestry",
    "Animal Science",
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

  /// skill
 static const List<String> humanSkills = [

  // === TECHNICAL SKILLS ===
  'Programming: Dart',
  'Programming: Python',
  'Programming: JavaScript',
  'Web Development: Frontend',
  'Web Development: Backend',
  'Mobile Development: Flutter',
  'Software Engineering',
  'DevOps: CI/CD',
  'Database Management: SQL',
  'Cybersecurity',
  'Cloud Computing: AWS',
  'Data Analysis',
  'Machine Learning',
  'Artificial Intelligence',
  'Blockchain Development',
  'Game Development: Unity',
  'Embedded Systems',
  'Networking',
  'Robotics',
  'UI/UX Design',
  
  // === CREATIVE SKILLS ===
  'Graphic Design',
  '3D Modeling',
  'Video Editing',
  'Photography',
  'Painting',
  'Drawing',
  'Creative Writing',
  'Music Composition',
  'Singing',
  'Acting',
  'Animation',
  'Fashion Design',
  'Interior Design',
  'Storytelling',
  'Digital Art',
  'Voice Acting',

  // === COMMUNICATION & SOCIAL SKILLS ===
  'Public Speaking',
  'Negotiation',
  'Conflict Resolution',
  'Emotional Intelligence',
  'Teamwork',
  'Leadership',
  'Customer Service',
  'Interviewing',
  'Networking',
  'Copywriting',
  'Teaching',
  'Persuasion',
  'Podcast Hosting',
  'Presentation Skills',

  // === COGNITIVE SKILLS ===
  'Critical Thinking',
  'Problem Solving',
  'Decision Making',
  'Memory Enhancement',
  'Logical Reasoning',
  'Time Management',
  'Concentration',
  'Speed Reading',
  'Mind Mapping',
  'Meditation',

  // === PHYSICAL SKILLS ===
  'Running',
  'Swimming',
  'Cycling',
  'Weightlifting',
  'Yoga',
  'Martial Arts',
  'Dancing',
  'Rock Climbing',
  'Parkour',
  'Juggling',
  'Archery',
  'Handstand Balancing',
  'Skiing',
  'Skateboarding',

  // === CRAFT & TECHNICAL HOBBIES ===
  'Woodworking',
  'Blacksmithing',
  'Cooking',
  'Baking',
  'Sewing',
  'Knitting',
  'Gardening',
  'Origami',
  'Lockpicking',
  'Home Brewing',

  // === BUSINESS & PROFESSIONAL SKILLS ===
  'Project Management',
  'Accounting',
  'Finance',
  'Marketing',
  'Sales',
  'Human Resources',
  'Business Strategy',
  'Entrepreneurship',
  'E-commerce',
  'Product Management',
  'Legal Research',

  // === LANGUAGE SKILLS ===
  'English Fluency',
  'Spanish Fluency',
  'Mandarin Fluency',
  'French Fluency',
  'Arabic Fluency',
  'Sign Language',
  'Translation',
  'Transcription',
  'Accent Reduction',

  // === SURVIVAL & PRACTICAL SKILLS ===
  'First Aid',
  'CPR',
  'Fire Starting',
  'Shelter Building',
  'Fishing',
  'Hunting',
  'Navigation (Compass & Stars)',
  'Self-defense',
  'Car Repair',
  'Basic Plumbing',
  'Electrical Repair',
  'Budgeting',
  'Personal Finance',

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
