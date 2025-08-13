import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:acepadel/app_styles/app_colors.dart';
import 'package:acepadel/app_styles/app_text_styles.dart';
import 'package:acepadel/components/c_divider.dart';
import 'package:acepadel/components/secondary_text.dart';
import 'package:acepadel/globals/utils.dart';
import 'package:acepadel/models/events_model.dart';
import 'package:acepadel/repository/play_repo.dart';
import 'package:acepadel/routes/app_pages.dart';
import 'package:acepadel/routes/app_routes.dart';
import 'package:acepadel/screens/home_screen/tabs/play_match_tab/tabs/tab_parent.dart';
import 'package:acepadel/utils/custom_extensions.dart';

import '../../../../../components/service_detail_components.dart/event_lesson_card_coach.dart';
import '../../../../../components/service_detail_components.dart/level_restriction_container.dart';

class EventsList extends ConsumerStatefulWidget {
  const EventsList(
      {super.key,
      required this.start,
      required this.end,
      required this.minLevel,
      required this.maxLevel,
      required this.locationIds});

  final DateTime start;
  final DateTime end;
  final List<int> locationIds;
  final double minLevel;
  final double maxLevel;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EventListState();
}

class _EventListState extends ConsumerState<EventsList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final events = ref.watch(eventsListProvider(
        startDate: widget.start,
        endDate: widget.end,
        locationIDs: widget.locationIds,
        maxLevel: widget.maxLevel,
        minLevel: widget.minLevel));
    return PlayTabsParentWidget(
      onRefresh: () => ref.refresh(eventsListProvider(
              startDate: widget.start,
              endDate: widget.end,
              locationIDs: widget.locationIds,
              minLevel: widget.minLevel,
              maxLevel: widget.maxLevel)
          .future),
      child: events.when(
        data: (data) {
          if (data.isEmpty) {
            return SecondaryText(text: "NO_EVENTS_FOUND".tr(context));
          }
          final dateList = data.dateList;
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: buildBookingWidgets(dateList, data),
          );
        },
        loading: () => const Center(child: CupertinoActivityIndicator()),
        error: (error, _) => SecondaryText(text: error.toString()),
      ),
    );
  }

  List<Widget> buildBookingWidgets(
      List<DateTime> dateList, List<EventsModel> matches) {
    final widgets = <Widget>[];
    for (var date in dateList) {
      widgets.add(
        Padding(
          padding: EdgeInsets.only(bottom: 15.h),
          child: Text(
            Utils.formatBookingDate(date, context).toUpperCase(),
            style: AppTextStyles.balooMedium18,
          ),
        ),
      );

      final dataMatches = matches.where((e) => e.bookingDate == date).toList();

      widgets.addAll(
        dataMatches.map(
          (event) => Padding(
            padding: EdgeInsets.only(bottom: 15.h),
            child: InkWell(
              onTap: () async {
                await ref
                    .read(goRouterProvider)
                    .push("${RouteNames.eventInfo}/${event.id}");
                ref.refresh(
                  eventsListProvider(
                          startDate: widget.start,
                          endDate: widget.end,
                          locationIDs: widget.locationIds,
                          maxLevel: widget.maxLevel,
                          minLevel: widget.minLevel)
                      .future,
                );
              },
              child: _EventsCard(event: event),
            ),
          ),
        ),
      );
    }
    return widgets;
  }
}

class _EventsCard extends ConsumerWidget {
  const _EventsCard({required this.event});

  final EventsModel event;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
      decoration: BoxDecoration(
          color: AppColors.clay05,
          borderRadius: BorderRadius.circular(12.r)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                flex: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (event.service?.event?.eventName ?? "").capitalizeFirst,
                      style: AppTextStyles.gothamRegular16,
                    ),
                    LevelRestrictionContainer(
                      levelRestriction: event.service?.event?.levelRestriction,
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 8,
                child: EventLessonCardCoach(
                  coaches: event.getCoaches,
                  showAllCouches: false,
                ),
              )
            ],
          ),
          const CDivider(),
          Row(
            children: [
              Expanded(
                child: _colInfo(
                  event.service?.location?.locationName ?? "",
                  "${"PRICE".tr(context)} ${Utils.formatPrice(event.service?.price)}",
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      Utils.eventLessonStatusText(
                        context: context,
                        playersCount: event.players?.length ?? 0,
                        maxCapacity: event.getMaximumCapacity,
                        minCapacity: event.getMinimumCapacity,
                      ).toUpperCase(),
                      style: AppTextStyles.balooMedium12,
                    ),
                    // SizedBox(height: 4.h),
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 2.h, horizontal: 10.w),
                      decoration: BoxDecoration(
                        color: AppColors.oak,
                        borderRadius: BorderRadius.all(Radius.circular(100.r)),
                      ),
                      child: Text(
                        "${event.players?.length.toString() ?? "0"}/${(event.getMaximumCapacity).toString() ?? "0"}",
                        style: AppTextStyles.gothamRegular14.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _colInfo(
                  (event.formatBookingDate),
                  event.formatStartEndTimeAm,
                  isEnd: true,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Column _colInfo(String text1, String text2, {bool isEnd = false}) {
    return Column(
      crossAxisAlignment:
          isEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        SizedBox(height: 5.h),
        Text(
          text1,
          style: AppTextStyles.sansRegular13,
        ),
        SizedBox(height: 5.h),
        Text(
          text2,
          style: AppTextStyles.sansRegular13,
        ),
      ],
    );
  }
}
