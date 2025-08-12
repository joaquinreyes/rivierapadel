part of 'booking_cart_dialog.dart';

class _OpenMatch extends ConsumerStatefulWidget {
  const _OpenMatch({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => __OpenMatchState();
}

class __OpenMatchState extends ConsumerState<_OpenMatch> {
  bool isLevelSelectorVisible = false;
  final TextEditingController leaveNoteController = TextEditingController();
  final FocusNode leaveNoteNode = FocusNode();
  @override
  void initState() {
    Future(() {
      _setupForOpenMatch();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isFriedlyMatch = ref.watch(_isFriednlyMatchProvider);
    final appovePlayers = ref.watch(_isApprovePlayersProvider);
    final matchLevel = ref.watch(_matchLevelProvider);
    final reserveSpotsForMatch = ref.watch(_reserveSpotsForMatchProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 15.h),
        _selectionRowContainer(
          text: "APPROVE_PLAYERS_BEFORE_JOIN".tr(context),
          isSelected: appovePlayers,
          onTap: () {
            ref.read(_isApprovePlayersProvider.notifier).state = !appovePlayers;
          },
        ),
        SizedBox(height: 15.h),
        _selectionRowContainer(
          text: "FRIENDLY_MATCH".tr(context),
          isSelected: isFriedlyMatch,
          onTap: () {
            ref.read(_isFriednlyMatchProvider.notifier).state = !isFriedlyMatch;
          },
        ),
        SizedBox(height: 15.h),
        Text(
          "SELECT_MATCH_LEVEL".tr(context),
          style: AppTextStyles.panchangMedium12.copyWith(
            color: AppColors.white,
          ),
        ),
        SizedBox(height: 5.h),
        InkWell(
          onTap: () {
            setState(() {
              isLevelSelectorVisible = !isLevelSelectorVisible;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.white25,
              borderRadius: BorderRadius.circular(5.r),
            ),
            padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (matchLevel.isNotEmpty) ...[
                  Text(
                    "${matchLevel.first} - ${matchLevel.last}",
                    style: AppTextStyles.helveticaLight13.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                ],
                const Spacer(),
                Icon(
                  isLevelSelectorVisible
                      ? Icons.arrow_drop_up_outlined
                      : Icons.arrow_drop_down_outlined,
                  color: AppColors.white,
                  size: 20,
                )
              ],
            ),
          ),
        ),
        if (isLevelSelectorVisible) ...[
          _levelSelector(),
        ],
        SizedBox(height: 15.h),
        RichText(
          text: TextSpan(
            text: "ARE_YOU_GOING_WITH_SOMEONE_ELSE".tr(context),
            style: AppTextStyles.panchangMedium12.copyWith(
              color: AppColors.white,
            ),
            children: [
              TextSpan(
                text: " ${"OPTIONAL".tr(context)}",
                style: AppTextStyles.helveticaLight13.copyWith(
                  color: AppColors.white,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 5.h),
        Container(
          decoration: inset.BoxDecoration(
            boxShadow: kInsetShadow2,
            color: AppColors.white25,
            borderRadius: BorderRadius.circular(5.r),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
            child: Row(
              children: [
                _optionContainer(
                  text: "1_PLAYER".tr(context),
                  isSelected: reserveSpotsForMatch == 1,
                  onTap: () {
                    ref.read(_reserveSpotsForMatchProvider.notifier).state = 1;
                  },
                ),
                _optionContainer(
                  text: "2_PLAYERS".tr(context),
                  isSelected: reserveSpotsForMatch == 2,
                  onTap: () {
                    ref.read(_reserveSpotsForMatchProvider.notifier).state = 2;
                  },
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 15.h),
        RichText(
          text: TextSpan(
            text: "LEAVE_A_NOTE".tr(context),
            style: AppTextStyles.panchangMedium12.copyWith(
              color: AppColors.white,
            ),
            children: [
              TextSpan(
                text: " ${"OPTIONAL".tr(context)}",
                style: AppTextStyles.helveticaLight13.copyWith(
                  color: AppColors.white,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 5.h),
        CustomTextField(
          controller: leaveNoteController,
          node: leaveNoteNode,
          onChanged: (value) {
            ref.read(_organizerNoteProvider.notifier).state = value;
          },
          hintText: 'TYPE_HERE'.tr(context),
          hintTextStyle:
              AppTextStyles.helveticaLight12.copyWith(color: AppColors.white55),
          contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          borderColor: Colors.transparent,
          style: AppTextStyles.panchangMedium10,
          isForPopup: true,
        ),
      ],
    );
  }

  Widget _optionContainer(
      {required String text,
      required bool isSelected,
      required Function()? onTap}) {
    return Expanded(
      flex: 50,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? AppColors.yellow50Popup : Colors.transparent,
            borderRadius: BorderRadius.circular(5.r),
          ),
          margin: EdgeInsets.symmetric(horizontal: 20.h, vertical: 2.w),
          padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 12.w),
          child: Center(
              child: Text(
            text,
            style: isSelected
                ? AppTextStyles.helveticaRegular12
                : AppTextStyles.helveticaLight12
                    .copyWith(color: AppColors.white),
          )),
        ),
      ),
    );
  }

  Widget _levelSelector() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...levelsList.map(
          (e) {
            bool isSelected = ref.watch(_matchLevelProvider).contains(e);
            return Padding(
              padding: EdgeInsets.only(top: 2.h, left: 2.w, right: 2.w),
              child: InkWell(
                onTap: () {
                  final appUser = ref.watch(userProvider);

                  final userLevel =
                      appUser?.user?.level(getSportsName(ref)) ?? 0.0;
                  if (userLevel == e) {
                    return;
                  }
                  setState(() {
                    final matchLevel = ref.read(_matchLevelProvider);
                    if (matchLevel.contains(e)) {
                      ref.read(_matchLevelProvider.notifier).state =
                          matchLevel.where((element) => element != e).toList();

                      ref.read(_matchLevelProvider.notifier).state.sort();
                    } else {
                      ref.read(_matchLevelProvider.notifier).state = [
                        ...matchLevel,
                        e,
                      ];
                      ref.read(_matchLevelProvider.notifier).state.sort();
                    }
                  });
                },
                child: Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.yellow50Popup
                        : AppColors.white25,
                  ),
                  child: Text(
                    e.toString(),
                    style: AppTextStyles.helveticaRegular12.copyWith(
                      color: isSelected ? AppColors.darkGreen : AppColors.white,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  void _setupForOpenMatch() {
    final userLevel =
        ref.read(userProvider)?.user?.level(getSportsName(ref)) ?? 0.0;
    List<double> matchLevelToShowIn = [userLevel];
    if (userLevel > 0) {
      matchLevelToShowIn.add(userLevel - 0.5);
    }
    if (userLevel < 7.0) {
      matchLevelToShowIn.add(userLevel + 0.5);
    }
    matchLevelToShowIn.sort();
    ref.read(_matchLevelProvider.notifier).state = matchLevelToShowIn;
  }
}

Widget _selectionRowContainer(
    {required String text,
    required bool isSelected,
    required Function()? onTap}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.yellow50Popup : AppColors.white25,
        borderRadius: BorderRadius.circular(5.r),
      ),
      child: Row(
        children: [
          Text(
            text,
            style: AppTextStyles.helveticaRegular12.copyWith(
              color: isSelected ? AppColors.darkGreen : AppColors.white,
            ),
          ),
          const Spacer(),
          SelectedTag(isSelected: isSelected)
        ],
      ),
    ),
  );
}
