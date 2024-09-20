import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:greenvoice/utils/styles/styles.dart';

class AdaptiveImageGrid extends StatelessWidget {
  final List<String> images;
  final void Function(int index) onTap;
  final Size size;

  const AdaptiveImageGrid(
      {super.key,
      required this.images,
      required this.onTap,
      this.size = const Size(400, 400)});

  @override
  Widget build(BuildContext context) {
    int imageCount = images.length;

    if (imageCount == 0) {
      return const SizedBox.shrink();
    } else if (imageCount == 1) {
      return _buildSingleImage();
    } else if (imageCount == 2) {
      return _buildTwoImages();
    } else if (imageCount == 3) {
      return _buildThreeImages();
    } else if (imageCount == 4) {
      return _buildFourImages();
    } else {
      return _buildFiveOrMoreImages();
    }
  }

  Widget _buildSingleImage() {
    return AspectRatio(
      aspectRatio: 1,
      child: InkWell(
          onTap: () => onTap(0), child: _buildImageContainer(images[0], size)),
    );
  }

  Widget _buildTwoImages() {
    return AspectRatio(
      aspectRatio: 2,
      child: Row(
        children: [
          Expanded(
              child: InkWell(
                  onTap: () => onTap(0),
                  child: _buildImageContainer(images[0], size))),
          const Gap(10),
          Expanded(
              child: InkWell(
                  onTap: () => onTap(1),
                  child: _buildImageContainer(images[1], size))),
        ],
      ),
    );
  }

  Widget _buildThreeImages() {
    return AspectRatio(
      aspectRatio: 1.5,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: InkWell(
                onTap: () => onTap(0),
                child: _buildImageContainer(images[0], size)),
          ),
          const Gap(10),
          Expanded(
            child: Column(
              children: [
                Expanded(
                    child: InkWell(
                        onTap: () => onTap(1),
                        child: _buildImageContainer(images[1], size))),
                const Gap(5),
                Expanded(
                    child: InkWell(
                        onTap: () => onTap(2),
                        child: _buildImageContainer(images[2], size))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFourImages() {
    return AspectRatio(
      aspectRatio: 1,
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(child: InkWell(
                        onTap: () => onTap(0),
                        child: _buildImageContainer(images[0], size))),
                const Gap(10),
                Expanded(child: InkWell(
                        onTap: () => onTap(1),
                        child: _buildImageContainer(images[1], size))),
              ],
            ),
          ),
          const Gap(5),
          Expanded(
            child: Row(
              children: [
                Expanded(child: InkWell(
                        onTap: () => onTap(2),
                        child: _buildImageContainer(images[2], size))),
                const Gap(10),
                Expanded(child: InkWell(
                        onTap: () => onTap(3),
                        child: _buildImageContainer(images[3], size))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFiveOrMoreImages() {
    return AspectRatio(
      aspectRatio: 1,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                    child: InkWell(
                        onTap: () => onTap(0),
                        child: _buildImageContainer(images[0], size))),
                const Gap(10),
                Expanded(
                    child: InkWell(
                        onTap: () => onTap(1),
                        child: _buildImageContainer(images[1], size))),
              ],
            ),
          ),
          const Gap(5),
          Expanded(
            child: Row(
              children: [
                Expanded(
                    child: InkWell(
                        onTap: () => onTap(2),
                        child: _buildImageContainer(images[2], size))),
                const Gap(10),
                Expanded(
                    child: InkWell(
                        onTap: () => onTap(3),
                        child: _buildImageContainer(images[3], size))),
                const Gap(10),
                Expanded(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      InkWell(
                          onTap: () => onTap(4),
                          child: _buildImageContainer(images[4], size)),
                      if (images.length > 5)
                        Container(
                          color: Colors.black.withOpacity(0.6),
                          child: Center(
                            child: Text(
                              '+${images.length - 5}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageContainer(String imageUrl, Size size) {
    return Container(
      height: size.height,
      width: size.width,
      decoration: BoxDecoration(
        color: AppColors.lightPrimaryColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          progressIndicatorBuilder: (context, url, downloadProgress) =>
              const Center(child: CircularProgressIndicator.adaptive()),
          errorWidget: (context, url, error) => const Center(
              child: Icon(
            Icons.error,
            color: AppColors.redColor,
          )),
        ),
      ),
    );
  }
}
