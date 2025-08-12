part of 'signup_screen.dart';

class _LevelAssessmentTab extends ConsumerStatefulWidget {
  const _LevelAssessmentTab(
      {super.key,
      required this.index,
      required this.isLastQuestion,
      required this.levelQuesiton,
      required this.registerModel,
      required this.onProceed});
  final int index;
  final bool isLastQuestion;
  final RegisterModel registerModel;
  final Function() onProceed;
  final LevelQuestion levelQuesiton;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => __LevelAssessmentTab();
}

class __LevelAssessmentTab extends ConsumerState<_LevelAssessmentTab> {
  bool get _canProceed =>
      widget.registerModel.levelAnswers[widget.index] != null;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                "${widget.index + 1}. ${widget.levelQuesiton.question}",
                style: AppTextStyles.panchangMedium14,
              ),
            ),
            SizedBox(height: 25.h),
            for (var i = 0;
                i < (widget.levelQuesiton.options?.length ?? 0);
                i++) ...[
              _optionTile(
                widget.levelQuesiton.options![i],
              ),
            ],
            SizedBox(height: 37.h),
            Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                width: 154.50.w,
                child: MainButton(
                  enabled: _canProceed,
                  label: widget.isLastQuestion
                      ? "FINISH".tr(context)
                      : 'NEXT'.tr(context),
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
  }

  Widget _optionTile(LevelQuestionOptions option) {
    final selected =
        option.value == widget.registerModel.levelAnswers[widget.index];
    return InkWell(
      onTap: () {
        setState(() {
          widget.registerModel.levelAnswers[widget.index] = option.value;
        });
      },
      borderRadius: BorderRadius.circular(5.r),
      child: Container(
        width: 311.w,
        padding: EdgeInsets.all(10.h),
        margin: EdgeInsets.symmetric(
          vertical: 10.h,
        ),
        decoration: BoxDecoration(
          color: selected ? AppColors.green5 : AppColors.darkGreen5,
          borderRadius: BorderRadius.circular(5.r),
        ),
        child: Row(
          children: [
            SelectedTag(isSelected: selected),
            SizedBox(width: 20.w),
            Expanded(
              child: Text(
                option.text ?? "",
                style: !selected
                    ? AppTextStyles.helveticaLight14
                    : AppTextStyles.panchangMedium13.copyWith(
                        color: AppColors.white,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
