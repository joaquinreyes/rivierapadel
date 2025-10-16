import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:acepadel/screens/home_screen/tabs/profile_tab/tabs/user_bookings_list.dart';
import 'package:acepadel/utils/custom_extensions.dart';
import '../../../../../../app_styles/app_colors.dart';
import '../../../../../../app_styles/app_text_styles.dart';
import '../../../../../../globals/constants.dart';

part 'booking_profile_tab_provider.dart';

class BookingProfileTab extends ConsumerWidget {
  const BookingProfileTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageController = ref.watch(_bookingPageController);
    ref.listen(
      _selectedTabIndex,
      (previous, next) {
        if (next == previous) return;
        ref.read(_bookingPageController.notifier).state.animateToPage(next,
            duration: const Duration(milliseconds: 300), curve: Curves.linear);
      },
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: Container(
            width: 180.w,
            alignment: AlignmentDirectional.centerStart,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _pageSelectorItem(
                    ref: ref, text: 'UPCOMING'.tr(context), index: 0),
                _pageSelectorItem(ref: ref, text: 'PAST'.tr(context), index: 1),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        ExpandablePageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: pageController,
          children: _pages,
        ),
      ],
    );
  }

  Widget _pageSelectorItem({
    required WidgetRef ref,
    required String text,
    required int index,
  }) {
    final selectedTab = ref.watch(_selectedTabIndex);
    final isSelected = selectedTab == index;
    return Expanded(
      flex: 15,
      child: InkWell(
          borderRadius: BorderRadius.circular(15.r),
          onTap: () {
            if (selectedTab != index) {
              ref.read(_selectedTabIndex.notifier).state = index;
            }
          },
          child: Container(
            constraints: kComponentWidthConstraint,
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
            margin: EdgeInsets.symmetric(vertical: 4.h, horizontal: 5.w),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.darkBlue : Colors.transparent,
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(text,
                    textAlign: TextAlign.center,
                    style: isSelected
                        ? AppTextStyles.sansMedium12.copyWith(color: Colors.white)
                        : AppTextStyles.sansRegular12.copyWith(color: AppColors.clay70))
              ],
            ),
          )),
    );
  }
}
