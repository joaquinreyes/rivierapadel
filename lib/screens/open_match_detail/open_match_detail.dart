import 'dart:math';

import 'package:acepadel/components/custom_dialog.dart';
import 'package:acepadel/repository/booking_repo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:acepadel/app_styles/app_colors.dart';
import 'package:acepadel/app_styles/app_text_styles.dart';
import 'package:acepadel/components/c_divider.dart';
import 'package:acepadel/components/main_button.dart';
import 'package:acepadel/components/network_circle_image.dart';
import 'package:acepadel/components/open_match_participant_row.dart';
import 'package:acepadel/components/open_match_waiting_for_approval_players.dart';
import 'package:acepadel/components/secondary_button.dart';
import 'package:acepadel/components/secondary_text.dart';
import 'package:acepadel/components/waiting_list_approval_status.dart';
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
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart'
    as inset;

import '../../components/approved_list_user_join.dart';
import '../../components/changes_cancelled_details_card.dart';
import '../../managers/chat_socket_manager/chat_socket_manager.dart';
import '../../models/assessment_res_model.dart';
import '../../models/cancellation_policy_model.dart';
import '../../models/refund_description_component.dart';
import '../../models/service_waiting_players.dart';
import '../../routes/app_routes.dart';
import '../../utils/dubai_date_time.dart';
import '../home_screen/tabs/play_match_tab/play_match_tab.dart';
import 'match_result_dialog/enter_match_result.dart';

part 'open_match_components.dart';

part 'open_match_provider.dart';

part 'open_match_dialogs.dart';

class OpenMatchDetail extends ConsumerStatefulWidget {
  const OpenMatchDetail({super.key, this.matchId});

  final int? matchId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OpenMatchDetailState();
}

class _OpenMatchDetailState extends ConsumerState<OpenMatchDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: HomeResponsiveWidget(
          child: _buildBody(),
        ),
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
  bool isApprovalNeeded = false;
  bool isCurrentUserOrganizer = false;
  bool isRankedMatch = false;

  @override
  void initState() {
    isApprovalNeeded = widget.service.approveBeforeJoin ?? false;
    final currentPlayerID = ref.read(userProvider)?.user?.id;
    final organizerID = widget.service.organizer?.customer?.id;
    isCurrentUserOrganizer = currentPlayerID == organizerID;
    isRankedMatch = !(widget.service.isFriendlyMatch ?? true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isCancelled = widget.service.isCancelled ?? false;

    final ServiceDetail service = widget.service;
    final isJoined = ref.watch(_isJoined);

    String chatCount = "";

    if (isJoined) {
      final provider = fetchChatCountProvider(matchId: service.id ?? 0);
      ref.watch(provider).whenData((data) {
        if (data != null && data > 0) {
          chatCount = "(${data.toInt()})";
        }
      });
    }

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
              SizedBox(height: 35.5.h),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 17.w),
                  child: GestureDetector(
                    onTap: () => ref.read(goRouterProvider).pop(),
                    child: Image.asset(AppImages.backArrow.path,
                        height: 25.h, width: 25.h),
                  ),
                ),
              ),
              Text(
                "${"MATCH".trU(context)}\n ${"INFORMATION".trU(context)}",
                style: AppTextStyles.balooBold18.copyWith(height: 0.9),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40.h),
              if (isCancelled) ...[
                SizedBox(height: 15.h),
                ChangesCancelledDetailsCard(
                  heading: "OPEN_MATCH_CANCELLED".tr(context),
                  description: "CANCEL_DESC".tr(context),
                )
              ],
              SizedBox(height: 15.h),
              _InfoCard(service: service),
              SizedBox(height: 15.h),
              _OrganizerNote(note: service.organizerNote ?? ""),
              SizedBox(height: 20.h),
              Row(
                children: [
                  Text(
                    "PLAYERS".tr(context),
                    style: AppTextStyles.balooBold13,
                  ),
                  const Spacer(),
                  _RankedOrFriendly(isRanked: isRankedMatch)
                ],
              ),
              SizedBox(height: 10.h),
              OpenMatchParticipantRowWithBG(
                bgColor: AppColors.green5,
                textForAvailableSlot: "AVAILABLE".trU(context),
                players: service.players ?? [],
                allowBackground: false,
                onTap: (_, __) async {
                  final provider = fetchServiceWaitingPlayersProvider(
                      service.id!, RequestServiceType.booking);
                  final currentUserID =
                      ref.read(userManagerProvider).user?.user?.id;
                  final data =
                      await Utils.showLoadingDialog(context, provider, ref);
                  bool userPresent = false;
                  if (data is List<ServiceWaitingPlayers>) {
                    userPresent =
                        data.any((e) => e.customer?.id == currentUserID);
                  }
                  if (!userPresent && !isCancelled) {
                    _onJoin(isJoined, false);
                  }
                },
                showReserveReleaseButton: true,
                currentPlayerID: ref.read(userProvider)?.user?.id ?? -1,
                onRelease: _onRelease,
              ),
              SizedBox(height: 20.h),
              _secondaryButtons(isJoined, context, service),
              if (isJoined) ...[
                SizedBox(height: 20.h),
                _ApprovedList(
                    id: service.id!,
                    isCurrentOrganizer: isCurrentUserOrganizer),
              ],
              if (isApprovalNeeded) ...[
                SizedBox(height: 20.h),
                _WaitingList(
                  id: service.id!,
                  onApprove: _onApprove,
                  isCurrentOrganizer: isCurrentUserOrganizer,
                  onJoinAfterApproval: (customerID) {
                    _joinAfterApproval(customerID);
                  },
                  onWithdraw: _withdraw,
                ),
                SizedBox(height: 5.h),
              ],
              if (isRankedMatch && (service.players?.length ?? 0) > 0) ...[
                SizedBox(height: 20.h),
                _ScoreViewComponent(service: service),
              ],
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: MainButton(
                    enabled: isJoined,
                    label: "${"CHAT".tr(context)} $chatCount",
                    onTap: () {
                      ref.read(goRouterProvider).push(RouteNames.chat,
                          extra: [service.id ?? 0]).then((e) {
                        ref.read(chatSocketProvider.notifier).offSocket();
                        final provider =
                            fetchChatCountProvider(matchId: service.id ?? 0);
                        ref.invalidate(provider);
                      });
                    },
                  ))
            ],
          ),
        ),
      ),
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
            if (isJoined) ...[
              _leaveOpenMatch(context),
              SizedBox(height: 10.h),
            ],
            if (!service.isPast) _addToCalendarButton(context, widget.service),
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
      imageHeight: 13.w,
      imageWidth: 13.w,
      onTap: () {
        Utils.shareOpenMatch(context, widget.service);
      },
    );
  }

  SecondaryImageButton _addToCalendarButton(
      BuildContext context, ServiceDetail? service) {
    return SecondaryImageButton(
      label: "ADD_TO_CALENDAR".tr(context),
      image: AppImages.calendar.path,
      imageHeight: 15.w,
      imageWidth: 15.w,
      onTap: () {
        String title = "${getSportsName(ref)} Match";
        ref.watch(addToCalendarProvider(
          title: title,
          startDate: service!.bookingStartTime,
          endDate: service.bookingEndTime,
        ));
      },
    );
  }

  SecondaryImageButton _leaveOpenMatch(BuildContext context) {
    final int playerCount = widget.service.players?.length ?? 0;
    return SecondaryImageButton(
      label: playerCount == 1
          ? "CANCEL_MATCH".tr(context)
          : "LEAVE_OPEN_MATCH".tr(context),
      image: AppImages.crossIcon.path,
      imageHeight: 15.w,
      imageWidth: 15.w,
      onTap: () {
        _onLeave();
      },
    );
  }

  _onApprove(int playerID) async {
    final ServiceDetail service = widget.service;
    final bool? approve = await showDialog(
      context: context,
      builder: (context) => const ConfirmationDialog(
        type: ConfirmationDialogType.approveConfirm,
      ),
    );

    if (approve == true && mounted) {
      final provider =
          approvePlayerProvider(serviceID: service.id!, playerID: playerID);
      final bool? success =
          await Utils.showLoadingDialog(context, provider, ref);
      ref.invalidate(fetchServiceWaitingPlayersProvider(
          service.id!, RequestServiceType.booking));
      if (!mounted || success == null || !success) {
        return;
      }
    }
  }

  _onLeave() async {
    final ServiceDetail service = widget.service;
    final bool isLeave = (service.players?.length ?? 0) > 1;

    final CancellationPolicy? policy = await Utils.showLoadingDialog(
        context, cancellationPolicyProvider(service.id!), ref);

    if (policy == null && !mounted) {
      return;
    }
    final bool? leave = await showDialog(
      context: context,
      builder: (context) => ConfirmationDialog(
          type: isLeave
              ? ConfirmationDialogType.leave
              : ConfirmationDialogType.cancel,
          policy: policy),
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
        !isLeave
            ? "YOU_HAVE_CANCELED_THE_MATCH".tr(context)
            : "YOU_HAVE_LEFT_THE_MATCH".tr(context),
      );
    }
  }

  _joinAfterApproval(int playerID) async {
    _onJoin(false, true);
  }

  _onJoin(bool isReserve, bool isJoinApproval) async {
    final ServiceDetail service = widget.service;
    final data = await showDialog(
      context: context,
      builder: (context) {
        return _ChooseSpotDialog(
          players: service.players!,
        );
      },
    );
    if (!mounted || data == null) {
      return;
    }
    final (int index, int? otherTeamMemberPlayerID) = data;
    ConfirmationDialogType dialogType = ConfirmationDialogType.join;
    if (isReserve) {
      dialogType = ConfirmationDialogType.reserve;
      isApprovalNeeded = false;
    }
    if (isApprovalNeeded && !isJoinApproval) {
      dialogType = ConfirmationDialogType.approvalNeeded;
    }
    final bool? join = await showDialog(
      context: context,
      builder: (context) => ConfirmationDialog(
        type: dialogType,
      ),
    );
    final playerID = ref.read(userManagerProvider).user?.user?.id;
    if (join == true && context.mounted && mounted && playerID != null) {
      final provider = fetchCourtPriceProvider(
          serviceId: service.id ?? 0,
          coachId: null,
          courtId: [service.courtId],
          durationInMin: service.duration2,
          requestType: CourtPriceRequestType.join,
          dateTime: DateTime.now());
      await Utils.showLoadingDialog(context, provider, ref);
      _callJoin(
          service: service,
          isReserve: isReserve,
          index: index,
          isJoinApproval: isJoinApproval,
          isApprovalNeeded: isApprovalNeeded && !isJoinApproval);
    }
  }

  void _callJoin(
      {required ServiceDetail service,
      required int index,
      required bool isReserve,
      required bool isApprovalNeeded,
      bool isJoinApproval = false}) async {
    final provider = joinServiceProvider(service.id!,
        position: index + 1,
        isEvent: false,
        isOpenMatch: true,
        isDouble: false,
        isReserve: isReserve,
        isLesson: false,
        isApprovalNeeded: isApprovalNeeded);
    final double? price = await Utils.showLoadingDialog(context, provider, ref);

    if (!mounted || price == null) {
      return;
    }
    if (isApprovalNeeded && price < 0) {
      showDialog(
        context: context,
        builder: (_) => _WaitingForApprovalDialog(serviceID: service.id!),
      ).then((e) => ref.invalidate(fetchServiceWaitingPlayersProvider(
          service.id!, RequestServiceType.booking)));
      return;
    }

    if (price == 0) {
      await Utils.showMessageDialog(
        context,
        "SOMETHING_WENT_WRONG".tr(context),
      );
      return;
    }

    final data = await showDialog(
      context: context,
      builder: (context) {
        return PaymentInformation(
            transactionRequestType: TransactionRequestType.normal,
            type: PaymentDetailsRequestType.join,
            locationID: service.service!.location!.id!,
            isJoiningApproval: isJoinApproval,
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
        isReserve
            ? "YOU_HAVE_RESERVED_A_SPOT_SUCCESSFULLY".tr(context)
            : "YOU_HAVE_JOINED_THE_MATCH".tr(context),
      );
    }
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

  _withdraw(int id) {
    if (id == -1) {
      return;
    }
    showDialog(
      context: context,
      builder: (context) => const ConfirmationDialog(
        type: ConfirmationDialogType.withdraw,
      ),
    ).then(
      (value) {
        if (value == true) {
          final provider = approvePlayerProvider(
              isApprove: false, serviceID: widget.service.id!, playerID: id);
          if (mounted) {
            Utils.showLoadingDialog(context, provider, ref).then((value) {
              if (value == true) {
                ref.invalidate(
                  fetchServiceWaitingPlayersProvider(
                      widget.service.id!, RequestServiceType.booking),
                );
                Utils.showMessageDialog(
                    context, "YOU_HAVE_WITHDRAWN_FROM_THE_MATCH".tr(context));
              }
            });
          }
        }
      },
    );
  }
}
