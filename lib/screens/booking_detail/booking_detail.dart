import 'package:acepadel/components/changes_cancelled_details_card.dart';
import 'package:acepadel/components/custom_dialog.dart';
import 'package:acepadel/components/main_button.dart';
import 'package:acepadel/repository/booking_repo.dart';
import 'package:acepadel/repository/play_repo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:acepadel/app_styles/app_colors.dart';
import 'package:acepadel/app_styles/app_text_styles.dart';
import 'package:acepadel/components/c_divider.dart';
import 'package:acepadel/components/network_circle_image.dart';
import 'package:acepadel/components/secondary_button.dart';
import 'package:acepadel/globals/images.dart';
import 'package:acepadel/globals/utils.dart';
import 'package:acepadel/routes/app_pages.dart';
import 'package:acepadel/screens/responsive_widgets/home_responsive_widget.dart';
import 'package:acepadel/utils/custom_extensions.dart';
import '../../components/secondary_text.dart';
import '../../models/cancellation_policy_model.dart';
import '../../models/court_booking.dart' as booking;

import '../../models/lesson_model_new.dart';
import '../../models/refund_description_component.dart';
import '../../models/service_detail_model.dart';
import '../../routes/app_routes.dart';
import '../home_screen/tabs/booking_tab/book_court_dialog/book_court_dialog.dart';
import '../home_screen/tabs/play_match_tab/play_match_tab.dart';

class BookingDetail extends ConsumerStatefulWidget {
  const BookingDetail({super.key, required this.bookingId});

  final int? bookingId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BookingDetailState();
}

class _BookingDetailState extends ConsumerState<BookingDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: HomeResponsiveWidget(
              child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Column(
          children: [
            SizedBox(height: 20.h),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 3.w),
                child: InkWell(
                  onTap: () => ref.read(goRouterProvider).pop(),
                  child: Image.asset(
                    AppImages.backArrow.path,
                    width: 24.w,
                    height: 24.w,
                  ),
                ),
              ),
            ),
            Text(
              "${"BOOKING".trU(context)}\n ${"INFORMATION".trU(context)}",
              style: AppTextStyles.balooMedium22.copyWith(height: 1.2),
              textAlign: TextAlign.center,
            ),
            _body(),
          ],
        ),
      ))),
    );
  }

  Widget _body() {
    if (widget.bookingId == null) {
      return SecondaryText(text: "BOOKING_ID_NOT_FOUND".tr(context));
    }
    final serviceDetail =
        ref.watch(fetchServiceDetailProvider(widget.bookingId!));
    return serviceDetail.when(
      data: (data) {
        return _DataBody(
          userBooking: data,
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

class _CancelConfirmDialog extends StatelessWidget {
  final CancellationPolicy policy;

  const _CancelConfirmDialog({required this.policy});

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "ARE_YOU_SURE_YOU_WANT_TO_CANCEL_THE_BOOKING".trU(context),
            textAlign: TextAlign.center,
            style: AppTextStyles.popupHeaderTextStyle,
          ),
          SizedBox(height: 5.h),
          RefundDescriptionComponent(policy: policy),
          SizedBox(height: 20.h),
          Text(
            "CANCELLATION_POLICY_2".tr(context),
            textAlign: TextAlign.center,
            style: AppTextStyles.popupBodyTextStyle,
          ),
          SizedBox(height: 20.h),
          MainButton(
            label: "CANCEL_BOOKING".trU(context),
            isForPopup: true,
            onTap: () {
              Navigator.pop(context, true);
            },
          )
        ],
      ),
    );
  }
}

class _DataBody extends ConsumerWidget {
  final ServiceDetail userBooking;

  const _DataBody({required this.userBooking});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
          SizedBox(height: 40.h),
        if (userBooking.isCancelled ?? false) ...[
          ChangesCancelledDetailsCard(
            heading: "BOOKING_CANCELLED".tr(context),
            description: "CANCEL_DESC".tr(context),
          ),
        SizedBox(height: 15.h),
        ],
        _buildCard(context, ref),
        SizedBox(height: 20.h),
        if (!userBooking.isPast) ...[
          Row(
            children: [
              SecondaryImageButton(
                label: "CANCEL_MATCH".tr(context),
                image: AppImages.crossIcon.path,
                imageHeight: 13.w,
                imageWidth: 13.w,
                onTap: () {
                  _cancel(context, ref);
                },
              ),
              const Spacer(),
              SecondaryImageButton(
                label: "OPEN_MATCH_TO_FIND_PLAYERS".tr(context),
                image: AppImages.tennisBall.path,
                imageHeight: 11.w,
                imageWidth: 11.w,
                // fontSize: 9.5.sp,
                onTap: () {
                  _changeToOpen(context, ref);
                },
              ),
            ],
          ),
          SizedBox(height: 10.h),
        ],
        Row(
          children: [
            if (!userBooking.isPast)
              SecondaryImageButton(
                label: "ADD_TO_CALENDAR".tr(context),
                image: AppImages.calendar.path,
                imageHeight: 15.w,
                imageWidth: 15.w,
                onTap: () {
                  String title =
                      "Booking @ ${userBooking.courtName} - ${userBooking.service?.location?.locationName.capitalizeFirst}";
                  ref.watch(addToCalendarProvider(
                    title: title,
                    startDate: userBooking.bookingStartTime,
                    endDate: userBooking.bookingEndTime,
                  ));
                },
              ),
            const Spacer(),
            SecondaryImageButton(
              label: "SHARE_MATCH".tr(context),
              image: AppImages.whatsaapIcon.path,
              imageHeight: 13.w,
              imageWidth: 13.w,
              onTap: () {
                _shareWhatsAap(context, ref);
              },
            ),
          ],
        ),
      ],
    );
  }

  Container _buildCard(BuildContext context, WidgetRef ref) {
    String level = "";
    String profileUrl = "";
    String firstName = "-";
    if ((userBooking.players ?? []).isNotEmpty) {
      level =
          userBooking.players?.first.customer?.level(getSportsName(ref)) ?? "";
      profileUrl = userBooking.players?.first.customer?.profileUrl ?? "";
      firstName = userBooking.players?.first.getCustomerName ?? "";
    }
    return Container(
      padding: EdgeInsets.only(left: 15.w,bottom: 10.h,top: 15.h,right: 15.w),
      decoration: BoxDecoration(
        color: AppColors.darkBlue,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "ORGANIZER".tr(context),
                style: AppTextStyles.balooMedium13.copyWith(
                  color: AppColors.white,
                ),
              ),
              const Spacer(),
              Text(
                "BOOKING".tr(context),
                style: AppTextStyles.balooMedium13.copyWith(
                  color: AppColors.white,
                ),
              ),
            ],
          ),
          const CDivider(
            color: AppColors.white25,
          ),
          SizedBox(height: 5.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if ((userBooking.players ?? []).isNotEmpty)
                Expanded(
                  child: Column(
                    children: [
                      NetworkCircleImage(
                        path: profileUrl,
                        width: 37.w,
                        height: 37.w,
                        showBG: true,
                      ),
                      Text(
                        firstName,
                        style: AppTextStyles.balooMedium11.copyWith(
                          color: AppColors.white,
                          // height: 1.7,
                        ),
                      ),
                      Text(
                        level, //•  Right",
                        style: AppTextStyles.sansRegular12.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                        "${userBooking.bookingDate.format("EEE dd MMM")} | ${userBooking.bookingStartTime.format("h:mm")} - ${userBooking.bookingEndTime.format("h:mm a").toLowerCase()}",
                        style: AppTextStyles.sansRegular15.copyWith(
                          color: AppColors.white,
                        ),
                        textAlign: TextAlign.center),
                    SizedBox(height: 2.h),
                    Text(
                        "${userBooking.courtName} | ${userBooking.service?.location?.locationName}",
                        style: AppTextStyles.sansRegular15.copyWith(
                          color: AppColors.white,
                        ),
                        textAlign: TextAlign.center),
                    // SizedBox(height: 2.h),
                    // Text(
                    //     "${"PRICE".tr(context)} ${Utils.formatPrice(userBooking.service?.price?.toDouble())} ",
                    //     style: AppTextStyles.gothamLight13.copyWith(
                    //       color: AppColors.white,
                    //     ),
                    //     textAlign: TextAlign.center),
                  ],
                ),
              ),
              SizedBox(width: 15.h),
            ],
          )
        ],
      ),
    );
  }

  Future<void> _cancel(BuildContext context, WidgetRef ref) async {
    final CancellationPolicy? policy = await Utils.showLoadingDialog(
        context, cancellationPolicyProvider(userBooking.id!), ref);
    if (policy == null || !context.mounted) {
      return;
    }
    showDialog(
      context: context,
      builder: (context) => _CancelConfirmDialog(policy: policy),
    ).then(
      (value) async {
        if (value == true && context.mounted) {
          final bool? left = await Utils.showLoadingDialog(
              context, cancelServiceProvider(userBooking.id!), ref);
          if (left == true && context.mounted) {
            Utils.showMessageDialog(
              context,
              "YOU_HAVE_CANCELED_THE_BOOKING".trU(context),
            ).then((value) {
              ref.read(goRouterProvider).pop();
            });
          }
        }
      },
    );
  }

  void _shareWhatsAap(BuildContext context, WidgetRef ref) {
    Utils.shareBookingWhatsapp(context, userBooking, ref);
  }

  Future<void> _changeToOpen(BuildContext context, WidgetRef ref) async {
    if ((userBooking.courts ?? []).isNotEmpty &&
        userBooking.service != null &&
        userBooking.service!.location != null) {
      List<Courts> listCourts = [];

      (userBooking.courts ?? []).map((e) {
        listCourts.add(Courts.fromJson(e.toJson()));
      }).toList();

      String sportName = "";
      if ((userBooking.players ?? []).isNotEmpty &&
          userBooking.players!.first.customer!.sportsLevel.isNotEmpty) {
        sportName =
            userBooking.players!.first.customer!.sportsLevel.first.sportName ??
                "";
      }
      int? serviceId = await showDialog(
        context: context,
        builder: (context) {
          return BookCourtDialog(
            isOnlyOpenMatch: true,
            coachId: null,
            showRefund: true,
            courtPriceRequestType: CourtPriceRequestType.join,
            bookings: booking.Bookings(
                id: userBooking.id,
                price: userBooking.service!.price,
                duration: userBooking.duration2,
                isOpenMatch: true,
                sport: booking.Sport(sportName: sportName),
                location: booking.Location(
                    id: userBooking.service!.location!.id,
                    courts: listCourts,
                    locationName: userBooking.service!.location!.locationName)),
            bookingTime: userBooking.bookingStartTime,
            court: {
              (userBooking.courts ?? []).first.id ?? 0:
                  (userBooking.courts ?? []).first.courtName ?? ""
            },
          );
        },
      );

      if (serviceId != null) {
        ref
            .read(goRouterProvider)
            .push("${RouteNames.matchInfo}/$serviceId")
            .then((e) {
          if (context.mounted) {
            Navigator.pop(context);
          }
        });
      }
    }
  }
}
