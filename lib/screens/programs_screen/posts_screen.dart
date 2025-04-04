import 'package:flutter/material.dart';
import 'package:mindful_youth/app_const/app_colors.dart';
import 'package:mindful_youth/provider/programs_provider/post_provider/post_provider.dart';
import 'package:mindful_youth/screens/programs_screen/individual_program_screen.dart';
import 'package:mindful_youth/widgets/custom_container.dart';
import 'package:mindful_youth/widgets/custom_text.dart';
import 'package:mindful_youth/widgets/cutom_loader.dart';
import 'package:mindful_youth/widgets/no_data_found.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../app_const/app_strings.dart';
import '../../models/post_models/post_model.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({
    super.key,
    required this.chapterId,
    required this.chapterName,
  });
  final int chapterId;
  final String chapterName;
  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  @override
  void initState() {
    PostProvider postProvider = context.read<PostProvider>();
    // TODO: implement initState
    super.initState();
    Future.microtask(() {
      postProvider.getPostById(
        context: context,
        id: widget.chapterId.toString(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    PostProvider postProvider = context.watch<PostProvider>();
    return Scaffold(
      appBar: AppBar(
        /// if only one post
        title: CustomText(
          text:
              postProvider.postListModel?.data?.length == 1
                  ? (postProvider.postListModel?.data?[0].title ?? "")
                  : widget.chapterName,
        ),
      ),
      body:
          postProvider.isLoading
              ? Center(child: CustomLoader())
              : postProvider.postListModel?.data?.isNotEmpty == true
              ? postProvider.postListModel?.data?.length == 1
                  ? SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: Column(
                      children: [
                        ImageContainer(
                          image:
                              "${AppStrings.assetsUrl}${postProvider.postListModel?.data?[0].image}",
                        ),
                        CustomText(
                          text:
                              postProvider
                                  .postListModel
                                  ?.data?[0]
                                  .description ??
                              "",
                          useOverflow: false,
                        ),
                      ],
                    ),
                  )
                  : ListView.builder(
                    shrinkWrap: true,
                    itemCount: postProvider.postListModel?.data?.length,
                    itemBuilder: (context, index) {
                      PostInfo? post = postProvider.postListModel?.data?[index];
                      return CustomContainer(
                        height: 30.h,
                        backGroundColor: AppColors.lightWhite,
                        child: Stack(
                          children: [
                            ImageContainer(
                              image: "${AppStrings.assetsUrl}${post?.image}",
                            ),
                            CustomContainer(
                              padding: EdgeInsets.symmetric(horizontal: 5.w),
                              alignment: Alignment.bottomLeft,
                              child: CustomText(text: post?.title ?? ""),
                            ),
                          ],
                        ),
                      );
                    },
                  )
              : ListView(children: [NoDataFoundWidget(height: 80.h)]),
    );
  }
}
