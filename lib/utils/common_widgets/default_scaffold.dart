import 'package:flutter/material.dart';
import 'package:greenvoice/utils/styles/styles.dart';
import 'package:flutter_animate/flutter_animate.dart';

class DefaultScaffold extends StatelessWidget {
  final Widget body;
  final Widget? bottomNavigationBar, floatingActionButton, drawer;
  final PreferredSizeWidget? appBar;
  final bool resizeToAvoidBottomInset, safeAreaTop, safeAreaBottom, inactive;
  final Color backgroundColor;
  final bool isBusy;
  const DefaultScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.drawer,
    this.resizeToAvoidBottomInset = true,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.safeAreaTop = true,
    this.safeAreaBottom = true,
    this.isBusy = false,
    this.inactive = false,
    this.backgroundColor = AppColors.whiteColor,
  });

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: inactive,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
            extendBodyBehindAppBar: true,
            resizeToAvoidBottomInset: resizeToAvoidBottomInset,
            bottomNavigationBar: bottomNavigationBar,
            floatingActionButton: floatingActionButton,
            backgroundColor: backgroundColor,
            appBar: appBar,
            drawer: drawer,
            body: Stack(
              alignment: Alignment.center,
              children: [
                Positioned.fill(
                  child: SafeArea(
                    top: safeAreaTop,
                    bottom: safeAreaBottom,
                    child: body,
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  child: Visibility(
                    visible: isBusy,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeIn,
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.black54,
                      child: Center(
                        child: Image.asset(
                          'assets/images/icon.png',
                          height: 100,
                          width: 100,
                        )
                            .animate(
                              autoPlay: true,
                              onComplete: (controller) => controller.repeat(),
                            )
                            .fade(
                                duration: const Duration(milliseconds: 800),
                                end: .5,
                                curve: Curves.easeInOut),
                      ),
                    ),
                  ),
                )
              ],
            )),
      ),
    );
  }
}
