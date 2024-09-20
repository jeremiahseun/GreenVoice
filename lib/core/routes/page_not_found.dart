import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class NotFoundScreen extends StatelessWidget {
  final VoidCallback onGoHome;

  const NotFoundScreen({super.key, required this.onGoHome});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.network(
              'https://raw.githubusercontent.com/xvrh/lottie-flutter/master/example/assets/lottiefiles/confusion.json',
              width: 200,
              height: 200,
              fit: BoxFit.fill,
            ),
            const SizedBox(height: 20),
            Text(
              'Oops! Page Not Found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 10),
            Text(
              'The page you are looking for doesn\'t exist or has been moved.',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: onGoHome,
              icon: const Icon(Icons.home),
              label: const Text('Go to Home'),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
