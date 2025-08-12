part of 'enter_match_result.dart';

class _MatchResultForms extends ConsumerStatefulWidget {
  const _MatchResultForms({required this.service});
  final ServiceDetail service;

  @override
  ConsumerState<_MatchResultForms> createState() => _MatchResultFormsState();
}

class _MatchResultFormsState extends ConsumerState<_MatchResultForms> {
  @override
  Widget build(BuildContext context) {
    final players = ref.watch(_sortedPlayersProvider);
    if (players.isEmpty) {
      return const SizedBox();
    }
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.white25,
        borderRadius: BorderRadius.circular(7),
        boxShadow: const [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 4,
            offset: Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.service.formattedDateStartTime.toUpperCase(),
                style: AppTextStyles.helveticaBold13
                    .copyWith(color: AppColors.white),
              ),
              Text(
                widget.service.service?.location?.locationName.toUpperCase() ??
                    '',
                style: AppTextStyles.helveticaBold13
                    .copyWith(color: AppColors.white),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          const CDivider(color: AppColors.white25),
          SizedBox(height: 5.h),
          _drawButton(),
          SizedBox(height: 10.h),
          if (players.length > 1)
            _SingleResultForm(
              players: [players.first, players[1]],
              isTeamA: true,
            ),
          SizedBox(height: 5.h),
          const _SwapRow(),
          SizedBox(height: 5.h),
          if (players.length > 3)
            _SingleResultForm(
              players: [players[2], players[3]],
              isTeamA: false,
            ),
        ],
      ),
    );
  }

  Align _drawButton() {
    final isDraw = ref.watch(_isDrawProvider);
    return Align(
      alignment: Alignment.centerRight,
      child: SecondaryButton(
        color: isDraw ? AppColors.yellow50 : AppColors.white,
        applyShadow: true,
        onTap: () {
          ref.invalidate(_teamAScoreProvider);
          ref.invalidate(_teamBScoreProvider);
          ref.read(_isDrawProvider.notifier).state = !isDraw;
        },
        child: Text(
          "DRAW".tr(context),
          style: AppTextStyles.helveticaRegular14.copyWith(
            color: AppColors.darkGreen,
          ),
        ),
      ),
    );
  }
}

class _SingleResultForm extends ConsumerWidget {
  const _SingleResultForm({required this.players, required this.isTeamA});
  final List<ServiceDetail_Players> players;
  final bool isTeamA;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDraw = ref.watch(_isDrawProvider.notifier).state;
    final isAWinner = ref.watch(isTeamAWinner);
    final isBWinner = ref.watch(isTeamBWinner);

    return Row(
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ParticipantSlot(
                textColor: AppColors.white,
                player: players[0],
                showLevel: false,
              ),
              ParticipantSlot(
                player: players[1],
                showLevel: false,
              ),
            ],
          ),
        ),
        Expanded(
          child: isDraw
              ? _drawWidget(context)
              : _ScoreInput(
                  scores: isTeamA
                      ? ref.read(_teamAScoreProvider)
                      : ref.read(_teamBScoreProvider),
                  index: isTeamA ? 0 : 1,
                  onChanged: (value) {
                    int? a = int.tryParse(value[0]);
                    int? b = int.tryParse(value[1]);
                    int? c = int.tryParse(value[2]);
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (isTeamA) {
                        ref.read(_teamAScoreProvider.notifier).state = [
                          a,
                          b,
                          c
                        ];
                      } else {
                        ref.read(_teamBScoreProvider.notifier).state = [
                          a,
                          b,
                          c
                        ];
                      }
                    });
                    _setIfDraw(ref);
                  },
                  isWinner: isTeamA ? isAWinner : isBWinner,
                ),
        ),
      ],
    );
  }

  _drawWidget(BuildContext context) {
    return Center(
      child: Text(
        "DRAW".trU(context),
        style: AppTextStyles.panchangMedium21.copyWith(color: AppColors.white),
      ),
    );
  }
}

class _RankOtherPlayers extends ConsumerWidget {
  const _RankOtherPlayers();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final players = ref.watch(_otherNonReservedPlayersProvider);
    final assessmentModel = ref.watch(_assesmentReqModelProvider);
    if (players.isEmpty) {
      return const SizedBox();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20.h),
        Text(
          "RANK_THE_OTHER_PLAYERS".trU(context),
          style: AppTextStyles.panchangBold12.copyWith(color: AppColors.white),
        ),
        SizedBox(height: 10.h),
        for (var i = 0; i < players.length; i++) ...[
          Row(
            children: [
              ParticipantSlot(player: players[i]),
              SizedBox(width: 20.w),
              _RankingLevelSelector(
                player: players[i],
                selectedLevel:
                    assessmentModel.assessments[players[i].id.toString()] ?? 0,
                onChanged: (value) {
                  final model = ref.read(_assesmentReqModelProvider);
                  model.assessments[players[i].id.toString()] = value;
                  ref.invalidate(_assesmentReqModelProvider);
                  ref.read(_assesmentReqModelProvider.notifier).state = model;
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ],
    );
  }
}

class _RankingLevelSelector extends StatefulWidget {
  const _RankingLevelSelector({
    required this.player,
    required this.selectedLevel,
    required this.onChanged,
  });
  final ServiceDetail_Players player;
  final double selectedLevel;
  final Function(double) onChanged;

  @override
  State<_RankingLevelSelector> createState() => _RankingLevelSelectorState();
}

class _RankingLevelSelectorState extends State<_RankingLevelSelector> {
  // bool _isOpen = false;
  List<double> levelList = [];
  @override
  void initState() {
    final playerLevel = widget.player.customer?.levelD("padel") ?? 0;

    if (playerLevel - 0.5 >= 0) {
      levelList.add(playerLevel - 0.5);
    }
    levelList.add(playerLevel);
    if (playerLevel + 0.5 <= 7.0) {
      levelList.add(playerLevel + 0.5);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "SELECT_PLAYER_LEVEL".tr(context),
          style:
              AppTextStyles.panchangMedium10.copyWith(color: AppColors.white),
        ),
        SizedBox(height: 5.h),
        Container(
          decoration: BoxDecoration(
            color: AppColors.white25,
            borderRadius: BorderRadius.circular(7),
            boxShadow: const [
              BoxShadow(
                color: Color(0x11000000),
                blurRadius: 4,
                offset: Offset(0, 4),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Row(
            children: levelList.map((e) {
              bool isSelected = widget.selectedLevel == e;
              return Expanded(
                child: InkWell(
                  onTap: () {
                    widget.onChanged(e);
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color:
                          isSelected ? AppColors.yellow50 : Colors.transparent,
                      borderRadius: BorderRadius.circular(7),
                      boxShadow: isSelected
                          ? const [
                              BoxShadow(
                                color: Color(0x11000000),
                                blurRadius: 4,
                                offset: Offset(0, 4),
                                spreadRadius: 0,
                              ),
                            ]
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        e.toStringAsFixed(2),
                        style: AppTextStyles.helveticaRegular14.copyWith(
                            color: isSelected
                                ? AppColors.darkGreen
                                : AppColors.white),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        )
      ],
    ));
  }
}

class _ScoreInput extends StatelessWidget {
  const _ScoreInput({
    required this.isWinner,
    required this.onChanged,
    required this.index,
    this.scores,
  });
  final bool isWinner;
  final Function(List<String>) onChanged;
  final int index;
  final List<int?>? scores;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isWinner ? AppColors.yellow : Colors.transparent,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Column(
        children: [
          if (isWinner)
            Text(
              "WINNERS".tr(context),
              style: AppTextStyles.panchangMedium21.copyWith(
                color: AppColors.green,
              ),
            ),
          CustomNumberInput(
            onChanged: onChanged,
            color: isWinner ? AppColors.green : AppColors.white,
            index: index,
            initialScore: scores,
          ),
        ],
      ),
    );
  }
}

class _SwapRow extends StatelessWidget {
  const _SwapRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Spacer(flex: 2),
        InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => const _SwapDialog(),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(7),
            ),
            child: Center(
              child: Image.asset(
                AppImages.refresh.path,
                width: 13.w,
                height: 13.w,
              ),
            ),
          ),
        ),
        const Spacer(flex: 5),
        Text(
          "V/S",
          style: AppTextStyles.panchangBold12.copyWith(color: AppColors.white),
        ),
        const Spacer(flex: 3),
      ],
    );
  }
}

class _SwapDialog extends ConsumerStatefulWidget {
  const _SwapDialog();

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => __SwapDialogState();
}

class __SwapDialogState extends ConsumerState<_SwapDialog> {
  @override
  Widget build(BuildContext context) {
    final players = ref.watch(_otherPlayersProvider);
    return CustomDialog(
        child: Column(
      children: [
        Text(
          "WHO_DID_YOU_PLAY_WITH".trU(context),
          style: AppTextStyles.popupHeaderTextStyle,
        ),
        SizedBox(height: 20.h),
        Text(
          "CLICK_ON_THE_PLAYER_THAT_WAS_ON_YOUR_TEAM".trU(context),
          style: AppTextStyles.popupBodyTextStyle,
        ),
        SizedBox(height: 15.h),
        Row(
          children: [
            for (var i = 0; i < players.length; i++)
              Expanded(
                child: InkWell(
                    onTap: () {
                      onTap(players[i].id!);
                    },
                    child:
                        ParticipantSlot(player: players[i], showLevel: false)),
              ),
          ],
        )
      ],
    ));
  }

  onTap(int playerId) {
    final players = ref.read(_sortedPlayersProvider);
    final assesmentModel = ref.read(_assesmentReqModelProvider);
    final myPlayerID = ref.read(currentPlayerID);
    final positions = assesmentModel.positions;
    final oldPOS = positions[playerId.toString()]!;
    final myPOS = positions[myPlayerID.toString()]!;
    int newPOS;
    if (myPOS.isEven) {
      newPOS = myPOS - 1;
    } else {
      newPOS = myPOS + 1;
    }
    final personAtNewPos =
        positions.entries.firstWhere((element) => element.value == newPOS).key;

    positions[playerId.toString()] = newPOS;
    positions[personAtNewPos.toString()] = oldPOS;
    assesmentModel.positions = positions;
    ref.invalidate(_assesmentReqModelProvider);
    ref.read(_assesmentReqModelProvider.notifier).state = assesmentModel;
    // sort the players according to the new positions
    final sortedPlayers = players.toList()
      ..sort((a, b) =>
          positions[a.id.toString()]!.compareTo(positions[b.id.toString()]!));
    ref.invalidate(_sortedPlayersProvider);
    ref.read(_sortedPlayersProvider.notifier).state = sortedPlayers;

    Navigator.of(context).pop();
  }
}
