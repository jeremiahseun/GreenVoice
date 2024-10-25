import 'dart:developer';

import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:greenvoice/core/routes/routes.dart';
import 'package:greenvoice/src/models/issue/issue_model.dart';
import 'package:greenvoice/src/models/project/project_model.dart';
import 'package:share_plus/share_plus.dart';

class BranchDeeplinkService {
  static BranchUniversalObject _createBUOForIssues(IssueModel issue) {
    log("Creating BUO");
    return BranchUniversalObject(
        canonicalIdentifier: issue.id,
        canonicalUrl: "${NavigateToPage.issueDetails}/${issue.id}",
        title: issue.title,
        imageUrl: issue.images.first,
        contentDescription: issue.description,
        keywords: ['Civic', 'Issues', 'Local', 'Environment', 'Development'],
        publiclyIndex: true,
        locallyIndex: true,
        contentMetadata: BranchContentMetaData()
          ..addCustomMetadata('location', issue.location)
          ..addCustomMetadata('latitude', issue.latitude)
          ..addCustomMetadata(
              'custom_string', '${NavigateToPage.issueDetails}/${issue.id}')
          ..addCustomMetadata('longitude', issue.longitude)
          ..addCustomMetadata('votes', issue.votes.length));
  }

  static BranchUniversalObject _createBUOForProject(ProjectModel project) {
    log("Creating BUO");
    return BranchUniversalObject(
        canonicalIdentifier: project.id,
        canonicalUrl: '${NavigateToPage.projectDetails}/${project.id}',
        title: project.title,
        imageUrl: project.images.first,
        contentDescription: project.description,
        keywords: ['Civic', 'Issues', 'Local', 'Environment', 'Development'],
        publiclyIndex: true,
        locallyIndex: true,
        contentMetadata: BranchContentMetaData()
          ..addCustomMetadata('location', project.location)
          ..addCustomMetadata(
              'custom_string', '${NavigateToPage.projectDetails}/${project.id}')
          ..addCustomMetadata('latitude', project.latitude)
          ..addCustomMetadata('longitude', project.longitude)
          ..addCustomMetadata('votes', project.votes.length));
  }

  static BranchLinkProperties _createLinkProperties() {
    log("Creating LP");
    return BranchLinkProperties(
        feature: 'sharing',
        stage: 'new share',
        tags: ['Civic', 'Issues', 'Local', 'Environment', 'Development']);
  }

  static Future<void> shareIssue(IssueModel issue) async {
    log("Sharing issue");
    final buo = _createBUOForIssues(issue);
    final lp = _createLinkProperties();
    BranchResponse response = await FlutterBranchSdk.getShortUrl(
      buo: buo,
      linkProperties: lp,
    );
    await showNativeShareSheet(response.result, issue.title,
        description:
            'Check out this important issue: ${issue.title}. Your input could make a difference!');
  }

  static Future<void> shareProject(ProjectModel project) async {
    log("Sharing issue");
    final buo = _createBUOForProject(project);
    final lp = _createLinkProperties();
    BranchResponse response = await FlutterBranchSdk.getShortUrl(
      buo: buo,
      linkProperties: lp,
    );
    await showNativeShareSheet(response.result, project.title,
        description:
            "I'd like to invite you to contribute to ${project.title}. Your expertise would be valuable.");
  }

  static Future<void> showNativeShareSheet(String link, String title,
      {required String description}) async {
    await Share.share('$description\n$link', subject: title);
  }
}
