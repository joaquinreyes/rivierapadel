part of 'ranking_profile.dart';

class _PlayerRanking extends StatelessWidget {
  const _PlayerRanking({required this.level});

  final double level;

  @override
  Widget build(BuildContext context) {
    int rounded = level.floor();
    double decimal = level - rounded.toDouble();
    return Container(
      height: 90.h,
      width: double.maxFinite,
      padding:  EdgeInsets.symmetric(vertical: 10.h,horizontal: 15.w),
      decoration: BoxDecoration(
        color: AppColors.darkBlue,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'PLAYER_RANKING'.trU(context),
                style: AppTextStyles.balooMedium14.copyWith(
                  color: AppColors.white,
                ),
              ),
              InkWell(
                onTap: () {
                  showDialogForRankingInfo(context);
                },
                borderRadius: BorderRadius.circular(7),
                child: Row(
                  children: [
                    // const Icon(Icons.info_outline_rounded,color: AppColors.white,size: 15),
                    // SizedBox(width: 2.w),
                    Text(
                      'INFO'.tr(context),
                      style: AppTextStyles.sansRegular13.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                    5.horizontalSpace,
                    Image.asset(AppImages.infoIcon.path, width: 12.w, height: 12.h,color: AppColors.white,),

                  ],
                ),
              )
            ],
          ),
          SizedBox(height: 5.h),
          Stack(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        SizedBox(height: 4.h),
                        Text(
                          '${rounded - 1}.5',
                          style: AppTextStyles.sansMedium15.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                        Container(
                          width: 2,
                          height: 7,
                          color: AppColors.white,
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: AppColors.oak,
                            borderRadius: BorderRadius.circular(100.r),
                          ),
                          child: Center(
                            child: Text(
                              level.toStringAsFixed(2),
                              style: AppTextStyles.sansMedium16.copyWith(color: AppColors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        SizedBox(height: 4.h),
                        Text(
                          '${rounded + 1}.5',
                          style: AppTextStyles.sansMedium15.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                        Container(
                          width: 2,
                          height: 7,
                          color: Colors.white.withOpacity(0.5),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 34),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    tween: Tween<double>(
                      begin: 0,
                      end: (1 + decimal) / 3,
                    ),
                    builder: (context, value, _) => LinearProgressIndicator(
                      minHeight: 10,
                      value: value,
                      color: AppColors.oak,
                      borderRadius: BorderRadius.circular(10.r),
                      backgroundColor: Colors.white,
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  const Expanded(child: SizedBox()),
                  Container(
                    width: 2,
                    height: 10,
                    color: AppColors.darkBlue,
                    margin: const EdgeInsets.only(top: 34),
                  ),
                  const Expanded(child: SizedBox()),
                  Container(
                    width: 2,
                    height: 10,
                    color: AppColors.darkBlue,
                    margin: const EdgeInsets.only(top: 34),
                  ),
                  const Expanded(child: SizedBox())
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  void showDialogForRankingInfo(context) {
    showDialog(
      context: context,
      builder: (context) {
        return const _RankingLogicDialog();
      },
    );
  }
}

class _PlayerStats extends ConsumerWidget {
  const _PlayerStats(
      {required this.customerFromAssessment, required this.customer});

  final BookingCustomerBase? customerFromAssessment;
  final User customer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String position = customer.playingSide;
    String lastEvaluations =
        (customer.last21Evaluation ?? 0).toStringAsFixed(2);
    String startedPlaying = customer.startedPlaying ?? "-";
    final date = DateTime.tryParse(startedPlaying);
    if (date != null) {
      startedPlaying = date.format("MMMM yyyy");
    } else {
      startedPlaying = "-";
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // player stats
        Text(
          'PLAYER_STATS'.trU(context),
          style: AppTextStyles.balooMedium17,
        ),
        SizedBox(height: 10.h),
        _row("AVG_LAST_21_EVALUATIONS".tr(context), lastEvaluations),
        const SizedBox(height: 8),
        _row("POSITION".tr(context), position),
        const SizedBox(height: 8),
        _row("STARTED_PLAYING".tr(context).capitalizeFirst, startedPlaying),

        // const SizedBox(height: 8),
        // _row("BEST_QUALITY".tr(context), "-"),
        // const SizedBox(height: 8),
        // _row("FAVORITE_SHOT".tr(context), "-"),
      ],
    );
  }

  _row(String txt1, String txt2) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          txt1,
          style: AppTextStyles.sansMedium16,
        ),
        Text(
          txt2,
          style: AppTextStyles.sansRegular15,
        ),
      ],
    );
  }
}

class _PastMatches extends ConsumerWidget {
  const _PastMatches({required this.assessments, required this.customer});

  final User customer;
  final List<Assessments> assessments;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String winningRate = "";

    if (customer.winningStrike != null) {
      winningRate = " ${customer.winningStrike!.toStringAsFixed(2)}%";
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'PAST_MATCHES'.trU(context),
              style: AppTextStyles.balooMedium17,
            ),
            Text(
              "${'WINNING_STRIKE'.tr(context)}$winningRate",
              style: AppTextStyles.balooMedium15,
            ),
          ],
        ),
        const SizedBox(height: 10),
        assessments.isEmpty
            ? SecondaryText(
                text: "NO_PAST_MATCHES".tr(context),
              )
            : Flexible(
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: assessments.length,
                  itemBuilder: (context, index) {
                    final assessment = assessments[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _PastMatchCard(assessment: assessment, ref: ref),
                    );
                  },
                ),
              )
      ],
    );
  }
}

class _PastMatchCard extends StatelessWidget {
  const _PastMatchCard({required this.assessment, required this.ref});

  final Assessments assessment;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    String date =
        DateTime.tryParse(assessment.date ?? "")?.format("EEE dd MMM") ?? "-";
    int? id = assessment.id;
    List<int?> teamAScore = assessment.teamAScore;
    List<int?> teamBScore = assessment.teamBScore;
    Map<String, bool> result = determineWinner(teamAScore, teamBScore);
    bool isATeamWinner = result['isAWin']!;
    bool isDraw = result['isDraw']!;
    List<ServiceDetail_Players> teamAPlayers = assessment.teamAPlayers;
    List<ServiceDetail_Players> teamBPlayers = assessment.teamBPlayers;

    final isMatchScoreFilled = teamAScore.every((element) => element != null) &&
        teamBScore.every((element) => element != null);

    return InkWell(
      onTap: () {
        ref.read(goRouterProvider).push("${RouteNames.matchInfo}/$id");
      },
      child: Container(
        decoration: BoxDecoration(
            color: AppColors.clay05,
            borderRadius: BorderRadius.circular(12.r)),
        padding: EdgeInsets.all(15.h),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  date.toUpperCase(),
                  style: AppTextStyles.sansMedium16,
                ),
                Text(
                  "LEVEL",
                  style: AppTextStyles.sansRegular15,
                )
              ],
            ),
            // const SizedBox(height: 10),
            const CDivider(),
            // const SizedBox(height: 5),
            _TeamScores(
              players: teamAPlayers,
              scores: teamAScore,
              isWinner: !isDraw && isATeamWinner && isMatchScoreFilled,
              isDraw: isDraw && isMatchScoreFilled,
            ),
            const SizedBox(height: 5),
            const CDivider(),
            const SizedBox(height: 5),
            _TeamScores(
              players: teamBPlayers,
              scores: teamBScore,
              isWinner: !isATeamWinner && !isDraw && isMatchScoreFilled,
              isDraw: isDraw && isMatchScoreFilled,
            ),
          ],
        ),
      ),
    );
  }
}

class _TeamScores extends StatelessWidget {
  const _TeamScores(
      {required this.players,
      required this.scores,
      required this.isWinner,
      required this.isDraw});

  final List<ServiceDetail_Players> players;
  final List<int?> scores;
  final bool isWinner;
  final bool isDraw;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int i = 0; i < 2; i++) _userName(players[i], context),
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
        if (isWinner && !isDraw) Expanded(child: _winnerContainer()),
        if (isDraw) Expanded(child: _drawContainer()),
        if (!isWinner && !isDraw) Expanded(child: Container())
      ],
    );
  }

  _userName(ServiceDetail_Players player, BuildContext context) {
    bool isReserved = player.reserved ?? false;
    return Text(
      isReserved ? "RESERVED".tr(context) : (player.getCustomerName.capitalizeFirst),
      style: isWinner ? AppTextStyles.gothamMedium15 : AppTextStyles.sansRegular15,
    );
  }

  _scoreItem(int index) {
    final score = index < scores.length ? scores[index] : null;
    if (score != null) {
      return Text(
        score.toString(),
        style: isWinner ? AppTextStyles.gothamMedium17 : AppTextStyles.sansRegular16,
      );
    }
    return Container(
      height: 1,
      color: AppColors.darkBlue.withOpacity(0.5),
    );
  }

  _winnerContainer() {
    return Container(
      margin: const EdgeInsets.only(left: 12),
      padding: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.r),
        color: AppColors.oak,
      ),
      child: Center(
        child: Text(
          'Winners',
          style: AppTextStyles.sansMedium16.copyWith(
            // height: 0.6,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }

  _drawContainer() {
    return Container(
      margin: const EdgeInsets.only(left: 12),
      padding: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.r),
        color: AppColors.white,
      ),
      child: Center(
        child: Text(
          'Draw',
          style: AppTextStyles.sansMedium16,
        ),
      ),
    );
  }
}

class _RankingLogicDialog extends StatelessWidget {
  const _RankingLogicDialog();

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      color: AppColors.white,
      closeIconColor: AppColors.darkBlue,
      child: Column(
        children: [
          Text(
            "RANKING_LOGIC".trU(context),
            style: AppTextStyles.popupHeaderTextStyle.copyWith(color: AppColors.darkBlue),
          ),
          SizedBox(height: 10.h),
          Text(
            "RANKING_LOGIC_DESC".tr(context),
            style:
                AppTextStyles.popupBodyTextStyle.copyWith(color: AppColors.darkBlue),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
