import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:greenvoice/core/routes/app_router.dart';
import 'package:greenvoice/core/routes/routes.dart';
import 'package:greenvoice/utils/common_widgets/custom_textfield.dart';
import 'package:greenvoice/utils/common_widgets/project_stats.dart';
import 'package:greenvoice/utils/common_widgets/rich_text_widget.dart';
import 'package:greenvoice/utils/styles/styles.dart';

class ProjectScreen extends ConsumerStatefulWidget {
  const ProjectScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProjectScreenState();
}

class _ProjectScreenState extends ConsumerState<ProjectScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                hintText: 'Search Projects',
                controller: TextEditingController(),
                keyboardType: TextInputType.name,
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppColors.greyColor,
                ),
              ),
              const Gap(10),
              ListTile(
                contentPadding: const EdgeInsets.all(0),
                leading: const Icon(Icons.location_on_outlined),
                title: Text(
                  'Proposed Projects',
                  style: AppStyles.blackBold15,
                ),
                trailing: const Icon(
                  Icons.search,
                  color: AppColors.blackColor,
                ),
              ),
              const Gap(20),
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (context, index) => const Gap(25),
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        InkWell(
                          onTap: () {
                          //  context.push(NavigateToPage.projectDetails);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: AppColors.whiteColor,
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0xfff2efed),
                                  blurRadius: 15,
                                  spreadRadius: 1,
                                  offset: Offset(0, 10),
                                ),
                              ],
                            ),
                            height: 390,
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 200,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    image: const DecorationImage(
                                      image:
                                          AssetImage('assets/images/food.jpg'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const Gap(10),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Build a new public Restaurant',
                                        style: AppStyles.blackBold15,
                                      ),
                                      const Gap(10),
                                      const Text(
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 4,
                                        'Lorem ipsum dolor sit amet consectetur adipisicing elit. Molestias, dolorum, doloribus sunt dicta, officia voluptatibus libero necessitatibus natus impedit quam ullam assumenda? Id atque iste consectetur. Commodi odit ab saepe!',
                                      ),
                                      const Gap(10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          RichTextWidget(
                                            ontap: () {},
                                            text: 'Status:',
                                            subText: ' Open for Voting',
                                          ),
                                          InkWell(
                                            onTap: () {},
                                            child: Container(
                                              alignment: Alignment.center,
                                              width: 70,
                                              height: 30,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color:
                                                      AppColors.primaryColor),
                                              child: Text(
                                                'Vote',
                                                style: AppStyles.blackBold12
                                                    .copyWith(
                                                  color: AppColors.whiteColor,
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        const Gap(20),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ProjectStats(
                              data: '30',
                              icon: Icon(
                                Icons.arrow_upward,
                              ),
                            ),
                            ProjectStats(
                              data: '30',
                              icon: Icon(
                                Icons.message_outlined,
                              ),
                            ),
                            ProjectStats(
                              data: '30',
                              icon: Icon(
                                Icons.stacked_line_chart_sharp,
                              ),
                            ),
                          ],
                        )
                      ],
                    );
                  },
                  itemCount: 5,
                ),
              )
            ],
          ),

        ),
      ),
    );
  }
}
