part of 'signup_screen.dart';

class _SelectYourPosition extends StatefulWidget {
  const _SelectYourPosition(
      {super.key, required this.registerModel, required this.onProceed});
  final RegisterModel registerModel;
  final Function() onProceed;
  @override
  State<_SelectYourPosition> createState() => _SelectYourPositionState();
}

class _SelectYourPositionState extends State<_SelectYourPosition> {
  bool get canProceed => playingSide != null;
  PlayingSide? playingSide;
  @override
  void initState() {
    final playingSide = widget.registerModel.playingSide;
    if (playingSide != null) {
      this.playingSide = PlayingSide.fromString(playingSide);
    }
    // playingSide = PlayingSide.fromString(");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 40.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 45.h),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'SELECT_YOUR_POSITION'.tr(context).toUpperCase(),
                textAlign: TextAlign.center,
                style: AppTextStyles.panchangMedium15,
              ),
            ),
            SizedBox(height: 30.h),
            _optionTile(
                PlayingSide.right, "RIGHT_SIDE_EXPLANATION".tr(context)),
            _optionTile(PlayingSide.left, "LEFT_SIDE_EXPLANATION".tr(context)),
            _optionTile(PlayingSide.both, "BOTH_SIDES_EXPLANATION".tr(context)),
            SizedBox(height: 37.h),
            Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                width: 154.50.w,
                child: MainButton(
                  enabled: canProceed,
                  showArrow: true,
                  label: 'NEXT'.tr(context),
                  onTap: () async {
                    if (canProceed) {
                      widget.registerModel.playingSide =
                          playingSide?.getApiString;
                      widget.onProceed();
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _optionTile(PlayingSide side, String explanation) {
    final selected = playingSide == side;
    return InkWell(
      onTap: () {
        playingSide = side;
        widget.registerModel.playingSide = side.getApiString;
        setState(() {});
      },
      borderRadius: BorderRadius.circular(15.r),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    side.userFacingString,
                    style: AppTextStyles.panchangMedium13.copyWith(
                      color: selected ? AppColors.white : AppColors.darkGreen,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    explanation,
                    style: AppTextStyles.helveticaLight14.copyWith(
                      color: selected ? AppColors.white : AppColors.darkGreen,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
