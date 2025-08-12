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
                SizedBox(height: 20.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'LEVEL_ASSESSMENT'.tr(context),
                    textAlign: TextAlign.center,
                    style: AppTextStyles.balooMedium20.copyWith(height: 1),
                  ),
                ),
                SizedBox(height: 8.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "LEVEL_DESCRIPTION".tr(context),
                    style: AppTextStyles.sansRegular14.copyWith(height: 1),
                  ),
                ),
                SizedBox(height: 15.h),
                Image.asset(
                  AppImages.levelInfo.path,
                  width: double.infinity,
                ),
                SizedBox(height: 38.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "GREAT_YOUR_STARTING_LEVEL_IS".tr(context),
                    style: AppTextStyles.balooMedium19.copyWith(height: 1),
                  ),
                ),
                7.verticalSpace,
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 6.5.h),
                  decoration: BoxDecoration(
                    color: AppColors.oak,
                    borderRadius: BorderRadius.circular(100.r),
                  ),
                  child: Center(
                    child: Text(
                      data.level?.formatString() ?? "",
                      style: AppTextStyles.balooMedium22
                          .copyWith(color: AppColors.white),
                    ),
                  ),
                ),
                SizedBox(height: 75.h),
                Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: 160.w,
                    child: MainButton(
                      enabled: _canProceed,
                      label: 'CONTINUE'.trU(context),
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
