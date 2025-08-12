import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:acepadel/globals/current_platform.dart';
import 'package:acepadel/globals/images.dart';

class AuthResponsive extends StatelessWidget {
  const AuthResponsive({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: PlatformC().isCurrentDesignPlatformDesktop
            ? DecorationImage(
                image: AssetImage(AppImages.webStaticPage.path),
                fit: BoxFit.fitWidth,
              )
            : null,
      ),
      child: child,
    );
  }
}
