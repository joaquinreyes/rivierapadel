import 'package:acepadel/screens/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:acepadel/app_styles/app_colors.dart';
import 'package:acepadel/app_styles/app_text_styles.dart';
import 'package:acepadel/components/custom_dialog.dart';
import 'package:acepadel/components/selected_tag.dart';
import 'package:acepadel/globals/constants.dart';
import 'package:acepadel/globals/current_platform.dart';
import 'package:acepadel/globals/images.dart';
import 'package:acepadel/managers/user_manager.dart';
import 'package:acepadel/models/club_locations.dart';
import 'package:acepadel/repository/club_repo.dart';
import 'package:acepadel/screens/home_screen/tabs/play_match_tab/tabs/lesson_list/lessons_list.dart';
import 'package:acepadel/screens/home_screen/tabs/play_match_tab/tabs/events_list.dart';
import 'package:acepadel/screens/home_screen/tabs/play_match_tab/tabs/open_matches_list.dart';
import 'package:acepadel/utils/custom_extensions.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart'
    as inset;
import 'package:syncfusion_flutter_core/theme.dart'
    show SfDateRangePickerTheme, SfDateRangePickerThemeData;

import '../../../../globals/utils.dart';
import '../../../../models/service_detail_model.dart';
part 'play_match_providers.dart';
part 'play_match_component.dart';

class PlayMatchTab extends ConsumerStatefulWidget {
  const PlayMatchTab({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PlayMatchTabState();
}

class _PlayMatchTabState extends ConsumerState<PlayMatchTab> {
  @override
  void initState() {
    Future(() {
      ref.read(_selectedTabIndex.notifier).state = 0;
    });
    // ref.refresh(fetchUserProvider);
    // ref.refresh(fetchAllCustomFieldsProvider);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   body: SafeArea(
    //     child: Center(
    //       child: Text(
    //         "COMING_SOON".tr(context),
    //         style: AppTextStyles.panchangBold26,
    //         textAlign: TextAlign.center,
    //       ),
    //     ),
    //   ),
    // );
    ref.listen(
      _selectedTabIndex,
      (previous, next) {
        if (next == previous) return;
        Future(() {
          ref.read(_pageController.notifier).state.animateToPage(
                next,
                duration: const Duration(milliseconds: 300),
                curve: Curves.linear,
              );
        });
      },
    );
    final pageController = ref.watch(_pageController);
    final dateRange = ref.watch(_dateRangeProvider);
    final levelRange = ref.watch(_selectedLevelProvider);
    final locationID = ref.watch(_selectedLocationProvider);
    final coachesIds = ref.watch(_selectedCoachesProvider);

    return Column(
      children: [
        SizedBox(height: 35.5.h),
        const _ViewSelector(),
        SizedBox(height: 15.h),
        _FilterRow(),
        SizedBox(height: 20.h),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: PageView(
              controller: pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                OpenMatchesList(
                  start: dateRange.startDate!,
                  end: dateRange.endDate!,
                  locationIds: locationID.id != -1 ? [locationID.id!] : [],
                  minLevel: levelRange.first,
                  maxLevel: levelRange.last,
                ),
                EventsList(
                  minLevel: 0,
                  maxLevel: 10,
                  start: dateRange.startDate!,
                  end: dateRange.endDate!,
                  locationIds: locationID.id != -1 ? [locationID.id!] : [],
                ),
                LessonsList(
                  start: dateRange.startDate!,
                  end: dateRange.endDate!,
                  locationIds: locationID.id != -1 ? [locationID.id!] : [],
                  coachesIds: coachesIds.id != -1 ? [coachesIds.id!] : [],
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
