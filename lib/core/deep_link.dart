import 'dart:async';

import 'package:flutter/services.dart';
import 'package:uni_links2/uni_links.dart';

class DeepLinking {
 static StreamSubscription? _sub;
 static Future<void> initUniLinks() async {
    // Handle incoming links - uni_links package
    _sub = uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        handleDeepLink(uri);
      }
    }, onError: (err) {
      // Handle exception by warning the user their action did not succeed
      print('Failed to get latest uri: $err');
    });

    // Handle any initial links
    try {
      final initialUri = await getInitialUri();
      if (initialUri != null) {
        handleDeepLink(initialUri);
      }
    } on PlatformException catch (e) {
      print('Failed to get initial uri: ${e.message}');
    }
  }

 static void handleDeepLink(Uri uri) {
    // Here, you can navigate to different pages or perform actions based on the URI
    print('Received URI: $uri');
    // Example: if uri.path == '/product', navigate to product page
    // if (uri.path == '/product') {
    //   Navigator.of(context).pushNamed('/product', arguments: uri.queryParameters['id']);
    // }
  }

 static void dispose() {
    _sub?.cancel();
  }
}
