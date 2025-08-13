import 'package:acepadel/components/custom_dialog.dart';
import 'package:acepadel/components/service_detail_components.dart/event_lesson_card_coach.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:acepadel/app_styles/app_colors.dart';
import 'package:acepadel/app_styles/app_text_styles.dart';
import 'package:acepadel/components/c_divider.dart';
import 'package:acepadel/components/main_button.dart';
import 'package:acepadel/components/secondary_text.dart';
import 'package:acepadel/globals/utils.dart';
import 'package:acepadel/models/lesson_models.dart';
import 'package:acepadel/repository/payment_repo.dart';
import 'package:acepadel/repository/play_repo.dart';
import 'package:acepadel/routes/app_pages.dart';
import 'package:acepadel/routes/app_routes.dart';
import 'package:acepadel/screens/home_screen/tabs/play_match_tab/tabs/tab_parent.dart';
import 'package:acepadel/screens/payment_information/payment_information.dart';
import 'package:acepadel/utils/custom_extensions.dart';
import '../../../../../../components/network_circle_image.dart';
import '../../../../../../components/service_detail_components.dart/level_restriction_container.dart';
import '../../../../../../globals/constants.dart';
import '../../../../../../repository/booking_repo.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart'
    as inset;

part 'lessons_list_components.dart';

class LessonsList extends ConsumerStatefulWidget {
  const LessonsList(
      {super.key,
      required this.start,
      required this.coachesIds,
      required this.end,
      required this.locationIds});

  final DateTime start;
  final DateTime end;
  final List<int> locationIds;
  final List<int> coachesIds;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LessonState();
}

class _LessonState extends ConsumerState<LessonsList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final lessons = ref.watch(lessonsListProvider(
        startDate: widget.start,
        endDate: widget.end,
        locationIDs: widget.locationIds,
        coachesIds: widget.coachesIds));
    return PlayTabsParentWidget(
      onRefresh: () => ref.refresh(lessonsListProvider(
              startDate: widget.start,
              endDate: widget.end,
              locationIDs: widget.locationIds,
              coachesIds: widget.coachesIds)
          .future),
      child: lessons.when(
        data: (data) {
          if (data.isEmpty) {
            return SecondaryText(text: "NO_LESSONS_FOUND".tr(context));
          }
          return ListView.builder(
            itemCount: data.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return _Lessons(
                lesson: data[index],
                start: widget.start,
                end: widget.end,
                locationIds: widget.locationIds,
              );
            },
          );
        },
        loading: () => const Center(child: CupertinoActivityIndicator()),
        error: (error, _) => SecondaryText(text: error.toString()),
      ),
    );
  }
}

class _Lessons extends ConsumerStatefulWidget {
  const _Lessons({
    required this.lesson,
    required this.start,
    required this.end,
    required this.locationIds,
  });

  final LessonsModel lesson;
  final DateTime start;
  final DateTime end;
  final List<int> locationIds;

  @override
  ConsumerState<_Lessons> createState() => _LessonsState();
}

class _LessonsState extends ConsumerState<_Lessons> {
  bool isDatesVisible = false;

  @override
  Widget build(BuildContext context) {
    double? price = widget.lesson.price;
    if (widget.lesson.selectedCoach != null) {
      final coach = (widget.lesson.coachesTeachings ?? []).firstWhere(
          (element) => element.coachId == widget.lesson.selectedCoach,
          orElse: () => CoachesTeaching());
      if (coach.price != null) price = coach.price;
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
      decoration: BoxDecoration(
        color: AppColors.clay05,
        borderRadius: BorderRadius.circular(12.r),
      ),
      margin: EdgeInsets.only(bottom: 15.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                flex: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      (widget.lesson.lessonName ?? "").capitalizeFirst,
                      style: AppTextStyles.gothamRegular16,
                    ),
                    SizedBox(height: 2.h),
                    LevelRestrictionContainer(
                      levelRestriction: widget.lesson.levelRestriction,
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 8,
                child: EventLessonCardCoach(
                  coaches: widget.lesson.coaches,
                  showAllCouches: false,
                ),
              ),
            ],
          ),
          const CDivider(),
          Row(
            children: [
              Expanded(
                flex: 10,
                child: Text(
                  (widget.lesson.eventInfo ?? ""),
                  style: AppTextStyles.sansRegular13,
                ),
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    (widget.lesson.location?.locationName ?? "")
                        .capitalizeFirst,
                    style: AppTextStyles.sansRegular13,
                  ),
                  Text(
                    Utils.formatPrice(price),
                    style: AppTextStyles.sansRegular13,
                  )
                ],
              )
            ],
          ),
          SizedBox(height: 8.h),
          _LessonDatesVisibilityToggle(
            isDatesVisible: isDatesVisible,
            onTap: () {
              setState(() {
                isDatesVisible = !isDatesVisible;
              });
            },
          ),
          if (isDatesVisible) ...[
            // if (widget.lesson.selectedCoach != null)
            //   _LessonCoachesListView(
            //     lesson: widget.lesson,
            //     onChangeSelectedCoach: (int? id) {
            //       widget.lesson.selectedCoach = id;
            //       setState(() {});
            //     },
            //   ),
            SizedBox(height: 10.h),
            _LessonDatesListView(
              lesson: widget.lesson,
              services: widget.lesson.services,
              onTap: (index) {
                final serviceBooking =
                    widget.lesson.services![index].serviceBookings?.first;
                _onJoinTap(serviceBooking);
              },
            ),
          ],
        ],
      ),
    );
  }

  void _onJoinTap(LessonServiceBookings? serviceBooking) async {
    final maxCapacity = serviceBooking?.maximumCapacity ?? 0;
    if (maxCapacity == 1) {
      await _joinSingle(serviceBooking);
    } else {
      await ref
          .read(goRouterProvider)
          .push("${RouteNames.lessonInfo}/${serviceBooking?.id}");
    }
    ref.invalidate(lessonsListProvider);
  }

  Future<void> _joinSingle(LessonServiceBookings? serviceBooking) async {
    final confirmed = await showDialog(
        context: context, builder: (_) => const _ConfirmationDialog());
    if (confirmed == true && context.mounted) {
      final courtPrice = fetchCourtPriceProvider(
          coachId: serviceBooking?.coachesId,
          courtId: [serviceBooking!.courtId],
          serviceId: serviceBooking.id ?? 0,
          durationInMin: serviceBooking.duration2,
          requestType: CourtPriceRequestType.join,
          dateTime: DateTime.now());
      if (!mounted) {
        return;
      }
      await Utils.showLoadingDialog(context, courtPrice, ref);
      final provider = joinServiceProvider(
        serviceBooking.id!,
        position: 0,
        isLesson: true,
        playerId: null,
        isEvent: false,
        isOpenMatch: false,
        isDouble: false,
        isReserve: false,
        isApprovalNeeded: false,
      );
      if (!mounted) {
        return;
      }
      final double? price =
          await Utils.showLoadingDialog(context, provider, ref);
      if (price != null && context.mounted && mounted) {
        final data = await showDialog(
          context: context,
          builder: (context) {
            return PaymentInformation(
                transactionRequestType: TransactionRequestType.normal,
                type: PaymentDetailsRequestType.join,
                locationID: widget.lesson.location!.id!,
                price: price,
                requestType: PaymentProcessRequestType.join,
                serviceID: serviceBooking.id!,
                duration: serviceBooking.duration2,
                startDate: serviceBooking.bookingStartTime);
          },
        );
        var (int? paymentDone, double? amount) = (null, null);
        if (data is (int, double?)) {
          (paymentDone, amount) = data;
        }
        if (paymentDone != null && context.mounted && mounted) {
          Utils.showMessageDialog(
            context,
            "YOU_HAVE_JOINED_SUCCESSFULLY".trU(context),
          );
        }
      }
    }
  }
}
