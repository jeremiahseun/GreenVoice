import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:greenvoice/src/features/issues/views/add_issue.dart';
import 'package:greenvoice/src/features/issues/widgets/category_tabs.dart';
import 'package:greenvoice/src/features/issues/widgets/issue_card.dart';
import 'package:greenvoice/utils/styles/styles.dart';

class IssuesScreen extends StatefulWidget {
  const IssuesScreen({super.key});

  @override
  _IssuesScreenState createState() => _IssuesScreenState();
}

class _IssuesScreenState extends State<IssuesScreen> {
  bool isExtended = true;
  late ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            expandedHeight: 100,
            pinned: true,
            backgroundColor: Theme.of(context).colorScheme.surface,
            shadowColor: Colors.transparent,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: IconButton(
                  icon: const Icon(EvaIcons.search),
                  onPressed: () {},
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Issues',
                style: AppStyles.blackBold18,
              ),
            ),
          ),
          const SliverPadding(
            padding: EdgeInsets.all(16.0),
            sliver: SliverToBoxAdapter(child: CategoryTabs()),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverList.list(
              children: const [
                IssueCard(
                  title: 'Traffic on 5th and Mission',
                  location: 'San Francisco, CA',
                  votes: '1.2k',
                  rating: 3.5,
                  reviewCount: 12,
                  imageUrls: [
                    'https://picsum.photos/400',
                    'https://picsum.photos/400',
                    'https://picsum.photos/400',
                  ],
                ),
                SizedBox(height: 16),
                IssueCard(
                  title: 'Need more dog parks',
                  location: 'Los Angeles, CA',
                  votes: '1.1k',
                  rating: 4.5,
                  reviewCount: 55,
                  imageUrls: [
                    'https://picsum.photos/400',
                  ],
                ),
                SizedBox(height: 16),
                IssueCard(
                  title: 'Need more dog parks',
                  location: 'Los Angeles, CA',
                  votes: '1.1k',
                  rating: 4.5,
                  reviewCount: 55,
                  imageUrls: [
                    'https://picsum.photos/400',
                    'https://picsum.photos/400',
                  ],
                ),
                SizedBox(height: 16),
                IssueCard(
                  title: 'Need more dog parks',
                  location: 'Los Angeles, CA',
                  votes: '1.1k',
                  rating: 4.5,
                  reviewCount: 55,
                  imageUrls: [
                    'https://picsum.photos/400',
                    'https://picsum.photos/400',
                    'https://picsum.photos/id/236/536/354',
                    'https://picsum.photos/id/235/536/354',
                    'https://picsum.photos/id/234/536/354',
                    'https://picsum.photos/id/233/536/354',
                  ],
                ),
                SizedBox(height: 16),
                IssueCard(
                  title: 'Need more dog parks',
                  location: 'Los Angeles, CA',
                  votes: '1.1k',
                  rating: 4.5,
                  reviewCount: 55,
                  imageUrls: [
                    'https://picsum.photos/400',
                    'https://picsum.photos/400',
                    'https://picsum.photos/400',
                    'https://picsum.photos/400',
                    'https://picsum.photos/id/237/536/354',
                    'https://picsum.photos/id/236/536/354',
                    'https://picsum.photos/id/235/536/354',
                    'https://picsum.photos/id/234/536/354',
                    'https://picsum.photos/id/233/536/354',
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ReportIssueScreen(),
            ),
          );
        },
        isExtended: isExtended,
        label: Text(
          'Report Issue',
          style: AppStyles.blackBold14.copyWith(color: AppColors.whiteColor),
        ),
        icon: const Icon(Icons.add, color: AppColors.whiteColor),
        backgroundColor: AppColors.primaryColor,
      ),
    );
  }
}
