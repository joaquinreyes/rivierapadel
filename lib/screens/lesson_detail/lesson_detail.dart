import 'package:acepadel/components/custom_dialog.dart';
import 'package:acepadel/repository/booking_repo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:acepadel/app_styles/app_colors.dart';
import 'package:acepadel/app_styles/app_text_styles.dart';
import 'package:acepadel/components/avaialble_slot_widget.dart';
import 'package:acepadel/components/c_divider.dart';
import 'package:acepadel/components/service_detail_components.dart/service_coaches.dart';
import 'package:acepadel/components/main_button.dart';
import 'package:acepadel/components/participant_slot.dart';
import 'package:acepadel/components/secondary_button.dart';
import 'package:acepadel/components/secondary_text.dart';
import 'package:acepadel/components/service_detail_components.dart/service_information.dart';
import 'package:acepadel/globals/constants.dart';
import 'package:acepadel/globals/images.dart';
import 'package:acepadel/globals/utils.dart';
import 'package:acepadel/managers/user_manager.dart';
import 'package:acepadel/models/base_classes/booking_player_base.dart';
import 'package:acepadel/models/service_detail_model.dart';
import 'package:acepadel/repository/payment_repo.dart';
import 'package:acepadel/repository/play_repo.dart';
import 'package:acepadel/routes/app_pages.dart';
import 'package:acepadel/screens/payment_information/payment_information.dart';
import 'package:acepadel/screens/responsive_widgets/home_responsive_widget.dart';
import 'package:acepadel/utils/custom_extensions.dart';
import 'dart:math' as math;

import '../../managers/dynamic_link_handler.dart';
import '../../models/cancellation_policy_model.dart';
import '../../models/refund_description_component.dart';

part 'lesson_detail_provider.dart';

part 'lesson_detail_components.dart';

class LessonDetail extends ConsumerStatefulWidget {
  const LessonDetail({super.key, this.matchId});

  final int? matchId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LessonDetailState();
}

class _LessonDetailState extends ConsumerState<LessonDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: HomeResponsiveWidget(child: _buildBody()),
      ),
    );
  }

  Widget _buildBody() {
    if (widget.matchId == null) {
      return SecondaryText(text: "SERVICE_ID_NOT_FOUND".tr(context));
    }
    final serviceDetail =
        ref.watch(fetchServiceDetailProvider(widget.matchId!));
    return serviceDetail.when(
      data: (data) {
        final user = ref.read(userManagerProvider).user;
        if (user == null) {
          return SecondaryText(text: "USER_NOT_FOUND".tr(context));
        }
        int uid = user.user?.id ?? -1;
        final joined = data.players
                ?.indexWhere((element) => element.customer?.id == uid) !=
            -1;
        Future(() {
          if (joined) {
            ref.read(_isJoined.notifier).state = true;
          } else {
            ref.read(_isJoined.notifier).state = false;
          }
        });
        return _DataBody(
          service: data,
        );
      },
      error: (error, stackTrace) => SecondaryText(text: error.toString()),
      loading: () => const Center(
        child: CupertinoActivityIndicator(
          radius: 10,
        ),
      ),
    );
  }
}

class _DataBody extends ConsumerStatefulWidget {
  const _DataBody({
    required this.service,
  });

  final ServiceDetail service;

  @override
  ConsumerState<_DataBody> createState() => _DataBodyState();
}

class _DataBodyState extends ConsumerState<_DataBody> {
  @override
  Widget build(BuildContext context) {
    final ServiceDetail service = widget.service;
    final isJoined = ref.watch(_isJoined);

    final maxPaxValue = service.maxPaxValue;

    final bool isLessonVariant = maxPaxValue != null;
    return Container(
      constraints: kComponentWidthConstraint,
      color: AppColors.backgroundColor,
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (notification) {
          notification.disallowIndicator();
          return true;
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              SizedBox(height: 35.5.h),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 17.w),
                  child: GestureDetector(
                    onTap: () => ref.read(goRouterProvider).pop(),
                    child: Image.asset(AppImages.backArrow.path,
                        height: 20.h, width: 20.h),
                  ),
                ),
              ),
              Text(
                "${"LESSON".trU(context)}\n ${"INFORMATION".trU(context)}",
                style: AppTextStyles.balooBold18.copyWith(height: 0.9),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 50.h),
              _InfoCard(lesson: service),
              SizedBox(height: 10.h),
              if (!isLessonVariant) ...[
                ServiceInformationText(service: service),
                ServiceCoaches(coaches: service.getCoaches),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${"PLAYERS".tr(context)} ${service.players?.length ?? 0} / ${service.getMaximumCapacity}",
                      style: AppTextStyles.balooBold13,
                    ),
                    Text(
                      "${"STATUS".tr(context).capitalizeFirst}: ${Utils.eventLessonStatusText(
                        context: context,
                        playersCount: service.players?.length ?? 0,
                        maxCapacity: service.getMaximumCapacity,
                        minCapacity: service.getMinimumCapacity,
                      )}",
                      style: AppTextStyles.balooBold13,
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Container(
                  clipBehavior: Clip.antiAlias,
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                  width: double.infinity,
                  constraints: kComponentWidthConstraint,
                  decoration: BoxDecoration(
                    color: AppColors.green5,
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                  child: _LessonPlayersSlots(
                    players: service.players ?? [],
                    maxPlayers: service.getMaximumCapacity,
                    onSlotTap: (index, __) async {
                      await _onJoin(index);
                    },
                  ),
                ),
                SizedBox(height: 15.h),
              ],
              SizedBox(height: 5.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isJoined) ...[
                        _leaveLesson(context),
                        SizedBox(height: 10.h),
                      ],
                      if (!service.isPast) _addToCalendarButton(context),
                    ],
                  ),
                  const Spacer(),
                  _shareMatchButton(context),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  StatelessWidget _shareMatchButton(BuildContext context) {
    return SecondaryImageButton(
      label: "SHARE_MATCH".tr(context),
      image: AppImages.whatsaapIcon.path,
      imageHeight: 13.w,
      imageWidth: 13.w,
      onTap: _shareWhatsAap,
    );
  }

  void _shareWhatsAap() {
    Utils.shareEventLessonUrl(
        context: context, service: widget.service, isLesson: true);
  }

  SecondaryImageButton _addToCalendarButton(BuildContext context) {
    return SecondaryImageButton(
      label: "ADD_TO_CALENDAR".tr(context),
      image: AppImages.calendar.path,
      imageHeight: 15.w,
      imageWidth: 15.w,
      onTap: () {
        String title =
            "Lesson @ ${widget.service.service?.location?.locationName ?? ""}";
        ref.watch(addToCalendarProvider(
          title: title,
          startDate: widget.service.bookingStartTime,
          endDate: widget.service.bookingEndTime,
        ));
      },
    );
  }

  SecondaryImageButton _leaveLesson(BuildContext context) {
    return SecondaryImageButton(
      label: "LEAVE_LESSON".tr(context),
      image: AppImages.crossIcon.path,
      imageHeight: 15.w,
      imageWidth: 15.w,
      onTap: () {
        _onLeave();
      },
    );
  }

  _onJoin(int index) async {
    final ServiceDetail service = widget.service;
    final bool? join = await showDialog(
      context: context,
      builder: (context) => const _ConfirmationDialog(
        type: _ConfirmationDialogType.join,
      ),
    );
    if (join == true && context.mounted && mounted) {
      final courtPrice = fetchCourtPriceProvider(
          serviceId: service.id ?? 0,
          coachId: service.service?.coachesId,
          courtId: [service.courtId],
          durationInMin: service.duration2,
          requestType: CourtPriceRequestType.join,
          dateTime: DateTime.now());
      await Utils.showLoadingDialog(context, courtPrice, ref);
      final provider = joinServiceProvider(
        service.id!,
        position: index + 1,
        isLesson: true,
        playerId: null,
        isEvent: false,
        isOpenMatch: false,
        isDouble: false,
        isReserve: false,
        isApprovalNeeded: false,
      );
      final double? price =
          await Utils.showLoadingDialog(context, provider, ref);
      if (!mounted || price == null) {
        return;
      }

      final data = await showDialog(
        context: context,
        builder: (context) {
          return PaymentInformation(
              transactionRequestType: TransactionRequestType.normal,
              type: PaymentDetailsRequestType.join,
              locationID: service.service!.location!.id!,
              price: price,
              requestType: PaymentProcessRequestType.join,
              serviceID: service.id!,
              duration: service.duration2,
              startDate: service.bookingStartTime);
        },
      );
      var (int? paymentDone, double? amount) = (null, null);
      if (data is (int, double?)) {
        (paymentDone, amount) = data;
      }
      ref.refresh(fetchServiceDetailProvider(service.id!));
      if (paymentDone != null && mounted) {
        Utils.showMessageDialog(
          context,
          "YOU_HAVE_JOINED_SUCCESSFULLY".tr(context),
        );
      }
    }
  }

  _onLeave() async {
    final ServiceDetail service = widget.service;
    final CancellationPolicy? policy = await Utils.showLoadingDialog(
        context, cancellationPolicyProvider(service.id!), ref);

    if (policy == null && !mounted) {
      return;
    }

    final bool? leave = await showDialog(
      context: context,
      builder: (context) => _ConfirmationDialog(
          type: _ConfirmationDialogType.leave, policy: policy),
    );
    if (leave == true && mounted) {
      final provider = cancelServiceProvider(service.id!);
      final bool? success =
          await Utils.showLoadingDialog(context, provider, ref);
      if (!mounted || success == null || !success) {
        return;
      }
      ref.invalidate(fetchServiceDetailProvider(service.id!));

      Utils.showMessageDialog(
        context,
        "YOU_HAVE_CANCELLED_THE_LESSON".tr(context),
      );
    }
  }
}
