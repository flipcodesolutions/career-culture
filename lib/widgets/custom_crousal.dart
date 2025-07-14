import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:mindful_youth/widgets/photo_view.dart';
import 'package:sizer/sizer.dart';
import '../app_const/app_colors.dart';
import '../app_const/app_size.dart';
import '../utils/navigation_helper/navigation_helper.dart';
import 'custom_container.dart';
import 'custom_image.dart';

class CustomCarouselWidget extends StatefulWidget {
  final List<String> imageUrls; // List of image URLs or asset paths
  final bool isImageOnline;
  final double? height; // Height of the carousel
  final bool autoPlay; // Enable/disable auto-play
  final double? viewportFraction; // Fraction of viewport for each item

  const CustomCarouselWidget({
    super.key,
    required this.imageUrls,
    this.height,
    this.autoPlay = true,
    this.viewportFraction,
    this.isImageOnline = true,
  });

  @override
  _CustomCarouselWidgetState createState() => _CustomCarouselWidgetState();
}

class _CustomCarouselWidgetState extends State<CustomCarouselWidget>
    with NavigateHelper {
  int _currentIndex = 0;
  final CarouselSliderController _controller = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Carousel Slider
        CarouselSlider(
          carouselController: _controller,
          options: CarouselOptions(
            height: widget.height,
            autoPlay: widget.autoPlay,
            viewportFraction: widget.viewportFraction ?? 1.0,
            enlargeCenterPage: true,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          items:
              widget.imageUrls.map((imageUrl) {
                return Builder(
                  builder: (BuildContext context) {
                    return InkWell(
                      onTap:
                          () => push(
                            context: context,
                            widget: PhotoViewWidget(imageUrl: imageUrl),
                          ),
                      child: CustomContainer(
                        width: MediaQuery.of(context).size.width,
                        borderRadius: BorderRadius.circular(AppSize.size10),
                        // image: MethodHelper.imageOrNoImage(image: imageUrl),
                        child:
                            widget.isImageOnline
                                ? CustomImageWithLoader(imageUrl: imageUrl)
                                : Image.asset(imageUrl),
                      ),
                    );
                  },
                );
              }).toList(),
        ),
        const SizedBox(height: 8.0),
        // Dots Indicator
        Wrap(
          alignment: WrapAlignment.center,
          direction: Axis.horizontal,
          children:
              widget.imageUrls.asMap().entries.map((entry) {
                return GestureDetector(
                  onTap: () => _controller.animateToPage(entry.key),
                  child: CustomContainer(
                    width: AppSize.size10,
                    height: AppSize.size10,
                    borderWidth: 0.8,
                    margin: EdgeInsets.symmetric(horizontal: 1.w),
                    borderColor: AppColors.primary,
                    shape: BoxShape.circle,
                    backGroundColor:
                        _currentIndex == entry.key
                            ? AppColors.primary
                            : AppColors.white,
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }
}

// Example usage:
/*
class MyHomePage extends StatelessWidget {
  final List<String> images = [
    'https://example.com/image1.jpg',
    'https://example.com/image2.jpg',
    'https://example.com/image3.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Carousel Demo')),
      body: CustomCarouselWidget(
        imageUrls: images,
        height: 250.0,
        autoPlay: true,
        viewportFraction: 0.9,
      ),
    );
  }
}
*/
