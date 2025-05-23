import 'package:flutter/material.dart';
import 'package:mindful_youth/utils/method_helpers/size_helper.dart';
import 'package:mindful_youth/utils/text_style_helper/text_style_helper.dart';
import 'package:mindful_youth/widgets/custom_image.dart';
import 'package:mindful_youth/widgets/custom_text.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../provider/wall_provider/wall_provider.dart';

class IndividualWallPostScreen extends StatefulWidget {
  final String? slug;
  const IndividualWallPostScreen({super.key, this.slug});

  @override
  State<IndividualWallPostScreen> createState() =>
      _IndividualWallPostScreenState();
}

class _IndividualWallPostScreenState extends State<IndividualWallPostScreen> {
  @override
  Widget build(BuildContext context) {
    WallProvider wallProvider = context.watch<WallProvider>();
    return Scaffold(
      appBar: AppBar(title: CustomText(text: "${widget.slug}")),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: CustomImageWithLoader(
                imageUrl:
                    "https://plus.unsplash.com/premium_photo-1675237625804-25deee797cf7?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
              ),
            ),
            SizeHelper.height(),
            Padding(
              padding: EdgeInsets.only(left: 5.w),
              child: CustomText(
                text: "Title Title Title Title Title Title",
                style: TextStyleHelper.mediumHeading,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 5.w),
              child: CustomText(
                text: "10 Like",
                style: TextStyleHelper.smallText,
              ),
            ),
            SizeHelper.height(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: CustomText(
                text:
                    "SliverAnimatedList in Flutter works similarly to AnimatedList, but it's used inside a CustomScrollView with other    sliver widgets. It allows for inserting and removing list items with animations. It requires managing an internal SliverAnimatedListState and using the right API to trigger animations.\n\nSliverAnimatedList in Flutter works similarly to AnimatedList, but it's used inside a CustomScrollView with other    sliver widgets. It allows for inserting and removing list items with animations. It requires managing an internal SliverAnimatedListState and using the right API to trigger animations.\n\nSliverAnimatedList in Flutter works similarly to AnimatedList, but it's used inside a CustomScrollView with other    sliver widgets. It allows for inserting and removing list items with animations. It requires managing an internal SliverAnimatedListState and using the right API to trigger animations.\n\nSliverAnimatedList in Flutter works similarly to AnimatedList, but it's used inside a CustomScrollView with other    sliver widgets. It allows for inserting and removing list items with animations. It requires managing an internal SliverAnimatedListState and using the right API to trigger animations.\n\nSliverAnimatedList in Flutter works similarly to AnimatedList, but it's used inside a CustomScrollView with other    sliver widgets. It allows for inserting and removing list items with animations. It requires managing an internal SliverAnimatedListState and using the right API to trigger animations.\n\nSliverAnimatedList in Flutter works similarly to AnimatedList, but it's used inside a CustomScrollView with other    sliver widgets. It allows for inserting and removing list items with animations. It requires managing an internal SliverAnimatedListState and using the right API to trigger animations.\n\n",
                style: TextStyleHelper.smallText,
                useOverflow: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
