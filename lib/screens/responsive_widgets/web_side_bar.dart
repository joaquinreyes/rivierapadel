import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:acepadel/app_styles/app_colors.dart';
import 'package:acepadel/app_styles/app_text_styles.dart';
import 'package:acepadel/components/network_circle_image.dart';
import 'package:acepadel/globals/constants.dart';
import 'package:acepadel/managers/user_manager.dart';
import 'package:acepadel/routes/app_pages.dart';
import 'package:acepadel/screens/app_provider.dart';
import 'package:acepadel/utils/custom_extensions.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart'
    as inset;

class SideNavBar extends ConsumerWidget {
  static int nestedRouteCount = 0;
  const SideNavBar({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageIndex = ref.watch(pageIndexProvider);
    return Container(
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 25.h),
      decoration: const BoxDecoration(
        color: AppColors.green,
        boxShadow: [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 24,
            offset: Offset(0, 4),
            spreadRadius: 0,
          )
        ],
      ),
      child: Column(
        children: [
          Container(
            // color: kPrimaryColor.withOpacity(0.25),
            decoration: BoxDecoration(
              // color: kScienceBlue,
              color: AppColors.darkGreen25,
              // boxShadow: kInsetShadow,
              borderRadius: BorderRadius.circular(5.r),
            ),
            padding: EdgeInsets.symmetric(vertical: 10.h),
            width: 250.w,
            child: Column(
              children: [
                // if (!kIsWeb)
                _item(
                  text: 'PLAY_N_MATCH'.tr(context),
                  index: 0,
                  isSelected: pageIndex == 0,
                  onTap: () async {
                    if (pageIndex != 0) {
                      ref.read(pageIndexProvider.notifier).state = 0;
                    }
                  },
                  ref: ref,
                ),
                _item(
                    text: 'BOOK_COURT'.tr(context),
                    index: 1,
                    isSelected: pageIndex == 1,
                    onTap: () async {
                      if (SideNavBar.nestedRouteCount > 0) {}
                      //   for (int i = 0; i < SideNavBar.nestedRouteCount; i++) {
                      //     Get.back();
                      //   }
                      //   SideNavBar.nestedRouteCount = 0;
                      // }
                      // if (controller.pageIndex != 1) {
                      //   await controller.pageController?.animateToPage(1,
                      //       duration: kAnimationDuration, curve: Curves.linear);
                      //   controller.update([NavBar.id]);
                      // }
                      if (pageIndex != 1) {
                        ref.read(pageIndexProvider.notifier).state = 1;
                      }
                    },
                    ref: ref),
                _item(
                  text: 'PROFILE'.tr(context),
                  index: 2,
                  isSelected: pageIndex == 2,
                  onTap: () async {
                    // if (SideNavBar.nestedRouteCount > 0) {
                    //   for (int i = 0; i < SideNavBar.nestedRouteCount; i++) {
                    //     Get.back();
                    //   }
                    //   SideNavBar.nestedRouteCount = 0;
                    // }
                    // if (controller.pageIndex != 2) {
                    //   await controller.pageController?.animateToPage(2,
                    //       duration: kAnimationDuration, curve: Curves.linear);
                    //   controller.update([NavBar.id]);
                    // }
                    if (pageIndex != 2) {
                      ref.read(pageIndexProvider.notifier).state = 2;
                    }
                  },
                  ref: ref,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _item(
      {required String text,
      required int index,
      required bool isSelected,
      required Function() onTap,
      required WidgetRef ref}) {
    return InkWell(
      onTap: () {
        while (ref.read(goRouterProvider).canPop()) {
          ref.read(goRouterProvider).pop();
        }
        onTap();
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? AppColors.yellow : Colors.transparent,
          borderRadius: BorderRadius.circular(5.r),
        ),
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: Stack(
          alignment: Alignment.topRight,
          clipBehavior: Clip.none,
          children: [
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (index == 2) ...[const _Profile(), SizedBox(width: 15.w)],
                  Text(
                    text,
                    style: isSelected
                        ? AppTextStyles.panchangBold12.copyWith(
                            color: AppColors.green,
                          )
                        : AppTextStyles.panchangMedium10.copyWith(
                            color: AppColors.gallery,
                          ),
                  ),
                ],
              ),
            ),
            // if (index == 0) ...[
            // Positioned(
            //   right: 30,
            //   bottom: 10,
            //   child: StreamBuilder(
            //       stream: AppController.I.getOpenMatchCountStream(),
            //       builder: (BuildContext context, snapshot) {
            //         List<Booking?> bookings = (snapshot.data ?? []).toList();
            //         bookings.removeWhere((element) => element == null);
            //         if (snapshot.hasData) {
            //           return Text(
            //             '${bookings.length}',
            //             textAlign: TextAlign.center,
            //             style: TextStyle(
            //               //fontFamily: kHighSpeed,
            //               color: Colors.white,
            //               fontSize: 12.sp,
            //               fontWeight: FontWeight.w800,
            //             ),
            //           );
            //         } else {
            //           return Container();
            //         }
            //       }),
            // ),
            // ]
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
      width: 25.w,
      height: 25.w,
    );
  }
}
