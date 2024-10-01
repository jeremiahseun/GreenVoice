import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenvoice/src/features/profile/data/profile_provider.dart';
import 'package:greenvoice/src/features/projects/data/projects_provider.dart';
import 'package:greenvoice/src/features/projects/presentation/comments/widget/comment_component.dart';
import 'package:greenvoice/utils/common_widgets/not_logged_in.dart';
import 'package:greenvoice/utils/styles/styles.dart';

class ProjectCommentBottomSheet extends ConsumerStatefulWidget {
  const ProjectCommentBottomSheet(
      {super.key, required this.issueID, this.userImage = ''});

  final String issueID;
  final String userImage;

  @override
  ConsumerState<ProjectCommentBottomSheet> createState() =>
      _ProjectCommentBottomSheetState();
}

class _ProjectCommentBottomSheetState
    extends ConsumerState<ProjectCommentBottomSheet> {
  TextEditingController commentController = TextEditingController();
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNode.requestFocus(); // Request focus for the TextField
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .65,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: ref
                  .read(addProjectProvider.notifier)
                  .getProjectComments(issueID: widget.issueID),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var commentData = snapshot.data!.docs[index].data();
                      return CommentComponent(
                        name: commentData['userName'],
                        message: commentData['message'],
                        image: commentData['userPicture'],
                      );
                    },
                  );
                } else {
                  return const Center(
                    child: Text(
                      "No comments yet",
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }
              },
            ),
          ),
          ref.watch(userProfileProvider).when(
            data: (userData) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage:
                          CachedNetworkImageProvider(widget.userImage),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        focusNode: focusNode,
                        minLines: 1,
                        maxLines: 3,
                        controller: commentController,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: const Icon(
                              Icons.send,
                              color: AppColors.primaryColor,
                            ),
                            onPressed: () async {
                              if (commentController.text.isNotEmpty) {
                                await ref
                                    .read(addProjectProvider.notifier)
                                    .sendUserComment(
                                      issueID: widget.issueID,
                                      message: commentController.text,
                                      context: context,
                                    );
                                commentController.clear();
                              }
                            },
                          ),
                          hintText: 'Add a comment...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade200,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            error: (err, _) {
              return const Padding(
                padding: EdgeInsets.all(8.0),
                child: NotLoggedInWidget(
                  text: 'Login to comment on this project',
                ),
              );
            },
            loading: () {
              return const CircularProgressIndicator();
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }
}
