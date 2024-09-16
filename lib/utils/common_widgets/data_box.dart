import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:greenvoice/utils/styles/styles.dart';

class DataBox extends StatelessWidget {
  const DataBox({
    super.key,
    required this.title,
    required this.data,
    this.isLargeBox = false,
  });

  final String title;
  final String data;
  final bool isLargeBox;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      width: isLargeBox ? double.infinity : 0,
      padding: EdgeInsets.only(
        left: 20,
        right: isLargeBox ? 0 : 20,
        top: 20,
        bottom: 20,
      ),
      decoration: BoxDecoration(
          color: AppColors.lightPrimaryColor,
          borderRadius: BorderRadius.circular(8)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppStyles.blackSemi17,
          ),
          const Gap(10),
          Text(
            data,
            style: AppStyles.blackBold20,
          )
        ],
      ),
    );
  }
}
