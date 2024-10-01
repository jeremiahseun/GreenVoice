import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:greenvoice/src/models/issue/issue_model.dart';
import 'package:greenvoice/src/models/project/project_model.dart';
import 'package:greenvoice/src/models/socials/comment.dart';
import 'package:greenvoice/src/models/user/user_model.dart';

class FirestoreStrings {
  static const String users = "users";
  static const String issues = "issues";
  static const String projects = "projects";
  static const String userComments = 'userComments';
}

class FirebaseFirestoreService {
  final db = FirebaseFirestore.instance;

  //? USERS
  //* Get a User
  Future<(bool status, String message, UserModel? user)> getUser(
      String userId) async {
    try {
      final snapshot =
          await db.collection(FirestoreStrings.users).doc(userId).get();
      if (snapshot.exists) {
        final user = UserModel.fromMap(snapshot.data());
        return (true, "User gotten successfully", user);
      } else {
        return (false, "User not found", null);
      }
    } catch (e) {
      log("Error getting user: $e");
      return (false, "$e", null);
    }
  }

  //* Create a new user
  Future<(bool status, String message)> createUser(UserModel user) async {
    try {
      await db
          .collection(FirestoreStrings.users)
          .doc(user.uid)
          .set(user.toMap());
      return (true, "User created successfully");
    } catch (e) {
      log("Error creating user: $e");
      return (false, "$e");
    }
  }

  //* Edit a user
  Future<(bool status, String message)> updateUser(UserModel user) async {
    try {
      await db
          .collection(FirestoreStrings.users)
          .doc(user.uid)
          .update(user.toMap());
      return (true, "User updated successfully");
    } catch (e) {
      log("Error updating user: $e");
      return (false, "$e");
    }
  }

  //* Delete a user
  Future<(bool status, String message)> deleteUser(String userId) async {
    try {
      await db.collection(FirestoreStrings.users).doc(userId).delete();
      return (true, "User deleted successfully");
    } catch (e) {
      log("Error deleting user: $e");
      return (false, "$e");
    }
  }

  //? ISSUES
  //* Get an Issue
  Future<(bool status, String message, IssueModel? issue)> getIssue(
      String issueId) async {
    try {
      final snapshot =
          await db.collection(FirestoreStrings.issues).doc(issueId).get();
      if (snapshot.exists && snapshot.data() != null) {
        final issue = IssueModel.fromMap(snapshot.data()!);
        return (true, "Issue gotten successfully", issue);
      } else {
        return (false, "Issue not found", null);
      }
    } catch (e) {
      log("Error getting issue: $e");
      return (false, "$e", null);
    }
  }

  //* Get all issues
  Future<(bool status, String message, List<IssueModel>? issues)>
      getAllIssues() async {
    try {
      final snapshot = await db
          .collection(FirestoreStrings.issues)
          .orderBy('createdAt', descending: true)
          .get()
          .timeout(const Duration(seconds: 15),
              onTimeout: () =>
                  throw TimeoutException('Firestore connection timeout'));
      if (snapshot.docs.isNotEmpty) {
        final issues =
            snapshot.docs.map((doc) => IssueModel.fromMap(doc.data())).toList();
        return (true, "Issues gotten successfully", issues);
      } else {
        return (false, "No issues found", null);
      }
    } catch (e) {
      log("Error getting issues: $e");
      return (false, "$e", null);
    }
  }

  //* Create a new issue
  Future<(bool status, String message)> createIssue(IssueModel issue) async {
    try {
      final docRef =
          await db.collection(FirestoreStrings.issues).add(issue.toMap());
      await docRef.update({'id': docRef.id});
      return (true, "Issue created successfully");
    } catch (e) {
      log("Error creating issue: $e");
      return (false, "$e");
    }
  }

  //* Create a comment
  Future<(bool status, String message)> createComments(
      CommentModel comments, String issueID, String messageID) async {
    try {
      await db
          .collection(FirestoreStrings.issues)
          .doc(issueID)
          .collection(FirestoreStrings.userComments)
          .doc(messageID)
          .set(comments.toMap(), SetOptions(merge: true));

      return (true, "Comment created successfully");
    } catch (e) {
      log("Error creating comments: $e");
      return (false, "$e");
    }
  }

  //*  PROJECT COMMENTS

  Future<(bool status, String message)> createProjectComments(
      CommentModel comments, String projectID, String messageID) async {
    try {
      await db
          .collection(FirestoreStrings.projects)
          .doc(projectID)
          .collection(FirestoreStrings.userComments)
          .doc(messageID)
          .set(comments.toMap(), SetOptions(merge: true));

      return (true, "Comment created successfully");
    } catch (e) {
      log("Error creating comments: $e");
      return (false, "$e");
    }
  }

  //* Get projectComments
  Stream<QuerySnapshot<Map<String, dynamic>>> getProjectComments(
    String projectID,
  ) async* {
    final getMessages = db
        .collection(FirestoreStrings.projects)
        .doc(projectID)
        .collection(FirestoreStrings.userComments)
        .orderBy('createdAt', descending: false)
        .snapshots();
    yield* getMessages;
  }

//* GET COMMENTS

  Stream<QuerySnapshot<Map<String, dynamic>>> getChatMessages(
    String issueID,
  ) async* {
    final getMessages = db
        .collection(FirestoreStrings.issues)
        .doc(issueID)
        .collection(FirestoreStrings.userComments)
        .orderBy('createdAt', descending: false)
        .snapshots();
    yield* getMessages;
  }

  //* Edit your issue
  Future<(bool status, String message)> updateIssue(IssueModel issue) async {
    try {
      await db
          .collection(FirestoreStrings.issues)
          .doc(issue.id)
          .update(issue.toMap().putIfAbsent('updatedAt', () => DateTime.now()));
      return (true, "Issue updated successfully");
    } catch (e) {
      log("Error updating issue: $e");
      return (false, "$e");
    }
  }

  //* Like an issue
  Future<(bool status, String message)> likeAndUnlikeIssue(
      String issueId, String userId) async {
    try {
      final docRef = db.collection(FirestoreStrings.issues).doc(issueId);
      final docSnapshot = await docRef.get();

      if (docSnapshot.exists && docSnapshot.data() != null) {
        final issue = IssueModel.fromMap(docSnapshot.data()!);
        final updatedVotes = issue.votes;
        if (updatedVotes.contains(userId)) {
          //* It means the user has already voted.
          updatedVotes.remove(userId);
        } else {
          //* It means the user has not voted
          updatedVotes.add(userId);
        }
        await docRef
            .update({'votes': updatedVotes, 'updatedAt': DateTime.now()});
        return (true, "Issue liked successfully");
      } else {
        return (false, "Issue not found");
      }
    } catch (e) {
      log("Error liking issue: $e");
      if (e.toString().contains("permission")) {
        return (false, "You need to be logged in before you can vote.");
      }
      return (false, "$e");
    }
  }

  //* Resolve Issue
  Future<(bool status, String message)> resolveIssue(
      String issueId, bool isResolved) async {
    try {
      await db
          .collection(FirestoreStrings.issues)
          .doc(issueId)
          .update({'isResolved': isResolved});
      return (true, "Issue resolved successfully");
    } catch (e) {
      log("Error resolving issue: $e");
      return (false, "$e");
    }
  }

  //? PROJECTS
  //* Get a Project
  Future<(bool status, String message, ProjectModel? project)> getProject(
      String projectId) async {
    try {
      final snapshot =
          await db.collection(FirestoreStrings.projects).doc(projectId).get();
      if (snapshot.exists && snapshot.data() != null) {
        final project = ProjectModel.fromMap(snapshot.data()!);
        return (true, "Project gotten successfully", project);
      } else {
        return (false, "Project not found", null);
      }
    } catch (e) {
      log("Error getting project: $e");
      return (false, "$e", null);
    }
  }

  //* Get all projects
  Future<(bool status, String message, List<ProjectModel>? projects)>
      getAllProjects() async {
    try {
      final snapshot = await db
          .collection(FirestoreStrings.projects)
          .orderBy('createdAt', descending: true)
          .get()
          .timeout(const Duration(seconds: 15),
              onTimeout: () =>
                  throw TimeoutException('Firestore connection timeout'));
      if (snapshot.docs.isNotEmpty) {
        final projects = snapshot.docs
            .map((doc) => ProjectModel.fromMap(doc.data()))
            .toList();
        return (true, "Projects gotten successfully", projects);
      } else {
        return (false, "No project found", null);
      }
    } catch (e) {
      log("Error getting Project: $e");
      return (false, "$e", null);
    }
  }

  //* Create a new project
  Future<(bool status, String message)> createProject(
      ProjectModel project) async {
    try {
      final docRef =
          await db.collection(FirestoreStrings.projects).add(project.toMap());
      await docRef.update({'id': docRef.id});
      return (true, "Project created successfully");
    } catch (e) {
      log("Error creating project: $e");
      return (false, "$e");
    }
  }

  //* Like a project
  Future<(bool status, String message)> likeAndUnlikeProject(
      String projectId, String userId) async {
    try {
      final docRef = db.collection(FirestoreStrings.projects).doc(projectId);
      final docSnapshot = await docRef.get();

      if (docSnapshot.exists && docSnapshot.data() != null) {
        final issue = ProjectModel.fromMap(docSnapshot.data()!);
        final updatedVotes = issue.votes;
        if (updatedVotes.contains(userId)) {
          //* It means the user has already voted.
          updatedVotes.remove(userId);
        } else {
          //* It means the user has not voted
          updatedVotes.add(userId);
        }
        await docRef.update({'votes': updatedVotes});
        return (true, "Project liked successfully");
      } else {
        return (false, "Project not found");
      }
    } catch (e) {
      log("Error liking project: $e");
      if (e.toString().contains("permission")) {
        return (false, "You need to be logged in before you can vote.");
      }
      return (false, "$e");
    }
  }
}
