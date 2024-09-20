import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:greenvoice/utils/styles/styles.dart';

class FullscreenImageCarousel extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;

  const FullscreenImageCarousel({
    super.key,
    required this.imageUrls,
    this.initialIndex = 0,
  });

  @override
  _FullscreenImageCarouselState createState() =>
      _FullscreenImageCarouselState();
}

class _FullscreenImageCarouselState extends State<FullscreenImageCarousel> {
  late int _currentIndex;
  late CarouselSliderController _carouselController;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _carouselController = CarouselSliderController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          CarouselSlider(
            items: widget.imageUrls.map((url) {
              return InteractiveViewer(
                minScale: 0.5,
                maxScale: 3.0,
                child: Image.network(
                  url,
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                        child: Icon(Icons.error, color: Colors.red));
                  },
                ),
              );
            }).toList(),
            carouselController: _carouselController,
            options: CarouselOptions(
              height: MediaQuery.of(context).size.height,
              viewportFraction: 1.0,
              enlargeCenterPage: false,
              enableInfiniteScroll: false,
              initialPage: widget.initialIndex,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(
                  Icons.close,
                  color: AppColors.whiteColor,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.imageUrls.asMap().entries.map((entry) {
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(
                      _currentIndex == entry.key ? 0.9 : 0.4,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

void showImageCarousel(BuildContext context, List<String> imageUrls,
    {int initialIndex = 0}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return FullscreenImageCarousel(
        imageUrls: imageUrls,
        initialIndex: initialIndex,
      );
    },
  );
}
