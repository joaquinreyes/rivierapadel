import 'package:acepadel/components/custom_dialog.dart';
import 'package:acepadel/repository/booking_repo.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:acepadel/app_styles/app_colors.dart';
import 'package:acepadel/app_styles/app_text_styles.dart';
import 'package:acepadel/components/approved_applicant_dialogs/events/events_applicant_dialog.dart';
import 'package:acepadel/components/avaialble_slot_widget.dart';
import 'package:acepadel/components/c_divider.dart';
import 'package:acepadel/components/service_detail_components.dart/service_coaches.dart';
import 'package:acepadel/components/main_button.dart';
import 'package:acepadel/components/participant_slot.dart';
import 'package:acepadel/components/secondary_button.dart';
import 'package:acepadel/components/secondary_text.dart';
import 'package:acepadel/components/service_detail_components.dart/service_information.dart';
import 'package:acepadel/components/waiting_list_approval_status.dart';
import 'package:acepadel/globals/constants.dart';
import 'package:acepadel/globals/images.dart';
import 'package:acepadel/globals/utils.dart';
import 'package:acepadel/managers/user_manager.dart';
import 'package:acepadel/models/applicat_socket_response.dart';
import 'package:acepadel/models/base_classes/booking_player_base.dart';
import 'package:acepadel/models/service_detail_model.dart';
import 'package:acepadel/models/service_waiting_players.dart';
import 'package:acepadel/repository/payment_repo.dart';
import 'package:acepadel/repository/play_repo.dart';
import 'package:acepadel/routes/app_pages.dart';
import 'package:acepadel/screens/payment_information/payment_information.dart';
import 'package:acepadel/screens/responsive_widgets/home_responsive_widget.dart';
import 'package:acepadel/utils/custom_extensions.dart';
import 'dart:math' as math;

import '../../models/cancellation_policy_model.dart';
import '../../models/refund_description_component.dart';
import '../open_match_detail/open_match_detail.dart';

part 'event_detail_provider.dart';
part 'event_detail_components.dart';

class EventDetail extends ConsumerStatefulWidget {
  const EventDetail({super.key, this.matchId});
  final int? matchId;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EventDetailState();
}

class _EventDetailState extends ConsumerState<EventDetail> {
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
    return Container(
      constraints: kComponentWidthConstraint,
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
              SizedBox(height: 20.h),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 3.w),
                  child: GestureDetector(
                    onTap: () => ref.read(goRouterProvider).pop(),
                    child: Image.asset(AppImages.backArrow.path,
                        height: 24.h, width: 24.h),
                  ),
                ),
              ),
              Text(
                "${"EVENT".trU(context)}\n ${"INFORMATION".trU(context)}",
                style: AppTextStyles.balooMedium22.copyWith(height: 1.2),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40.h),
              _InfoCard(event: service),
              ServiceInformationText(service: service),
              ServiceCoaches(coaches: service.getCoaches),
              SizedBox(height: 20.h),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                    // "${"PLAYERS".trU(context)} ${service.players?.length ?? 0} / ${service.getMaximumCapacity}",
                    "${service.service?.isDoubleEvent ?? false ? "TEAMS".tr(context) : "PLAYERS".tr(context)} ${service.players?.length ?? 0} / ${service.getMaximumCapacity}",
                    style: AppTextStyles.balooMedium17.copyWith(color: AppColors.darkGreen)),
              ),
              SizedBox(height: 10.h),
              Container(
                clipBehavior: Clip.antiAlias,
                padding: EdgeInsets.only(left: 20.w, right: 20.w,top: 15.h,bottom: service.service?.isDoubleEvent ?? false ? 15.h : 8.h),
                width: double.infinity,
                constraints: kComponentWidthConstraint,
                decoration: BoxDecoration(
                  color: AppColors.clay05,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: _EventPlayersSlots(
                  onRelease: _onRelease,
                  players: service.players ?? [],
                  maxPlayers: service.getMaximumCapacity,
                  service: service,
                  id: service.id!,
                  onSlotTap: (int index, int? otherPlayerID) async {
                    // Read the current customer ID from the user provider, defaulting to -1 if not available
                    if (_canJoin(
                        isJoined: isJoined,
                        otherPlayerID: otherPlayerID,
                        service: service)) {
                      await _onJoin(index, otherPlayerID, isJoined);
                    }
                  },
                  isDoubleEvents: service.service?.isDoubleEvent ?? false,
                ),
              ),
              SizedBox(height: 20.h),
              _secondaryBtns(isJoined, context, service),
              _ApprovalStatus(
                service: service,
                onJoin: _joinAfterApprovel,
                onWithdraw: _withdraw,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _onRelease(int id) async {
    if (id == -1) {
      return;
    }
    final bool? goAhead = await showDialog(
      context: context,
      builder: (context) => const ConfirmationDialog(
        type: ConfirmationDialogType.releaseReserve,
      ),
    );
    if (goAhead == true && mounted) {
      final provider = deleteReservedProvider(widget.service.id!, id);
      final bool? success =
          await Utils.showLoadingDialog(context, provider, ref);
      if (!mounted || success == null || !success) {
        return;
      }

      ref.invalidate(fetchServiceDetailProvider(widget.service.id!));
      Utils.showMessageDialog(
          context, "YOU_HAVE_RELEASED_THIS_SPOT_SUCCESSFULLY".tr(context));
    }
  }

  bool _canJoin({
    required bool isJoined,
    required int? otherPlayerID,
    required ServiceDetail service,
  }) {
    final currentCustomerID = ref.read(userProvider)?.user?.id ?? -1;

    if (isJoined && !(service.service?.isDoubleEvent ?? true)) {
      return false;
    }

    if (otherPlayerID != null) {
      final otherPlayerCustomerID = service.players
              ?.firstWhere(
                (element) => element.id == otherPlayerID,
              )
              .customer
              ?.id ??
          -1;

      if (isJoined && currentCustomerID != otherPlayerCustomerID) {
        return false;
      }
    } else if (isJoined) {
      return false;
    }
    return true;
  }

  Row _secondaryBtns(
      bool isJoined, BuildContext context, ServiceDetail service) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isJoined) ...[
              _leave(context),
              SizedBox(height: 10.h),
            ],
            if (!service.isPast) _addToCalendarButton(context),
          ],
        ),
        const Spacer(),
        _shareMatchButton(context),
      ],
    );
  }

  SecondaryImageButton _shareMatchButton(BuildContext context) {
    return SecondaryImageButton(
      label: "SHARE_MATCH".tr(context),
      image: AppImages.whatsaapIcon.path,
      imageHeight: 14.w,
      imageWidth: 14.w,
      onTap: _shareWhatsAap,
    );
  }

  void _shareWhatsAap() {
    Utils.shareEventLessonUrl(
        service: widget.service, isLesson: false, context: context);
  }

  SecondaryImageButton _addToCalendarButton(BuildContext context) {
    return SecondaryImageButton(
      label: "ADD_TO_CALENDAR".tr(context),
      image: AppImages.calendar.path,
      imageHeight: 15.w,
      imageWidth: 15.w,
      onTap: () {
        String title =
            "Event @ ${widget.service.service?.location?.locationName ?? ""}";
        ref.watch(addToCalendarProvider(
          title: title,
          startDate: widget.service.bookingStartTime,
          endDate: widget.service.bookingEndTime,
        ));
      },
    );
  }

  SecondaryImageButton _leave(BuildContext context) {
    return SecondaryImageButton(
      label: "LEAVE_EVENT".tr(context),
      image: AppImages.crossIcon.path,
      imageHeight: 15.w,
      imageWidth: 15.w,
      onTap: () {
        _onLeave();
      },
    );
  }

  _onJoin(int index, int? otherTeamPlayerId, bool isReserve) async {
    final ServiceDetail service = widget.service;
    bool isSecondPlayer = otherTeamPlayerId != null;
    _ConfirmationDialogType dialogType = _ConfirmationDialogType.join;
    if (isSecondPlayer) {
      dialogType = _ConfirmationDialogType.applyForApproval;
    }
    if (isReserve) {
      dialogType = _ConfirmationDialogType.reserve;
    }

    final bool? join = await showDialog(
      context: context,
      builder: (context) => _ConfirmationDialog(
        type: dialogType,
      ),
    );
    if (join == true && context.mounted && mounted) {
      final courtPrice = fetchCourtPriceProvider(
          serviceId: service.id ?? 0,
          coachId: null,
          courtId: [service.courtId],
          durationInMin: service.duration2,
          requestType: CourtPriceRequestType.join,
          dateTime: DateTime.now());
      await Utils.showLoadingDialog(context, courtPrice, ref);
      final provider = joinServiceProvider(
        service.id!,
        position: index + 1,
        playerId: otherTeamPlayerId,
        isEvent: true,
        isOpenMatch: false,
        isDouble: service.service?.isDoubleEvent ?? false,
        isReserve: isReserve,
        isApprovalNeeded: otherTeamPlayerId != null && !isReserve,
        isLesson: false,
      );
      final double? price =
          await Utils.showLoadingDialog(context, provider, ref);
      if (!mounted || price == null) {
        return;
      }
      if (isSecondPlayer && price < 0) {
        ref.invalidate(fetchServiceWaitingPlayersProvider(
            service.id!, RequestServiceType.event));
        Utils.showMessageDialog(
          context,
          "YOU_ARE_NOW_WAITING_FOR_APPROVAL".trU(context),
        );
        return;
      }

      final data = await showDialog(
        context: context,
        builder: (context) {
          return PaymentInformation(
              type: PaymentDetailsRequestType.join,
              transactionRequestType: TransactionRequestType.normal,
              locationID: service.service!.location!.id!,
              price: price,
              requestType: isReserve
                  ? PaymentProcessRequestType.reserved
                  : PaymentProcessRequestType.join,
              serviceID: service.id!,
              duration: service.duration2,
              startDate: service.bookingStartTime);
        },
      );
      var (int? paymentDone, double? amount) = (null, null);
      if (data is (int, double?)) {
        (paymentDone, amount) = data;
      }
      ref.invalidate(fetchServiceDetailProvider(service.id!));
      if (paymentDone != null && mounted) {
        Utils.showMessageDialog(
          context,
          "YOU_HAVE_JOINED_SUCCESSFULLY".trU(context),
        );
      }
    }
  }

  _joinAfterApprovel(int playerID) async {
    final ServiceDetail service = widget.service;
    final data = await showDialog(
      context: context,
      builder: (context) {
        return PaymentInformation(
            type: PaymentDetailsRequestType.join,
            transactionRequestType: TransactionRequestType.normal,
            locationID: service.service!.location!.id!,
            requestType: PaymentProcessRequestType.join,
            price: service.service!.price!,
            serviceID: service.id!,
            isJoiningApproval: true,
            duration: service.duration2,
            startDate: service.bookingStartTime);
      },
    );
    var (int? postPaymentServiceID, double? amount) = (null, null);
    if (data is (int, double?)) {
      (postPaymentServiceID, amount) = data;
    }

    if (postPaymentServiceID != null && mounted) {
      ref.invalidate(fetchServiceDetailProvider(service.id!));
      ref.invalidate(fetchServiceWaitingPlayersProvider(
          service.id!, RequestServiceType.event));
      Utils.showMessageDialog(
        context,
        "YOU_HAVE_JOINED_THE_MATCH".tr(context),
      );
    }
  }

  _withdraw(int id) {
    if (id == -1) {
      return;
    }
    showDialog(
      context: context,
      builder: (context) => const _ConfirmationDialog(
        type: _ConfirmationDialogType.withdraw,
      ),
    ).then(
      (value) {
        if (value == true) {
          final provider = approvePlayerProvider(
              isApprove: false, serviceID: widget.service.id!, playerID: id);
          Utils.showLoadingDialog(context, provider, ref).then((value) {
            if (value == true) {
              ref.invalidate(
                fetchServiceWaitingPlayersProvider(
                    widget.service.id!, RequestServiceType.event),
              );
              Utils.showMessageDialog(
                  context, "YOU_HAVE_WITHDRAWN_FROM_THE_MATCH".tr(context));
            }
          });
        }
      },
    );
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
      final bool? left = await Utils.showLoadingDialog(
        context,
        cancelServiceProvider(service.id!),
        ref,
      );
      if (left == true && mounted) {
        ref.invalidate(fetchServiceDetailProvider(service.id!));
        Utils.showMessageDialog(
          context,
          "YOU_HAVE_LEFT_THE_MATCH".trU(context),
        );
      }
    }
  }
}

class _ApprovalStatus extends ConsumerStatefulWidget {
  const _ApprovalStatus(
      {required this.service, required this.onJoin, required this.onWithdraw});
  final ServiceDetail service;

  final Function(int) onJoin;
  final Function(int) onWithdraw;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      __ApprovalStatusState();
}

class __ApprovalStatusState extends ConsumerState<_ApprovalStatus> {
  @override
  Widget build(BuildContext context) {
    final waitingList = ref.watch(fetchServiceWaitingPlayersProvider(
        widget.service.id ?? 0, RequestServiceType.event));
    return waitingList.when(
      data: (list) {
        final data = list.map((e) => e).toList();
        final currentID = ref.read(userProvider)?.user?.id;
        final waitingFinalList = [...data];
        waitingFinalList.removeWhere((element) => element.status != "waiting");
        data.removeWhere((element) => !(element.customer?.id == currentID &&
            (element.status == "pending" || element.status == "approved")));
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 20.h),
            if (data.isNotEmpty) ...[
              WaitingListApprovalStatus(
                data: data.first,
                onJoin: widget.onJoin,
                onWithdraw: widget.onWithdraw,
                isForEvent: true,
              ),
              SizedBox(height: 30.h),
              SizedBox(height: 20.h),
            ],
            _WaitingPlayersSlots(
              onRelease: _onRelease,
              onWithdraw: () {
                widget.onWithdraw(getInWaitingListId(list, currentID ?? -1));
              },
              isInWaitingList: checkInWaitingList(list, currentID ?? -1),
              players: waitingFinalList,
              maxPlayers: waitingFinalList.length + 3,
              service: widget.service,
              id: widget.service.id!,
              onSlotTap: (int index, int? otherPlayerID) async {
                await _onJoinWaitingList(index, otherPlayerID);
              },
              isDoubleEvents: widget.service.service?.isDoubleEvent ?? false,
            ),
          ],
        );
      },
      loading: () => Container(),
      error: (error, stackTrace) {
        return Container();
      },
    );
  }

  _onRelease(int id) async {
    if (id == -1) {
      return;
    }
    final bool? goAhead = await showDialog(
      context: context,
      builder: (context) => const ConfirmationDialog(
        type: ConfirmationDialogType.releaseReserve,
      ),
    );
    if (goAhead == true && mounted) {
      final provider = deleteReservedProvider(widget.service.id!, id);
      final bool? success =
          await Utils.showLoadingDialog(context, provider, ref);
      if (!mounted || success == null || !success) {
        return;
      }

      ref.invalidate(fetchServiceDetailProvider(widget.service.id!));
      Utils.showMessageDialog(
          context, "YOU_HAVE_RELEASED_THIS_SPOT_SUCCESSFULLY".tr(context));
    }
  }

  bool checkInWaitingList(List<ServiceWaitingPlayers> list, int userId) {
    int index = list.indexWhere((e) =>
        (e.status == "waiting" || e.status == "waiting_approval") &&
        e.customer?.id == userId);
    return index != -1;
  }

  int getInWaitingListId(List<ServiceWaitingPlayers> list, int userId) {
    int index = list.indexWhere((e) =>
        (e.status == "waiting" || e.status == "waiting_approval") &&
        e.customer?.id == userId);
    return list[index].id ?? -1;
  }

  _onJoinWaitingList(int index, int? otherTeamPlayerId) async {
    final ServiceDetail service = widget.service;
    _ConfirmationDialogType dialogType = _ConfirmationDialogType.joinWaitingLit;

    final bool? join = await showDialog(
      context: context,
      builder: (context) => _ConfirmationDialog(
        type: dialogType,
      ),
    );

    if (join == true && context.mounted && mounted) {
      final provider =
          joinWaitingListProvider(serviceId: service.id!, position: index + 1);
      await Utils.showLoadingDialog(context, provider, ref);
      ref.invalidate(fetchServiceWaitingPlayersProvider(
          widget.service.id ?? 0, RequestServiceType.event));

      // if (!mounted || price == null) {
      //   return;
      // }
      //   if (price < 0) {
      //     ref.invalidate(fetchServiceWaitingPlayersProvider(service.id!));
      //     Utils.showMessageDialog(
      //       context,
      //       "YOU_HAVE_JOINED_THE_WAITING_LIST_SUCCESSFULLY".trU(context),
      //     );
      //     return;
      //   }
      //
      //   int? paymentDone = await showDialog(
      //     context: context,
      //     builder: (context) {
      //       return PaymentInformation(
      //         locationID: service.service!.location!.id!,
      //         price: price,
      //         requestType: PaymentProcessRequestType.join,
      //         serviceID: service.id!,
      //       );
      //     },
      //   );
      //   ref.invalidate(fetchServiceDetailProvider(service.id!));
      //   if (paymentDone != null && mounted) {
      //     Utils.showMessageDialog(
      //       context,
      //       "YOU_HAVE_JOINED_THE_WAITING_LIST_SUCCESSFULLY".tr(context),
      //     );
      //   }
    }
  }
}
