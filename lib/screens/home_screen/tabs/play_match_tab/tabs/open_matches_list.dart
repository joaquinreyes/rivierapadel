import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:acepadel/app_styles/app_colors.dart';
import 'package:acepadel/app_styles/app_text_styles.dart';
import 'package:acepadel/components/c_divider.dart';
import 'package:acepadel/components/open_match_participant_row.dart';
import 'package:acepadel/components/secondary_text.dart';
import 'package:acepadel/globals/utils.dart';
import 'package:acepadel/models/open_match_model.dart';
import 'package:acepadel/repository/play_repo.dart';
import 'package:acepadel/routes/app_pages.dart';
import 'package:acepadel/routes/app_routes.dart';
import 'package:acepadel/screens/home_screen/tabs/play_match_tab/tabs/tab_parent.dart';
import 'package:acepadel/utils/custom_extensions.dart';

class OpenMatchesList extends ConsumerStatefulWidget {
  const OpenMatchesList(
      {super.key,
      required this.start,
      required this.end,
      required this.locationIds,
      required this.minLevel,
      required this.maxLevel});

  final DateTime start;
  final DateTime end;
  final List<int> locationIds;
  final double minLevel;
  final double maxLevel;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OpenMatchesState();
}

class _OpenMatchesState extends ConsumerState<OpenMatchesList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final openMatches = ref.watch(openMatchesListProvider(
      startDate: widget.start,
      endDate: widget.end,
      locationIDs: widget.locationIds,
      minLevel: widget.minLevel,
      maxLevel: widget.maxLevel,
    ));
    return PlayTabsParentWidget(
      onRefresh: () => ref.refresh(openMatchesListProvider(
        startDate: widget.start,
        endDate: widget.end,
        locationIDs: widget.locationIds,
        minLevel: widget.minLevel,
        maxLevel: widget.maxLevel,
      ).future),
      child: openMatches.when(
        data: (data) {
          if (data.isEmpty) {
            return SecondaryText(text: "NO_OPEN_MATCHES_FOUND".tr(context));
          }
          final dateList = data.dateList(widget.locationIds);
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: buildBookingWidgets(dateList, data),
          );
        },
        loading: () {
          return const Center(child: CupertinoActivityIndicator());
        },
        error: (error, _) => SecondaryText(text: error.toString()),
      ),
    );
  }

  List<Widget> buildBookingWidgets(
      List<DateTime> dateList, List<OpenMatchModel> matches) {
    final widgets = <Widget>[];
    for (var date in dateList) {
      widgets.add(
        Padding(
          padding: EdgeInsets.only(bottom: 10.h),
          child: Text(
            Utils.formatBookingDate(date, context),
            style: AppTextStyles.panchangBold13,
          ),
        ),
      );

      final dataMatches = matches.where((e) => e.bookingDate == date).toList();

      widgets.addAll(
        dataMatches.map(
          (match) => Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: InkWell(
              borderRadius: BorderRadius.circular(25.r),
              onTap: () async {
                await ref
                    .read(goRouterProvider)
                    .push("${RouteNames.matchInfo}/${match.id}");
                ref.invalidate(openMatchesListProvider(
                  startDate: widget.start,
                  endDate: widget.end,
                  locationIDs: widget.locationIds,
                  minLevel: widget.minLevel,
                  maxLevel: widget.maxLevel,
                ));
              },
              child: _OpenMatchCard(
                match: match,
              ),
            ),
          ),
        ),
      );
    }
    return widgets;
  }
}

class _OpenMatchCard extends ConsumerWidget {
  const _OpenMatchCard({required this.match});
  final OpenMatchModel match;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.h, vertical: 15.h),
      decoration: BoxDecoration(
        color: AppColors.green5,
        borderRadius: BorderRadius.circular(5.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                flex: 10,
                child: Text(
                  match.formattedDateStartEndTime,
                  style: AppTextStyles.helveticaBold14
                      .copyWith(color: AppColors.darkGreen),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  (match.service?.location?.locationName ?? "").capitalizeFirst,
                  textAlign: TextAlign.end,
                  style: AppTextStyles.helveticaBold12
                      .copyWith(color: AppColors.darkGreen),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          const CDivider(),
          OpenMatchParticipantRow(
            textForAvailableSlot: "AVAILABLE".tr(context),
            availableSlotIconColor: AppColors.darkGreen,
            availableSlotbackGroundColor: Colors.transparent,
            players: match.players ?? [],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                match.court,
                style: AppTextStyles.helveticaLight13.copyWith(
                  color: AppColors.darkGreen,
                ),
              ),
              Text(
                "${"LEVEL".tr(context)} ${match.openMatchLevelRange}",
                style: AppTextStyles.helveticaLight13.copyWith(
                  color: AppColors.darkGreen,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
