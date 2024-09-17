import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:greenvoice/src/models/issue/issue_model.dart';
import 'package:greenvoice/src/models/user/user_model.dart';

class FirestoreStrings {
  static const String users = "users";
  static const String issues = "issues";
}

class FirebaseFirestoreService {
  final db = FirebaseFirestore.instance;

  //? USERS
  //* Get a User
  Future<(bool status, String message, UserModel? user)> getUser(String userId) async {
    try {
     final snapshot = await db
          .collection(FirestoreStrings.users).doc(userId).get();
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
      if (snapshot.exists) {
        final issue = IssueModel.fromMap(snapshot.data());
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
      final snapshot = await db.collection(FirestoreStrings.issues).get();
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

  //* Edit your issue
  Future<(bool status, String message)> updateIssue(IssueModel issue) async {
    try {
      await db
          .collection(FirestoreStrings.issues)
          .doc(issue.id)
          .update(issue.toMap());
      return (true, "Issue updated successfully");
    } catch (e) {
      log("Error updating issue: $e");
      return (false, "$e");
    }
  }

  //* Like an issue
  Future<(bool status, String message)> likeIssue(
      String issueId, String userId) async {
    try {
      final docRef = db.collection(FirestoreStrings.issues).doc(issueId);
      final docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        final issue = IssueModel.fromMap(docSnapshot.data());
        final updatedVotes = issue.votes + 1;

        await docRef.update({'votes': updatedVotes});
        return (true, "Issue liked successfully");
      } else {
        return (false, "Issue not found");
      }
    } catch (e) {
      log("Error liking issue: $e");
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
}
