part of 'signup_screen.dart';

class _LevelScoreTab extends ConsumerStatefulWidget {
  const _LevelScoreTab(
      {super.key, required this.registerModel, required this.onProceed});
  final RegisterModel registerModel;
  final Function() onProceed;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => __LevelScoreTab();
}

class __LevelScoreTab extends ConsumerState<_LevelScoreTab> {
  bool get _canProceed => true;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final calculatedData =
        ref.watch(calculateLevelProvider(widget.registerModel.levelAnswers));
    return calculatedData.when(
      data: (data) {
        return SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 40.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 45.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'LEVEL_ASSESSMENT'.trU(context),
                    textAlign: TextAlign.center,
                    style: AppTextStyles.panchangMedium15,
                  ),
                ),
                SizedBox(height: 25.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "GREAT_YOUR_STARTING_LEVEL_IS".tr(context),
                    style: AppTextStyles.panchangMedium14,
                  ),
                ),
                SizedBox(height: 25.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  decoration: BoxDecoration(
                    color: AppColors.yellow50,
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                  child: Center(
                    child: Text(
                      data.level?.formatString() ?? "",
                      style: AppTextStyles.panchangMedium29
                          .copyWith(color: AppColors.green5),
                    ),
                  ),
                ),
                SizedBox(height: 37.h),
                Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: 180.w,
                    child: MainButton(
                      enabled: _canProceed,
                      label: 'CONTINUE'.tr(context),
                      showArrow: true,
                      onTap: () async {
                        if (_canProceed) {
                          widget.onProceed();
                        }
                      },
                    ),
                  ),
                ),
                SizedBox(height: 82.h),
              ],
            ),
          ),
        );
      },
      loading: () => const Center(child: CupertinoActivityIndicator()),
      error: (error, _) => Center(child: Text(error.toString())),
    );
  }
}
