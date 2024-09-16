import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:greenvoice/utils/common_widgets/data_box.dart';
import 'package:greenvoice/utils/common_widgets/green_voice_button.dart';
import 'package:greenvoice/utils/styles/styles.dart';

class ProjectDetailsView extends ConsumerWidget {
  const ProjectDetailsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Project',
          style: AppStyles.blackBold18,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/food.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Community Garden',
                    style: AppStyles.blackBold22,
                  ),
                  const Gap(15),
                  Text(
                    'We need to build a garden so we can enjoy healthy foods like this. How far, Eljoy you no reason am?',
                    style: AppStyles.blackSemi17,
                  ),
                  const Gap(25),
                  const Row(
                    children: [
                      Expanded(child: DataBox(title: 'Votes', data: '6,000')),
                      Gap(10),
                      Expanded(child: DataBox(title: 'Days Left', data: '60')),
                    ],
                  ),
                  const Gap(15.0),
                  const DataBox(
                    title: 'Funding',
                    data: '\$60',
                    isLargeBox: true,
                  ),
                  const Gap(10),
                  ListTile(
                    contentPadding: const EdgeInsets.all(0),
                    leading: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.lightPrimaryColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.calendar_month)),
                    title: Text(
                      'Voting Ends in 60 days',
                      style: AppStyles.blackBold16,
                    ),
                    subtitle: Text(
                      'Dec 10, 2020',
                      style: AppStyles.blackNormal14,
                    ),
                    trailing: SizedBox(
                      width: 120.0,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 90,
                            child: LinearProgressIndicator(
                              value: 0.6,
                              backgroundColor: AppColors.lightPrimaryColor,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          const Gap(10),
                          Text(
                            '60',
                            style: AppStyles.blackNormal12,
                          )
                        ],
                      ),
                    ),
                  ),
                  const Gap(40.0),
                  Row(
                    children: [
                      Expanded(
                        child: GreenVoiceButton.fill(
                          onTap: () {},
                          title: "Vote",
                        ),
                      ),
                      const Gap(15.0),
                      Expanded(
                        child: GreenVoiceButton.outline(
                          onTap: () {},
                          title: "Share",
                        ),
                      )
                    ],
                  ),
                  const Gap(30.0),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
