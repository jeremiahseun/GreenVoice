import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:greenvoice/core/routes/app_router.dart';

class DeepLinking {
  static StreamSubscription? _sub;
  static Future<void> initUniLinks(BuildContext context) async {
    _sub = FlutterBranchSdk.listSession().listen((data) {
      if (data.containsKey('+clicked_branch_link') &&
          data['+clicked_branch_link'] == true) {
        handleDeepLink(data['custom_string'], context);
      }
    }, onError: (error) {
      PlatformException platformException = error as PlatformException;
      print(
          'InitSession error: ${platformException.code} - ${platformException.message}');
    });
  }

  static void handleDeepLink(String link, BuildContext context) {
    // Here, you can navigate to different pages or perform actions based on the URI
    context.push(link);
  }

  static void dispose() {
    _sub?.cancel();
  }
}
