import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:acepadel/globals/current_platform.dart';
import 'package:acepadel/globals/images.dart';
import 'package:acepadel/routes/app_pages.dart';
import 'package:acepadel/routes/app_routes.dart';

class NotificationButton extends ConsumerStatefulWidget {
  const NotificationButton({
    super.key,
  });

  @override
  ConsumerState<NotificationButton> createState() => _NotificationButtonState();
}

class _NotificationButtonState extends ConsumerState<NotificationButton> {
  @override
  Widget build(BuildContext context) {
    if (PlatformC().isCurrentDesignPlatformDesktop) {
      return Container();
    }
    return InkWell(
      onTap: () {
        ref.read(goRouterProvider).push(RouteNames.notifications);
      },
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topRight,
        children: [
          Image.asset(
            // count == 0 ? "$kAssets/bell_white.png" : "$kAssets/bell.png",
            AppImages.noNotificationBell.path,
            height: 25.h,
            width: 25.h,
            // color: count != 0 ? kSecondaryColor : null,
          ),
          // if (count > 0)
          //   Positioned(
          //     right: -3,
          //     top: 1,
          //     child: CircleAvatar(
          //       backgroundColor: Colors.white,
          //       radius: 7.5,
          //       child: CircleAvatar(
          //         backgroundColor: kSecondaryColor,
          //         radius: 6.2,
          //         child: FittedBox(
          //           fit: BoxFit.fill,
          //           child: Text(
          //             '$count',
          //             textAlign: TextAlign.center,
          //             style: TextStyle(
          //                 //fontFamily: kMontserrat,
          //                 color: Colors.white,
          //                 fontSize: 12.sp),
          //           ),
          //         ),
          //       ),
          //     ),
          //   )
        ],
      ),
    );
  }
}
