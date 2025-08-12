import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:acepadel/app_styles/app_colors.dart';
import 'package:acepadel/app_styles/app_text_styles.dart';
import 'package:acepadel/components/network_circle_image.dart';
import 'package:acepadel/globals/constants.dart';
import 'package:acepadel/managers/user_manager.dart';
import 'package:acepadel/screens/app_provider.dart';
import 'package:acepadel/utils/custom_extensions.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart'
    as inset;

class NavBar extends ConsumerStatefulWidget {
  const NavBar({Key? key}) : super(key: key);
  static const id = "NavBar";

  @override
  ConsumerState<NavBar> createState() => NavBarState();
}

class NavBarState extends ConsumerState<NavBar> {
  reload() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final pageIndex = ref.watch(pageIndexProvider);
    return Container(
      height: 80.h,
      alignment: Alignment.topCenter,
      padding: EdgeInsets.only(top: 11.h),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        boxShadow: [
          BoxShadow(
            color: AppColors.green5.withOpacity(0.25),
            blurRadius: 24,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: _insetContainer(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                _item(
                  text: '${'PLAY'.trU(context)} &\n${'MATCH'.trU(context)}',
                  index: 0,
                  textHeight: 0.99,
                  isSelected: pageIndex == 0,
                  onTap: () async {
                    if (pageIndex != 0) {
                      ref.read(pageIndexProvider.notifier).index = 0;
                    }
                  },
                ),
                // Positioned(
                //   top: 10,
                //   right: 10,
                //   child: CircleAvatar(
                //     backgroundColor: kSecondaryColor,
                //     radius: 9.sp,
                //     child: StreamBuilder(
                //         stream: AppController.I.getOpenMatchCountStream(),
                //         builder: (BuildContext context, snapshot) {
                //           List<Booking?> bookings =
                //               (snapshot.data ?? []).toList();
                //           bookings.removeWhere((element) => element == null);
                //           if (snapshot.hasData) {
                //             return Text(
                //               '${bookings.length}',
                //               textAlign: TextAlign.center,
                //               style: TextStyle(
                //                 color: Colors.white,
                //                 fontSize: 9.sp,
                //               ),
                //             );
                //           } else {
                //             return Container();
                //           }
                //         }),
                //   ),
                // ),
              ],
            ),
            _item(
              text: "RESERVE".trU(context),
              index: 1,
              textHeight: 0.90,
              isSelected: pageIndex == 1,
              onTap: () async {
                if (pageIndex != 1) {
                  ref.read(pageIndexProvider.notifier).state = 1;
                }
              },
            ),
            _item(
              text: 'PROFILE'.trU(context),
              index: 2,
              textHeight: 0.90,
              isSelected: pageIndex == 2,
              onTap: () async {
                if (pageIndex != 2) {
                  ref.read(pageIndexProvider.notifier).state = 2;
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  _item(
      {required String text,
      required int index,
      required bool isSelected,
      required Function() onTap,
      double textHeight = 1}) {
    return InkWell(
      onTap: () async {
        onTap();
      },
      child: Container(
        height: 45.h,
        width: 115.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.darkBlue : Colors.transparent,
          borderRadius: BorderRadius.circular(5.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (index == 2) ...[
              const _Profile(),
              SizedBox(height: 4.h),
            ],
            Text(
              text,
              style: isSelected
                  ? AppTextStyles.balooBold12.copyWith(
                      color: AppColors.white,
                      height: textHeight,
                    )
                  : AppTextStyles.balooMedium9.copyWith(
                      color: AppColors.darkGreen70,
                      height: textHeight,
                    ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _Profile extends ConsumerWidget {
  const _Profile({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    return NetworkCircleImage(
      path: user?.user?.profileUrl,
      showBG: true,
      isYellowBg: true,
      width: 23.w,
      height: 23.w,
    );
  }
}

Widget _insetContainer({required Widget child}) {
  return Container(
    constraints: kComponentWidthConstraint,
    width: 361.w,
    decoration: inset.BoxDecoration(
      color: AppColors.darkGreen5,
      borderRadius: BorderRadius.circular(5.r),
      boxShadow: kInsetShadow,
    ),
    padding: EdgeInsets.all(4.h),
    child: child,
  );
}
