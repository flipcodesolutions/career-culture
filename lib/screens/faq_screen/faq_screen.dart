import 'package:flutter/material.dart';
import 'package:mindful_youth/provider/faqs_provider.dart/faqs_provider.dart';
import 'package:mindful_youth/utils/method_helpers/size_helper.dart';
import 'package:mindful_youth/widgets/cutom_loader.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../app_const/app_colors.dart';
import '../../app_const/app_size.dart';
import '../../app_const/app_strings.dart';
import '../../models/faqs_model/faqs_model.dart';
import '../../utils/text_style_helper/text_style_helper.dart';
import '../../widgets/custom_container.dart';
import '../../widgets/custom_text.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final FaqsProvider faqProvider = context.read<FaqsProvider>();
    Future.microtask(() async {
      await faqProvider.getFAQs(context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final FaqsProvider faqProvider = context.watch<FaqsProvider>();
    final FAQsModel? faQsModel = faqProvider.faqsModel;
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: AppStrings.faq,
          style: TextStyleHelper.mediumHeading,
        ),
      ),
      body:
          faqProvider.isLoading
              ? Center(child: CustomLoader())
              : faQsModel?.data?.isNotEmpty == true
              ? ListView.separated(
                separatorBuilder:
                    (context, index) => SizeHelper.height(height: 1.h),
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                itemCount: faQsModel?.data?.length ?? 0,
                itemBuilder: (context, index) {
                  FAQsModelData? faq = faQsModel?.data?[index];
                  return CustomContainer(
                    backGroundColor: AppColors.white,
                    borderRadius: BorderRadius.circular(AppSize.size10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          borderRadius: BorderRadius.circular(AppSize.size10),
                          onTap:
                              () => faqProvider.toggleIsOpen(id: faq?.id ?? -1),
                          child: CustomContainer(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(AppSize.size10),
                              bottom:
                                  faq?.isOpen != true
                                      ? Radius.circular(AppSize.size10)
                                      : Radius.circular(0),
                            ),
                            padding: EdgeInsets.all(AppSize.size10),
                            backGroundColor: AppColors.faqQuestion,
                            child: Row(
                              children: [
                                Expanded(
                                  child: CustomText(
                                    text: faq?.question ?? "",
                                    useOverflow: false,
                                    style: TextStyleHelper.smallHeading,
                                  ),
                                ),
                                Icon(
                                  faq?.isOpen == true
                                      ? Icons.keyboard_arrow_up_rounded
                                      : Icons.keyboard_arrow_down_rounded,
                                  size: 22,
                                  color: Colors.black87,
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (faq?.isOpen == true)
                          CustomContainer(
                            borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(AppSize.size10),
                            ),
                            padding: EdgeInsets.all(AppSize.size20),
                            backGroundColor: AppColors.faqAnswer,
                            child: CustomText(
                              text: faq?.answer ?? "",
                              useOverflow: false,
                            ),
                          ),
                      ],
                    ),
                  );
                },
              )
              : const Center(child: CustomText(text: 'No FAQs available.')),
    );
  }
}
