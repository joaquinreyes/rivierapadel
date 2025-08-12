import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:acepadel/app_styles/app_colors.dart';
import 'package:acepadel/app_styles/app_text_styles.dart';
import 'package:acepadel/components/c_divider.dart';
import 'package:acepadel/components/main_button.dart';
import 'package:acepadel/components/participant_slot.dart';
import 'package:acepadel/components/secondary_button.dart';
import 'package:acepadel/globals/constants.dart';
import 'package:acepadel/globals/images.dart';
import 'package:acepadel/globals/utils.dart';
import 'package:acepadel/managers/user_manager.dart';
import 'package:acepadel/models/assessment_req_model.dart';
import 'package:acepadel/models/service_detail_model.dart';
import 'package:acepadel/repository/play_repo.dart';
import 'package:acepadel/utils/custom_extensions.dart';

import '../../../components/custom_dialog.dart';

part 'pin_input.dart';

part 'components.dart';

part 'provider.dart';

class EnterMatchResults extends ConsumerStatefulWidget {
  const EnterMatchResults(
      {super.key, required this.service, this.teamAScore, this.teamBScore});

  final ServiceDetail service;
  final List<int?>? teamAScore;
  final List<int?>? teamBScore;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      __EnterMatchResultsState();
}

class __EnterMatchResultsState extends ConsumerState<EnterMatchResults> {
  @override
  void initState() {
    _initialize();
    super.initState();
  }

  void _initialize() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.invalidate(_teamAScoreProvider);
      ref.invalidate(_teamBScoreProvider);
      ref.invalidate(_isDrawProvider);
      ref.invalidate(canProceed);
      if (widget.teamAScore != null) {
        ref.read(_teamAScoreProvider.notifier).state =
            List.from(widget.teamAScore!);
        ref.read(_teamBScoreProvider.notifier).state =
            List.from(widget.teamBScore!);
        _setIfDraw(ref);
      }

      List<ServiceDetail_Players> sortedPlayers =
          List.from(widget.service.players ?? [])
            ..sort((a, b) => a.position!.compareTo(b.position!));

      final currentUserId = ref.read(userProvider)?.user?.id;
      myPrint("Match Result 1: ${sortedPlayers.length}");
      try {
        ref.read(currentPlayerID.notifier).state = sortedPlayers
                .firstWhere((p) => p.customer?.id == currentUserId)
                .id ??
            0;
      } catch (e) {
        myPrint("Match Result e: ${e.toString()}");
      }
      myPrint("Match Result 2: ${sortedPlayers.length}");
      ref.read(_sortedPlayersProvider.notifier).state =
          List.from(sortedPlayers);
      myPrint("Match Result 2: ${sortedPlayers.length}");
      var otherPlayers = sortedPlayers
          .where((p) => p.customer?.id != currentUserId || p.reserved == true)
          .toList();

      ref.read(_otherPlayersProvider.notifier).state = List.from(otherPlayers);

      var otherNonReservedPlayers =
          otherPlayers.where((p) => p.reserved != true).toList();
      ref.read(_otherNonReservedPlayersProvider.notifier).state =
          List.from(otherNonReservedPlayers);

      Map<String, double> assessments = {};
      Map<String, int> positions = {};

      for (var player in ref.read(_sortedPlayersProvider)) {
        positions[player.id!.toString()] = player.position!;
      }

      for (var player in ref.read(_otherNonReservedPlayersProvider)) {
        if (player.customer?.id != null) {
          assessments[player.id.toString()] =
              player.customer?.levelD("padel") ?? 0;
        }
      }

      ref.read(_assesmentReqModelProvider).assessments = assessments;
      ref.read(_assesmentReqModelProvider).positions = positions;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomDialog(
        child: Flexible(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "ENTER_MATCH_RESULTS".trU(context),
                  textAlign: TextAlign.center,
                  style: AppTextStyles.popupHeaderTextStyle,
                ),
                SizedBox(height: 5.h),
                Text("ALSO_HELP_US_RANK".tr(context),
                    textAlign: TextAlign.center,
                    style: AppTextStyles.balooMedium12
                        .copyWith(color: AppColors.white)),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "YOUR_OPEN_MATCH".trU(context),
                      style: AppTextStyles.balooMedium12
                          .copyWith(color: AppColors.white),
                    ),
                    Text(
                      widget.service.openMatchLevelRange,
                      style: AppTextStyles.balooMedium12
                          .copyWith(color: AppColors.white),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                _MatchResultForms(service: widget.service),
                const _RankOtherPlayers(),
                SizedBox(height: 20.h),
                MainButton(
                  enabled: ref.watch(canProceed),
                  label: "ENTER_RESULTS".tr(context),
                  isForPopup: true,
                  onTap: () async {
                    final teamAScoreR = <String, int>{};
                    final teamBScoreR = <String, int>{};
                    final isDraw = ref.watch(_isDrawProvider);
                    if (isDraw) {
                      teamAScoreR["1"] = 0;
                      teamAScoreR["2"] = 0;
                      teamAScoreR["3"] = 0;
                      teamBScoreR["1"] = 0;
                      teamBScoreR["2"] = 0;
                      teamBScoreR["3"] = 0;
                    } else {
                      final teamAScore = ref.read(_teamAScoreProvider);
                      final teamBScore = ref.read(_teamBScoreProvider);
                      teamAScoreR["1"] = teamAScore[0]!;
                      teamAScoreR["2"] = teamAScore[1]!;
                      teamAScoreR["3"] = teamAScore[2]!;
                      teamBScoreR["1"] = teamBScore[0]!;
                      teamBScoreR["2"] = teamBScore[1]!;
                      teamBScoreR["3"] = teamBScore[2]!;
                    }
                    final assessmentModel =
                        ref.read(_assesmentReqModelProvider);
                    assessmentModel.teamA = teamAScoreR;
                    assessmentModel.teamB = teamBScoreR;

                    final provider = submitAssessmentProvider(
                      model: assessmentModel,
                      serviceID: widget.service.id!,
                    );
                    final done =
                        await Utils.showLoadingDialog(context, provider, ref);
                    if (done == true && context.mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void _setIfDraw(WidgetRef ref) {
  final teamAScore = ref.read(_teamAScoreProvider);
  final teamBScore = ref.read(_teamBScoreProvider);

  if (checkCanSetWinners(teamAScore, teamBScore)) {
    final results = determineWinner(teamAScore, teamBScore);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(_isDrawProvider.notifier).state = results['isDraw']!;
    });
  }
}

bool checkCanSetWinners(List<int?> teamAScore, List<int?> teamBScore) =>
    !teamBScore.contains(null) &&
    !teamAScore.contains(null) &&
    teamAScore.length == 3 &&
    teamBScore.length == 3;

Map<String, bool> determineWinner(List<int?> teamA, List<int?> teamB) {
  int scoreA = 0;
  int scoreB = 0;

  for (int i = 0; i < teamA.length; i++) {
    if ((teamA[i] ?? 0) > (teamB[i] ?? 1)) {
      scoreA++;
    } else if ((teamB[i] ?? 0) > (teamA[i] ?? 1)) {
      scoreB++;
    }
  }
  bool isDraw = scoreA == scoreB;
  bool isAWin = scoreA > scoreB;

  return {
    'isDraw': isDraw,
    'isAWin': isAWin,
  };
}
