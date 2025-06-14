import 'package:flutter/material.dart';
import 'package:mindful_youth/utils/method_helpers/shadow_helper.dart';
import 'package:sizer/sizer.dart';

import '../../app_const/app_colors.dart';
import '../../app_const/app_size.dart';
import '../../widgets/custom_container.dart';
import '../../widgets/custom_text.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  // Tracks the currently opened FAQ
  int? openIndex;

  @override
  Widget build(BuildContext context) {
    // Simulated data – replace with Provider data
    final faqList = [
      FaqItem(
        id: 1,
        question: 'What is your return policy?',
        answer: 'You can return items within 30 days.',
      ),
      FaqItem(
        id: 2,
        question: 'How long does shipping take?',
        answer: 'Shipping usually takes 3-5 business days.',
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const CustomText(text: 'FAQs'), centerTitle: true),
      body:
          faqList.isEmpty
              ? const Center(child: Text('No FAQs available.'))
              : ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                itemCount: faqList.length,
                itemBuilder: (context, index) {
                  final faq = faqList[index];
                  final isOpen = openIndex == index;

                  return CustomContainer(
                    margin: EdgeInsets.only(bottom: 2.h),
                    borderRadius: BorderRadius.circular(AppSize.size10),
                    backGroundColor: AppColors.lightWhite,
                    boxShadow: ShadowHelper.simpleShadow,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          setState(() {
                            openIndex = isOpen ? null : index;
                          });
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 3.w,
                            vertical: 1.h,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      faq.question,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    isOpen ? Icons.remove : Icons.add,
                                    size: 22,
                                    color: Colors.black87,
                                  ),
                                ],
                              ),
                              if (isOpen)
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 12,
                                    right: 8,
                                  ),
                                  child: Text(
                                    faq.answer,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade800,
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
    );
  }
}

class FaqItem {
  final int id;
  final String question;
  final String answer;

  FaqItem({required this.id, required this.question, required this.answer});
}
