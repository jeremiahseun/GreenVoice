import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:greenvoice/core/routes/app_router.dart';
import 'package:uni_links2/uni_links.dart';

class DeepLinking {
  static StreamSubscription? _sub;
  static Future<void> initUniLinks(BuildContext context) async {
    // Handle incoming links - uni_links package
    _sub = uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        handleDeepLink(uri, context); // Call the method correctly here
      }
    }, onError: (err) {
      // Handle exception by warning the user their action did not succeed
      print('Failed to get latest uri: $err');
    });

    // Handle any initial links
    try {
      final initialUri = await getInitialUri();
      if (initialUri != null) {
        handleDeepLink(initialUri, context); // Call the method correctly here
      }
    } on PlatformException catch (e) {
      print('Failed to get initial uri: ${e.message}');
    }
  }

  static void handleDeepLink(Uri uri, BuildContext context) {
    // Here, you can navigate to different pages or perform actions based on the URI
    print('Received URI: $uri');
    final addressList = uri.toString().split("//");
    context.push("/${addressList[1]}");
  }

  static void dispose() {
    _sub?.cancel();
  }
}
