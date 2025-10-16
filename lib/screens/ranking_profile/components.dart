part of 'ranking_profile.dart';

class _PlayerRanking extends StatelessWidget {
  const _PlayerRanking({
    required this.level,
    required this.reliability,
    required this.matchPlayed,
  });

  final double level;
  final double? reliability;
  final int? matchPlayed;

  @override
  Widget build(BuildContext context) {
    int rounded = level.floor();
    double decimal = level - rounded.toDouble();
    return Container(
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
          ),
          SizedBox(height: 10.h),
          if(reliability != null && matchPlayed != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'LEVEL_RELIABILITY'.tr(context),
                      style: AppTextStyles.sansRegular13.copyWith(
                          color: AppColors.white),
                    ),
                    Text(
                      ': ',
                      style: AppTextStyles.sansRegular13.copyWith(
                          color: AppColors.white),
                    ),
                    Text(
                      reliability != null
                          ? '${reliability?.toStringAsFixed(0)}%'
                          : '0%',
                      style: AppTextStyles.sansMedium13.copyWith(
                          color: AppColors.white),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'MATCHES_PLAYED'.tr(context),
                      style: AppTextStyles.sansRegular13.copyWith(
                          color: AppColors.white),
                    ),
                    Text(
                      ':  ',
                      style: AppTextStyles.sansRegular13.copyWith(
                          color: AppColors.white),
                    ),
                    Container(
                      width: 35.w,
                      padding: EdgeInsets.symmetric(vertical: 2),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(100.r)
                      ),
                      child: Text(
                        '${matchPlayed ?? 0}',
                        style: AppTextStyles.sansMedium13.copyWith(
                            color: AppColors.darkBlue),
                      )
                    )

                  ],
                ),
              ),
            ],
          ),
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

                    if (assessment.isEvent) {
                      return InkWell(
                          onTap: () {
                            ref
                                .read(goRouterProvider)
                                .push("${RouteNames.eventInfo}/${assessment.id}");
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: UserLessonsEventsCard(
                              booking: assessment.toUserBookings(),
                              isPast: true,
                            ),
                          ));
                    }

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

class _RankingProgression extends ConsumerStatefulWidget {
  const _RankingProgression({required this.userId, required this.sportName});

  final int userId;
  final String sportName;

  @override
  ConsumerState<_RankingProgression> createState() =>
      _RankingProgressionState();
}

class _RankingProgressionState extends ConsumerState<_RankingProgression> {
  int selectedMatchCount = 10;

  @override
  Widget build(BuildContext context) {
    final matchLevelsAsync = ref.watch(
      getUserMatchLevelsProvider(
        userId: widget.userId,
        matchNumber: selectedMatchCount,
        sportName: widget.sportName,
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'RANKING_PROGRESSION'.trU(context),
          style: AppTextStyles.balooMedium17,
        ),
        SizedBox(height: 10.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: AppColors.clay05,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _MatchCountButton(
                label: '10 matches',
                isSelected: selectedMatchCount == 10,
                onTap: () => setState(() => selectedMatchCount = 10),
              ),
              SizedBox(width: 10.w),
              _MatchCountButton(
                label: '25 matches',
                isSelected: selectedMatchCount == 25,
                onTap: () => setState(() => selectedMatchCount = 25),
              ),
            ],
          ),
        ),
        matchLevelsAsync.when(
          data: (matchLevels) {
            if (matchLevels.isEmpty) {
              return SecondaryText(text: "No ranking data available");
            }
            return _RankingChart(matchLevels: matchLevels);
          },
          loading: () => Container(
            height: 200.h,
            alignment: Alignment.center,
            child: const CupertinoActivityIndicator(),
          ),
          error: (error, stackTrace) => SecondaryText(text: error.toString()),
        ),
      ],
    );
  }
}

class _MatchCountButton extends StatelessWidget {
  const _MatchCountButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 20.h,
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.oak : Colors.transparent,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Text(
          label,
          style: AppTextStyles.sansMedium15.copyWith(
            fontSize: 14.sp,
            color: isSelected ? AppColors.white : AppColors.darkBlue.withOpacity(0.7),
          ),
        ),
      ),
    );
  }
}

class _RankingChart extends StatelessWidget {
  const _RankingChart({required this.matchLevels});

  final List<MatchLevel> matchLevels;

  // Optimize levels list to make it user-friendly
  List<double> _optimizeLevelsList(List<double> allLevels) {
    if (allLevels.isEmpty) return [];

    // Remove consecutive duplicates
    final List<double> withoutConsecutiveDuplicates = [];
    for (int i = 0; i < allLevels.length; i++) {
      if (i == 0 || allLevels[i] != allLevels[i - 1]) {
        withoutConsecutiveDuplicates.add(allLevels[i]);
      }
    }

    // If still too long (more than 10 points), reduce by keeping important points
    final int maxPoints = 10;
    if (withoutConsecutiveDuplicates.length > maxPoints) {
      final List<double> reduced = [];

      // Always keep first point
      reduced.add(withoutConsecutiveDuplicates.first);

      // Calculate how many points to sample from the middle
      final int middlePointsNeeded = maxPoints - 2; // -2 for first and last
      final double step = (withoutConsecutiveDuplicates.length - 2) / middlePointsNeeded;

      // Sample middle points evenly
      for (int i = 1; i < middlePointsNeeded + 1; i++) {
        final int index = (i * step).round();
        if (index < withoutConsecutiveDuplicates.length - 1) {
          reduced.add(withoutConsecutiveDuplicates[index]);
        }
      }

      // Always keep last point
      reduced.add(withoutConsecutiveDuplicates.last);

      return reduced;
    }

    return withoutConsecutiveDuplicates;
  }

  @override
  Widget build(BuildContext context) {
    final allLevels = matchLevels.map((e) => e.level ?? 0.0).toList();

    // Make list user-friendly: remove duplicates and limit size
    final levels = _optimizeLevelsList(allLevels);

    // Calculate min and max with better range
    final minLevel = levels.reduce((a, b) => a < b ? a : b);
    final maxLevel = levels.reduce((a, b) => a > b ? a : b);

    // Ensure a minimum range for better visualization
    double chartMin, chartMax;
    final range = maxLevel - minLevel;

    if (range < 0.5) {
      // If range is too small, add padding
      final center = (maxLevel + minLevel) / 2;
      chartMin = center - 1.0;
      chartMax = center + 1.0;
    } else {
      chartMin = minLevel - (range * 0.2);
      chartMax = maxLevel + (range * 0.2);
    }

    // Round to nice numbers
    chartMin = (chartMin * 2).floorToDouble() / 2; // Round down to nearest 0.5
    chartMax = (chartMax * 2).ceilToDouble() / 2;  // Round up to nearest 0.5

    return Container(
      height: 180.h,
      child: CustomPaint(
        size: Size(double.infinity, 180.h),
        painter: _ChartPainter(
          levels: levels,
          minLevel: chartMin,
          maxLevel: chartMax,
        ),
      ),
    );
  }
}

class _ChartPainter extends CustomPainter {
  final List<double> levels;
  final double minLevel;
  final double maxLevel;

  _ChartPainter({
    required this.levels,
    required this.minLevel,
    required this.maxLevel,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (levels.isEmpty) return;

    // Define chart area
    final chartLeft = 10.w;
    final chartTop = 20.h;
    final chartWidth = size.width - chartLeft - 20.w;
    final chartHeight = size.height - chartTop - 30.h;
    final chartBottom = chartTop + chartHeight;

    // Draw white background
    final backgroundPaint = Paint()
      ..color = AppColors.white
      ..style = PaintingStyle.fill;

    final backgroundRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(12.r),
    );
    canvas.drawRRect(backgroundRect, backgroundPaint);

    // Grid lines paint (subtle horizontal lines)
    final gridPaint = Paint()
      ..color = AppColors.darkBlue.withOpacity(0.05)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Draw horizontal grid lines
    final horizontalLines = 7;
    for (int i = 0; i <= horizontalLines; i++) {
      final y = chartTop + (chartHeight * i / horizontalLines);
      canvas.drawLine(
        Offset(chartLeft, y),
        Offset(chartLeft + chartWidth, y),
        gridPaint,
      );
    }

    // Main chart line
    final paint = Paint()
      ..color = AppColors.oak
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.oak.withOpacity(0.3),
          AppColors.oak.withOpacity(0.05),
        ],
      ).createShader(Rect.fromLTWH(chartLeft, chartTop, chartWidth, chartHeight))
      ..style = PaintingStyle.fill;

    final path = Path();
    final fillPath = Path();
    final points = <Offset>[];

    // Calculate points
    for (int i = 0; i < levels.length; i++) {
      double x;
      if (levels.length == 1) {
        // Center single point
        x = chartLeft + chartWidth / 2;
      } else {
        x = chartLeft + (i / (levels.length - 1)) * chartWidth;
      }

      double normalizedLevel;
      if (maxLevel == minLevel) {
        // Handle case where all values are the same
        normalizedLevel = 0.5; // Place in middle
      } else {
        normalizedLevel = (levels[i] - minLevel) / (maxLevel - minLevel);
      }

      final y = chartBottom - (normalizedLevel * chartHeight);

      points.add(Offset(x, y));

      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, chartBottom);
        fillPath.lineTo(x, y);
      } else {
        // Use straight lines between points
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
    }

    // Only draw lines and fill if we have more than one point
    if (levels.length > 1) {
      // Complete fill path
      fillPath.lineTo(chartLeft + chartWidth, chartBottom);
      fillPath.lineTo(chartLeft, chartBottom);
      fillPath.close();

      // Draw filled area
      canvas.drawPath(fillPath, fillPaint);

      // Draw line
      canvas.drawPath(path, paint);
    }

    // Draw level values above each point on the line
    for (int i = 0; i < points.length; i++) {
      final isLastPoint = i == points.length - 1;

      if (isLastPoint) {
        // Draw black circle for last point
        canvas.drawCircle(points[i], 12, Paint()..color = AppColors.darkBlue);

        // Draw level value in white inside the black circle
        final textPainter = TextPainter(
          text: TextSpan(
            text: levels[i].toStringAsFixed(1),
            style: TextStyle(
              color: AppColors.white,
              fontSize: 10.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(points[i].dx - textPainter.width / 2, points[i].dy - textPainter.height / 2),
        );
      } else {
        // Draw level values above the line for all other points
        final textPainter = TextPainter(
          text: TextSpan(
            text: levels[i].toStringAsFixed(2),
            style: TextStyle(
              color: AppColors.darkBlue.withOpacity(0.7),
              fontSize: 9.sp,
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(points[i].dx - textPainter.width / 2, points[i].dy - 20),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
