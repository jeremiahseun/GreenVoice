import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:greenvoice/core/routes/app_router.dart';
import 'package:greenvoice/core/routes/routes.dart';
import 'package:greenvoice/src/features/profile/data/profile_provider.dart';
import 'package:greenvoice/src/models/issue/issue_model.dart';
import 'package:greenvoice/utils/common_widgets/green_voice_button.dart';
import 'package:greenvoice/utils/helpers/date_formatter.dart';
import 'package:greenvoice/utils/styles/styles.dart';

import 'profile_loading.dart';

final isLoggedInProvider = StateProvider<bool>((ref) => false);

class ProfileView extends ConsumerStatefulWidget {
  const ProfileView({super.key});

  @override
  ConsumerState<ProfileView> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileView> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ref.read(userProfileProvider).hasValue &&
          ref.read(userProfileProvider).value != null) {
        return;
      }
      ref.read(userProfileProvider.notifier).getCurrentUserProfile();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(userProfileProvider).when(data: (data) {
      return const LoggedInProfile();
    }, error: (err, _) {
      return const LoginPrompt();
    }, loading: () {
      return const ProfileLoadingWidget();
    });
  }
}

class LoginPrompt extends ConsumerWidget {
  const LoginPrompt({super.key});

  @override
  Widget build(context, ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: RefreshIndicator.adaptive(
        onRefresh: () async {
          ref.read(userProfileProvider.notifier).getCurrentUserProfile();
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Login to report issues and create community projects',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
              const Gap(20),
              GreenVoiceButton.outline(
                  onTap: () => context.push(NavigateToPage.login),
                  title: "Login"),
            ],
          ),
        ),
      ),
    );
  }
}

class LoggedInProfile extends ConsumerWidget {
  const LoggedInProfile({super.key});

  @override
  Widget build(context, ref) {
    return Scaffold(
      body: RefreshIndicator.adaptive(
        onRefresh: () async {
          ref.read(userProfileProvider.notifier).getCurrentUserProfile();
        },
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 50,
              title: Text(
                'Profile',
                style: AppStyles.blackBold18,
              ),
              pinned: true,
              centerTitle: true,
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16.0),
              sliver: SliverToBoxAdapter(
                child: Column(
                  children: [
                    ref.watch(userProfileProvider).when(
                          loading: () =>
                              const CircularProgressIndicator.adaptive(),
                          error: (error, _) {
                            return const SizedBox();
                          },
                          data: (profile) => ProfileHeader(
                            firstName: profile?.firstName ?? '',
                            lastName: profile?.lastName ?? '',
                            image: profile?.photo,
                            edit: () {
                              context.push(
                                NavigateToPage.editProfile,
                                extra: EditProfileArgument(
                                    firstName: profile?.firstName ?? '',
                                    lastName: profile?.lastName ?? '',
                                    email: profile?.email ?? '',
                                    image: profile?.photo ?? '',
                                    phoneNumber: profile?.phoneNumber ?? ''),
                              );
                            },
                          ),
                        ),
                    const Gap(20),
                    Align(
                      alignment: Alignment.topLeft,
                      child:
                          Text('Issues Reported', style: AppStyles.blackBold20),
                    ),
                    const Gap(20),
                    Text('Coming soon...', style: AppStyles.blackNormal14),
                    const Gap(20),
                    Align(
                      alignment: Alignment.topLeft,
                      child:
                          Text('Voting History', style: AppStyles.blackBold20),
                    ),
                    const Gap(20),
                    Text('Coming soon...', style: AppStyles.blackNormal14),
                    const Gap(50),
                    GreenVoiceButton.red(
                        onTap: () async {
                          ref.read(profileProvider.notifier).exitApp();
                          context.go(NavigateToPage.login);
                        },
                        title: 'Log out'),
                    const Gap(50),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  final String firstName;
  final String lastName;

  final String? image;
  final void Function()? edit;
  const ProfileHeader({
    super.key,
    required this.firstName,
    required this.lastName,
    this.image,
    this.edit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 110,
          width: 120,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: image == null
                      ? const AssetImage('assets/images/food.jpg')
                      : CachedNetworkImageProvider(image!),
                  fit: BoxFit.cover),
              borderRadius: BorderRadius.circular(15),
              color: AppColors.primaryColor),
        ),
        const Gap(10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$firstName, ${lastName.split("").first}',
              style: AppStyles.blackBold24,
            ),
            IconButton(
                onPressed: edit,
                icon: const Icon(
                  Icons.edit_outlined,
                  size: 20,
                  color: AppColors.redColor,
                ))
          ],
        ),
      ],
    );
  }
}

class ActionButtons extends StatelessWidget {
  const ActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ActionButton(title: 'Issues Reported', onPressed: () {}),
        ActionButton(title: 'Votes', onPressed: () {}),
        ActionButton(title: 'Settings', onPressed: () {}),
      ],
    );
  }
}

class ActionButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const ActionButton({super.key, required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(title),
    );
  }
}

class IssuesReported extends StatelessWidget {
  final List<IssueModel>? issues;
  const IssuesReported({super.key, this.issues});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Issues Reported', style: AppStyles.blackBold20),
          Visibility(
            visible: issues != null && issues!.isNotEmpty,
            child: Text("${issues?.length}", style: AppStyles.blackBold20),
          )
        ]),
        const Gap(10),
        Visibility(
            visible: issues != null && issues!.isNotEmpty,
            replacement: const Text("No issues reported."),
            child: Column(
              children: issues
                      ?.map<IssueItem>((issue) => IssueItem(
                          title: issue.title,
                          date: DateFormatter.formatDate(issue.createdAt),
                          onTap: () {}))
                      .take(3)
                      .toList() ??
                  [],
            )),
        Visibility(
          visible: issues != null && issues!.isNotEmpty && issues!.length > 3,
          child: Align(
            alignment: Alignment.topRight,
            child: TextButton.icon(
              iconAlignment: IconAlignment.end,
              onPressed: () {},
              label: const Text("View all"),
              icon: const Icon(Icons.arrow_forward_ios_outlined, size: 12),
            ),
          ),
        ),
      ],
    );
  }
}

class IssueItem extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final String date;

  const IssueItem(
      {super.key,
      required this.onTap,
      required this.title,
      required this.date});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: const Icon(Icons.check_circle_outline),
      title: Text(title),
      subtitle: Text('Reported on $date'),
      trailing: const Icon(Icons.chevron_right),
    );
  }
}

class VotingHistory extends StatelessWidget {
  final List<Map<String, dynamic>> votes;

  const VotingHistory({super.key, required this.votes});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Voting History',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Visibility(
              visible: votes.isNotEmpty,
              child: Text("${votes.length}", style: AppStyles.blackBold20),
            )
          ],
        ),
        const Gap(10),
        Column(
            children: votes
                .map((vote) => InkWell(
                      onTap: () {
                        if (vote['isIssues'] as bool) {
                          context.push(
                              "${NavigateToPage.issueDetails}/${vote['id']}");
                        } else {
                          context.push(
                              "${NavigateToPage.projectDetails}/${vote['id']}");
                        }
                      },
                      child: VoteItem(
                          title: vote['title'],
                          date: 'Voted on ${vote['date']}'),
                    ))
                .take(3)
                .toList())
      ],
    );
  }
}

class VoteItem extends StatelessWidget {
  final String title;
  final String date;

  const VoteItem({super.key, required this.title, required this.date});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.check_circle_outline),
      title: Text(title),
      subtitle: Text(date),
      trailing: const Icon(Icons.chevron_right),
    );
  }
}
