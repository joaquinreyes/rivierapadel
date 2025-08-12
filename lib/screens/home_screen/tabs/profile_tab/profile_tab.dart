import 'dart:io';

import 'package:acepadel/components/c_divider.dart';
import 'package:acepadel/components/custom_dialog.dart';
import 'package:acepadel/components/secondary_text.dart';
import 'package:acepadel/models/active_memberships.dart';
import 'package:acepadel/repository/booking_repo.dart';
import 'package:acepadel/screens/app_provider.dart';
import 'package:acepadel/screens/home_screen/tabs/play_match_tab/tabs/tab_parent.dart';
import 'package:acepadel/screens/ranking_profile/ranking_profile.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:acepadel/app_styles/app_colors.dart';
import 'package:acepadel/app_styles/app_text_styles.dart';
import 'package:acepadel/components/image_src_sheet.dart';
import 'package:acepadel/components/main_button.dart';
import 'package:acepadel/components/network_circle_image.dart';
import 'package:acepadel/components/secondary_button.dart';
import 'package:acepadel/globals/constants.dart';
import 'package:acepadel/globals/images.dart';
import 'package:acepadel/globals/utils.dart';
import 'package:acepadel/managers/user_manager.dart';
import 'package:acepadel/repository/user_repo.dart';
import 'package:acepadel/routes/app_pages.dart';
import 'package:acepadel/routes/app_routes.dart';
import 'package:acepadel/screens/home_screen/tabs/profile_tab/tabs/settings.dart';
import 'package:acepadel/screens/home_screen/tabs/profile_tab/tabs/user_bookings_list.dart';
import 'package:acepadel/utils/custom_extensions.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart'
    as inset;
import 'package:image_picker/image_picker.dart';
import 'dart:math' as math;

import '../play_match_tab/play_match_tab.dart';

part 'profile_tab_components.dart';

part 'profile_tab_provider.dart';

class ProfileTab extends ConsumerStatefulWidget {
  const ProfileTab({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileTabState();
}

class _ProfileTabState extends ConsumerState<ProfileTab> {
  List<Widget> _pages = [];
  bool allowRankingProfile = false;

  List<Widget> tabs = [];

  @override
  void initState() {
    setPages(context);
    super.initState();
  }

  void setPages(BuildContext context) {
    Future(() {
      ref.read(_selectedTabIndex.notifier).state = 0;
      ref.refresh(fetchUserProvider);
      ref.refresh(fetchAllCustomFieldsProvider);
    });
    _pages = [
      const UserBookingsList(),
      const UserBookingsList(isPast: true),
      const Settings(),
    ];
    Future(() {
      _pages = [
        const UserBookingsList(),
        const UserBookingsList(isPast: true),
        RankingProfile(
            customerID: ref.read(userProvider)?.user?.id ?? -1, isPage: false),
        const Settings(),
      ];
    }).then((e) {
      if (context.mounted) {
        setTabs();
      }
    });
  }

  void setTabs() {
    allowRankingProfile = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final pageController = ref.watch(_profilePageController);
    ref.listen(
      _selectedTabIndex,
      (previous, next) {
        if (next == previous) return;
        ref.read(_profilePageController.notifier).state.animateToPage(next,
            duration: const Duration(milliseconds: 300), curve: Curves.linear);
      },
    );
    return PlayTabsParentWidget(
      onRefresh: () {
        int index = ref.read(_selectedTabIndex);
        if (index == 0 || index == 1) {
          return ref.refresh(fetchUserAllBookingsProvider.future);
        } else {
          return ref.refresh(fetchUserProvider.future);
        }
      },
      child: Column(
        children: [
          SizedBox(height: 35.5.h),
          const _HeaderInfo(),
          SizedBox(height: 15.h),
          // const _Membership(),
          // SizedBox(height: 15.h),
          // const _PlayedHours(),
          // SizedBox(height: 25.h),
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
            decoration: inset.BoxDecoration(
              color: AppColors.darkGreen5,
              borderRadius: BorderRadius.all(
                Radius.circular(5.r),
              ),
              boxShadow: kInsetShadow,
            ),
            child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _pageSelectorItem(
                      text: 'UPCOMING_BOOKINGS'.tr(context), index: 0),
                  _pageSelectorItem(
                      text: 'PAST_BOOKINGS'.tr(context), index: 1),
                  if (allowRankingProfile)
                    _pageSelectorItem(
                        text: 'RANKING_PROFILE'.tr(context), index: 2),
                  _pageSelectorItem(text: 'SETTINGS'.tr(context), index: 3),
                ]),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: ExpandablePageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: pageController,
              children: _pages,
            ),
          ),
        ],
      ),
    );
  }

  Widget _pageSelectorItem({
    required String text,
    required int index,
  }) {
    final selectedTab = ref.watch(_selectedTabIndex);
    bool isSelected = selectedTab == index;
    return Expanded(
      flex: 15,
      child: InkWell(
        borderRadius: BorderRadius.circular(5.r),
        onTap: () {
          if (selectedTab != index) {
            ref.read(_selectedTabIndex.notifier).state = index;
          }
        },
        child: Container(
          height: 40.h,
          constraints: kComponentWidthConstraint,
          padding: EdgeInsets.symmetric(horizontal: 13.w),
          margin: EdgeInsets.symmetric(vertical: 4.h),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.green : Colors.transparent,
            borderRadius: BorderRadius.circular(5.r),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(text,
                  textAlign: TextAlign.center,
                  style: isSelected
                      ? AppTextStyles.helveticaBold13
                          .copyWith(color: Colors.white)
                      : AppTextStyles.helveticaRegular12),
            ],
          ),
        ),
      ),
    );
  }
}
