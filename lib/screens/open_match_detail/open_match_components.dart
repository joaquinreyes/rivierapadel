part of 'open_match_detail.dart';

class _RankedOrFriendly extends StatelessWidget {
  const _RankedOrFriendly({
    this.isRanked = true,
  });

  final bool isRanked;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: inset.BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: kInsetShadow,
      ),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      child: Row(
        children: [
          _buildWidget("FRIENDLY".tr(context), !isRanked),
          _buildWidget("RANKED".tr(context), isRanked),
        ],
      ),
    );
  }

  _buildWidget(String text, bool isSelected) {
    return Container(
      decoration: BoxDecoration(
        color: isSelected ? AppColors.yellow : Colors.transparent,
        borderRadius: BorderRadius.circular(10.r),
      ),
      padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
      child: Text(
        text,
        style: AppTextStyles.panchangMedium10.copyWith(
            color: isSelected ? AppColors.green : AppColors.green70,
            fontWeight: isSelected ? FontWeight.w400 : FontWeight.w300),
      ),
    );
  }
}

class _OrganizerNote extends StatelessWidget {
  final String note;
  const _OrganizerNote({required this.note});

  @override
  Widget build(BuildContext context) {
    if (note.trim().isEmpty) {
      return const SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          child: Text(
            "NOTE_FROM_ORGANIZER".tr(context),
            style: AppTextStyles.panchangBold13,
          ),
        ),
        SizedBox(height: 5.h),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: AppColors.darkGreen5,
            borderRadius: BorderRadius.circular(10.r),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 12.w,
            vertical: 6.h,
          ),
          child: Text(note, style: AppTextStyles.helveticaLight12),
        ),
      ],
    );
  }
}

class _InfoCard extends ConsumerWidget {
  const _InfoCard({required this.service});
  final ServiceDetail service;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 15.h,
        vertical: 15.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.green,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Row(
              children: [
                Text(
                  'ORGANIZER'.tr(context),
                  style: AppTextStyles.panchangMedium12
                      .copyWith(color: AppColors.white),
                ),
                const Spacer(),
                Text(
                  'BOOKING'.tr(context),
                  style: AppTextStyles.panchangMedium12
                      .copyWith(color: AppColors.white),
                ),
              ],
            ),
          ),
          const CDivider(color: AppColors.lightGrey, thickness: 0.6),
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 1,
                child: _organizer(context, service.organizer, ref),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      service.formattedDateStartEndTime,
                      style: AppTextStyles.helveticaLight13
                          .copyWith(color: AppColors.white),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      "${service.courts?.first.courtName ?? ""} | ${service.service?.location?.locationName ?? ""}",
                      style: AppTextStyles.helveticaLight13
                          .copyWith(color: AppColors.white),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      "LEVEL | ${Utils.formatPrice(service.service?.price)}",
                      style: AppTextStyles.helveticaLight13
                          .copyWith(color: AppColors.white),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 15.h),
            ],
          ),
        ],
      ),
    );
  }

  Widget _organizer(
      BuildContext context, ServiceDetail_Players? organizer, WidgetRef ref) {
    if (organizer == null) {
      return SizedBox(
        child: Text("NO_ORGANIZER".tr(context),
            textAlign: TextAlign.center,
            style:
                AppTextStyles.panchangBold9.copyWith(color: AppColors.white)),
      );
    }
    String level =
        organizer.customer?.level(getSportsName(ref))?.toString() ?? "N/A";
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            final id = organizer.customer?.id ?? -1;
            if (id != -1) {
              ref.read(goRouterProvider).push(
                    "${RouteNames.rankingProfile}/$id",
                  );
            }
          },
          child: NetworkCircleImage(
            // path: participant?.imgUrl,
            path: organizer.customer?.profileUrl,
            width: 40.h,
            height: 40.h,
          ),
        ),
        SizedBox(height: 5.h),
        Text(
          organizer.getCustomerName,
          textAlign: TextAlign.center,
          style: AppTextStyles.panchangBold9.copyWith(color: AppColors.white),
        ),
        Text(
          // "LEVEL • SIDE",
          level,
          textAlign: TextAlign.center,
          style:
              AppTextStyles.helveticaLight11.copyWith(color: AppColors.white),
        ),
      ],
    );
  }
}

class _WaitingList extends ConsumerStatefulWidget {
  const _WaitingList(
      {required this.id,
      required this.onApprove,
      required this.onJoinAfterApproval,
      required this.onWithdraw,
      required this.isCurrentOrganizer});
  final int id;
  final Function(int) onApprove;
  final Function(int) onJoinAfterApproval;
  final Function(int) onWithdraw;
  final bool isCurrentOrganizer;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => __WaitingListState();
}

class __WaitingListState extends ConsumerState<_WaitingList> {
  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(fetchServiceWaitingPlayersProvider(
        widget.id, RequestServiceType.booking));
    return provider.when(
      skipLoadingOnRefresh: true,
      data: (list) {
        final data = list.map((e) => e).toList();
        if (widget.isCurrentOrganizer) {
          data.removeWhere((element) => element.isApproved);
        } else {
          final currentID = ref.read(userProvider)?.user?.id;
          data.removeWhere((element) => element.customer?.id != currentID);
        }
        if (data.isEmpty) {
          return Container();
        }
        if (!widget.isCurrentOrganizer) {
          return WaitingListApprovalStatus(
            data: data.first,
            onJoin: widget.onJoinAfterApproval,
            onWithdraw: widget.onWithdraw,
            isForEvent: false,
          );
        }
        return OpenMatchWaitingForApprovalPlayers(
          data: data,
          onApprove: widget.onApprove,
        );
      },
      error: (error, stackTrace) {
        return SecondaryText(text: error.toString());
      },
      loading: () => const Center(
        child: CupertinoActivityIndicator(radius: 5),
      ),
    );
  }
}

class _ApprovedList extends ConsumerStatefulWidget {
  const _ApprovedList({required this.id, required this.isCurrentOrganizer});

  final int id;
  final bool isCurrentOrganizer;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => __ApprovedListState();
}

class __ApprovedListState extends ConsumerState<_ApprovedList> {
  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(fetchServiceWaitingPlayersProvider(
        widget.id, RequestServiceType.booking));
    return provider.when(
      skipLoadingOnRefresh: true,
      data: (list) {
        final data = list.map((e) => e).toList();
        List<ServiceWaitingPlayers> approvedPlayers =
            data.where((item) => item.isApproved).toList();
        return ApprovedListUserJoin(data: approvedPlayers);
      },
      error: (error, stackTrace) {
        return SecondaryText(text: error.toString());
      },
      loading: () => const Center(
        child: CupertinoActivityIndicator(radius: 5),
      ),
    );
  }
}

class _ScoreViewComponent extends ConsumerStatefulWidget {
  const _ScoreViewComponent({required this.service});

  final ServiceDetail service;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      __ScoreComponentState();
}

class __ScoreComponentState extends ConsumerState<_ScoreViewComponent> {
  @override
  Widget build(BuildContext context) {
    final players = widget.service.players?.map((e) => e).toList();
    final assessment = ref.watch(fetchAssessmentProvider(widget.service.id!));
    //SORT BY POSITION
    final Map<int, ServiceDetail_Players?> positions = {
      1: null,
      2: null,
      3: null,
      4: null
    };

    for (var position in positions.keys) {
      final index =
          players?.indexWhere((element) => element.position == position) ?? -1;
      positions[position] = index != -1 ? (players?[index]) : null;
    }

    final playerA = positions[1];
    final playerB = positions[2];
    final playerC = positions[3];
    final playerD = positions[4];

    return assessment.when(
      data: (data) {
        return _body(data, playerA, playerB, playerC, playerD);
      },
      error: (error, stackTrace) {
        return _body(null, playerA, playerB, playerC, playerD);
      },
      loading: () {
        return const Center(
          child: CupertinoActivityIndicator(radius: 5),
        );
      },
    );
  }

  Column _body(
      AssessmentResModel? data,
      ServiceDetail_Players? playerA,
      ServiceDetail_Players? playerB,
      ServiceDetail_Players? playerC,
      ServiceDetail_Players? playerD) {
    List<int?> teamAScores = [
      data?.teamA?.score1,
      data?.teamA?.score2,
      data?.teamA?.score3
    ];
    List<int?> teamBScores = [
      data?.teamB?.score1,
      data?.teamB?.score2,
      data?.teamB?.score3
    ];
    Map<String, bool> result = determineWinner(teamAScores, teamBScores);
    bool isDraw = result['isDraw']!;
    bool isAWin = result['isAWin']!;

    final isMatchScoreFilled =
        teamAScores.every((element) => element != null) &&
            teamBScores.every((element) => element != null);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "SCORE",
          style: AppTextStyles.panchangBold13,
        ),
        SizedBox(height: 10.h),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: AppColors.green5, borderRadius: BorderRadius.circular(7)),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.service.formatBookingDate.toUpperCase(),
                    style: AppTextStyles.helveticaBold14,
                  ),
                  _enterButton(teamAScores, teamBScores),
                  Text(
                    widget.service.openMatchLevelRange,
                    style: AppTextStyles.helveticaRegular12,
                  )
                ],
              ),
              SizedBox(height: 10.h),
              const CDivider(),
              SizedBox(height: 5.h),
              _TeamScore(
                playerA: playerA,
                playerB: playerB,
                scores: teamAScores,
                isWinner: !isDraw && isAWin && isMatchScoreFilled,
                isDraw: isDraw && isMatchScoreFilled,
              ),
              SizedBox(height: 10.h),
              const CDivider(),
              _TeamScore(
                playerA: playerC,
                playerB: playerD,
                scores: teamBScores,
                isWinner: !isAWin && !isDraw && isMatchScoreFilled,
                isDraw: isDraw && isMatchScoreFilled,
              ),
              SizedBox(height: 5.h),
            ],
          ),
        ),
      ],
    );
  }

  Widget _enterButton(List<int?>? teamAScores, List<int?>? teamBScores) {
    bool isEnabled = false;

    DateTime endTime = widget.service.bookingEndTime;
    DateTime now = DubaiDateTime.now().dateTime;
    // Check if all other 3 users are reserved
    int reserveCount = 0;
    widget.service.players?.forEach((element) {
      if (element.reserved == true) {
        reserveCount++;
      }
    });
    if (now.isAfter(endTime) &&
        now.difference(endTime).inHours < 24 &&
        widget.service.players?.length == 4 &&
        reserveCount < 3) {
      isEnabled = true;
    }

    return InkWell(
      onTap: isEnabled
          ? () async {
              await showDialog(
                context: context,
                builder: (context) {
                  return EnterMatchResults(
                    service: widget.service,
                    teamAScore: teamAScores,
                    teamBScore: teamBScores,
                  );
                },
              );
              if (mounted) {
                ref.invalidate(fetchServiceDetailProvider(widget.service.id!));
                ref.invalidate(fetchAssessmentProvider(widget.service.id!));
              }
            }
          : null,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 12),
        decoration: BoxDecoration(
          color: isEnabled ? AppColors.yellow : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            if (isEnabled)
              const BoxShadow(
                color: Color(0x26000000),
                blurRadius: 4,
                offset: Offset(0, 4),
                spreadRadius: 0,
              )
          ],
        ),
        child: Text(
          "ENTER_MATCH_RESULTS".tr(context),
          style: AppTextStyles.helveticaRegular14.copyWith(
            color: isEnabled ? AppColors.darkGreen : AppColors.green25,
          ),
        ),
      ),
    );
  }
}

class _TeamScore extends ConsumerWidget {
  const _TeamScore(
      {required this.playerA,
      required this.playerB,
      this.scores,
      required this.isWinner,
      this.isDraw = false});

  final ServiceDetail_Players? playerA;
  final ServiceDetail_Players? playerB;
  final List<int?>? scores;
  final bool isWinner;
  final bool isDraw;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _customerName(playerA, context),
              _customerName(playerB, context),
            ],
          ),
        ),
        Expanded(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              3,
              (index) {
                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(top: 6, left: 4, right: 4),
                    child: _scoreItem(index),
                  ),
                );
              },
            ),
          ),
        ),
        // Expanded(child: Container())
        if (isWinner && !isDraw) Expanded(child: _winnerContainer(context)),
        if (isDraw) Expanded(child: _drawContainer(context)),

        if (!isWinner && !isDraw) Expanded(child: Container())
      ],
    );
  }

  _scoreItem(int index) {
    final score =
        scores != null && index < scores!.length ? scores![index] : null;
    if (score != null) {
      return Text(
        score.toString(),
        style: AppTextStyles.panchangMedium11.copyWith(
          fontWeight: isWinner ? FontWeight.w700 : FontWeight.w400,
          height: 0.6,
          fontSize: isWinner ? 13 : 11,
          color: AppColors.green.withOpacity(
            isWinner ? 1 : 0.5,
          ),
        ),
      );
    }
    return Container(
      height: 1,
      color: AppColors.darkGreen,
    );
  }

  _winnerContainer(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 15),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        color: AppColors.yellow50,
      ),
      child: Center(
        child: Text(
          'WINNERS'.tr(context),
          style: AppTextStyles.helveticaLight12.copyWith(
            height: 0.6,
            color: AppColors.darkGreen,
          ),
        ),
      ),
    );
  }

  _drawContainer(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 15),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        color: AppColors.yellow50,
      ),
      child: Center(
        child: Text(
          'DRAW'.tr(context),
          style: AppTextStyles.helveticaLight12
              .copyWith(height: 0.6, color: AppColors.darkGreen),
        ),
      ),
    );
  }

  Text _customerName(ServiceDetail_Players? player, BuildContext context) {
    if (player == null) {
      return Text(
        "-",
        style: AppTextStyles.helveticaLight13,
      );
    }
    bool isReserved = player.reserved ?? false;

    final customerName =
        "${player.getCustomerName} ${player.customer?.lastName ?? ""}"
            .capitalizeFirst;

    return Text(
      (isReserved)
          ? "RESERVED".tr(context)
          : customerName.isNotEmpty
              ? customerName
              : "-",
      style:
          AppTextStyles.helveticaLight13.copyWith(color: AppColors.darkGreen),
    );
  }
}
