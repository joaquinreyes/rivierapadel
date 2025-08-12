import 'package:acepadel/app_styles/app_colors.dart';
import 'package:acepadel/components/custom_dialog.dart';
import 'package:acepadel/repository/booking_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:acepadel/app_styles/app_text_styles.dart';

import 'package:acepadel/components/approved_applicant_dialogs/open_match/open_match_applicants_dialog.dart';
import 'package:acepadel/components/main_button.dart';
import 'package:acepadel/components/open_match_participant_row.dart';
import 'package:acepadel/components/secondary_button.dart';
import 'package:acepadel/globals/images.dart';
import 'package:acepadel/globals/utils.dart';
import 'package:acepadel/models/approve_request_socket_response.dart';
import 'package:acepadel/models/service_detail_model.dart';
import 'package:acepadel/repository/payment_repo.dart';
import 'package:acepadel/screens/payment_information/payment_information.dart';
import 'package:acepadel/utils/custom_extensions.dart';

import '../../../models/court_price_model.dart';
import '../../../screens/home_screen/tabs/play_match_tab/play_match_tab.dart';

class OpenMatchApprovedRequestDialog extends ConsumerStatefulWidget {
  const OpenMatchApprovedRequestDialog({
    super.key,
    required this.data,
  });

  final ApprovedRequest_SocketResponse data;

  @override
  ConsumerState<OpenMatchApprovedRequestDialog> createState() =>
      _ApprovedRequestDialogState();
}

class _ApprovedRequestDialogState
    extends ConsumerState<OpenMatchApprovedRequestDialog> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "YOU_HAVE_BEEN_ACCEPTED_INTO_THE_MATCH".trU(context),
            textAlign: TextAlign.center,
            style:
                AppTextStyles.balooBold15.copyWith(color: AppColors.white),
          ),
          SizedBox(height: 20.h),
          ApplicantOpenMatchInfoCard(
            service: widget.data.serviceBooking!,
          ),
          SizedBox(height: 10.h),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text("CURRENT_PLAYERS".tr(context),
                style: AppTextStyles.balooMedium12
                    .copyWith(color: AppColors.white)),
          ),
          SizedBox(height: 5.h),
          OpenMatchParticipantRowWithBG(
            textForAvailableSlot: "AVAILABLE".tr(context),
            players: widget.data.serviceBooking?.players ?? [],
            showReserveReleaseButton: false,
            bgColor: AppColors.white25,
            availableSlotbackGroundColor: AppColors.blue35,
            availableSlotIconColor: AppColors.white,
            textColor: AppColors.white,
          ),
          SizedBox(height: 20.h),
          _secondaryButtons(false, context, widget.data.serviceBooking!),
          SizedBox(height: 15.h),
          MainButton(
            label: "PAY_MY_SHARE".tr(context),
            isForPopup: true,
            onTap: _payCourt,
          ),
        ],
      ),
    );
  }

  _payCourt() async {
    final locationID = widget.data.serviceBooking!.service!.location!.id;
    final price = widget.data.serviceBooking!.service!.price;
    final service = widget.data.serviceBooking;
    final serviceID = widget.data.waitingList?.serviceBookingId;
    if (locationID == null ||
        price == null ||
        serviceID == null ||
        service == null) {
      return;
    }
    final provider = fetchCourtPriceProvider(
        serviceId: service.id ?? 0,
        courtId: [service.courtId],
        durationInMin: service.duration2,
        requestType: CourtPriceRequestType.join,
        coachId: null,
        dateTime: DateTime.now());
    final CourtPriceModel? value =
        await Utils.showLoadingDialog(context, provider, ref);

    if (!mounted) {
      return;
    }
    final startDate = service.bookingStartTime;
    final duration = service.duration2;
    int? postPaymentServiceID = await showDialog(
      context: context,
      builder: (context) {
        return PaymentInformation(
          transactionRequestType: TransactionRequestType.normal,
          locationID: locationID,
          type: PaymentDetailsRequestType.join,
          requestType: PaymentProcessRequestType.join,
          price: value?.openMatchDiscountedPrice ?? price,
          serviceID: serviceID,
          isJoiningApproval: true,
          startDate: startDate,
          duration: duration,
        );
      },
    );

    if (postPaymentServiceID != null && mounted) {
      Navigator.pop(context);
      Utils.showMessageDialog(
        context,
        "YOU_HAVE_JOINED_THE_MATCH".tr(context),
      );
    }
  }

  Widget _shareMatchButton(BuildContext context) {
    return SecondaryImageButton(
      label: "SHARE_MATCH".tr(context),
      image: AppImages.whatsaapIcon.path,
      imageHeight: 13.w,
      isForPopup: true,
      imageWidth: 13.w,
      onTap: () {
        if (widget.data.serviceBooking != null) {
          Utils.shareOpenMatch(context, widget.data.serviceBooking!);
        }
      },
    );
  }

  SecondaryImageButton _addToCalendarButton(BuildContext context) {
    return SecondaryImageButton(
      label: "ADD_TO_CALENDAR".tr(context),
      image: AppImages.calendar.path,
      isForPopup: true,
      imageHeight: 15.w,
      imageWidth: 15.w,
      onTap: () {
        String title = "${getSportsName(ref)} Match";
        ref.watch(addToCalendarProvider(
          title: title,
          startDate: widget.data.serviceBooking!.bookingStartTime,
          endDate: widget.data.serviceBooking!.bookingEndTime,
        ));
      },
    );
  }

  Row _secondaryButtons(
      bool isJoined, BuildContext context, ServiceDetail service) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!service.isPast) _addToCalendarButton(context),
          ],
        ),
        const Spacer(),
        _shareMatchButton(context),
      ],
    );
  }
}
