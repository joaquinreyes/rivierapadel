import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:acepadel/globals/current_platform.dart';
import 'package:acepadel/screens/notification_screen/notification_screen.dart';
import 'package:acepadel/screens/responsive_widgets/web_header.dart';
import 'package:acepadel/screens/responsive_widgets/web_side_bar.dart';

class HomeResponsiveWidget extends StatefulWidget {
  const HomeResponsiveWidget({super.key, required this.child});
  final Widget child;
  @override
  State<HomeResponsiveWidget> createState() => _ResponsiveWidgetState();
}

class _ResponsiveWidgetState extends State<HomeResponsiveWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (PlatformC().isCurrentDesignPlatformDesktop) const WebHeader(),
        Expanded(
          flex: 10,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (PlatformC().isCurrentDesignPlatformDesktop)
                const Expanded(
                  flex: 3,
                  child: SideNavBar(),
                ),
              Expanded(
                flex: 8,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal:
                        PlatformC().isCurrentDesignPlatformDesktop ? 100.w : 0,
                  ),
                  child: widget.child,
                ),
              ),
              if (PlatformC().isCurrentDesignPlatformDesktop)
                Expanded(
                  flex: 3,
                  child: Container(
                    decoration: const BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x0C000000),
                          blurRadius: 24,
                          offset: Offset(0, 4),
                          spreadRadius: 0,
                        )
                      ],
                    ),
                    child: const NotificationScreen(),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
