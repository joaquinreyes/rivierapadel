part of 'home_screen.dart';

class _AddProfilePicture extends ConsumerStatefulWidget {
  const _AddProfilePicture(
      {super.key, required this.selectImage, required this.selectDate});
  final bool selectImage;
  final bool selectDate;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      __AddProfilePictureState();
}

class __AddProfilePictureState extends ConsumerState<_AddProfilePicture> {
  DateTime? selectedDate;
  File? _img;

  bool get canProceed {
    if (widget.selectDate && selectedDate == null) {
      return false;
    }
    if (widget.selectDate != true &&
        widget.selectImage == true &&
        _img == null) {
      return false;
    }
    return true;
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ref.read(userManagerProvider).user?.user;
      if ((user?.customFields.containsKey(kStartedPlayindCustomID) ?? false)) {
        final date = user?.customFields[kStartedPlayindCustomID];
        if (date != null) {
          setState(() {
            selectedDate = DateTime.tryParse(date);
          });
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.selectImage) ...[
            Text(
              "ADD_A_PROFILE_PICTURE".trU(context),
              style: AppTextStyles.popupHeaderTextStyle,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.h),
            Text(
              "ADD_A_PROFILE_PICTURE_EXPLANATION".tr(context),
              style: AppTextStyles.popupBodyTextStyle,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 5.h),
            InkWell(
              onTap: () async {
                ImageSource? src = await showModalBottomSheet(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25.r),
                      topRight: Radius.circular(25.r),
                    ),
                  ),
                  context: context,
                  builder: (_) => const ImageSourceSheet(),
                );
                if (src != null) {
                  final XFile? pickedFile = await ImagePicker().pickImage(
                    source: src,
                    imageQuality: 10,
                    maxHeight: 500,
                    maxWidth: 500,
                  );
                  if (pickedFile != null) {
                    setState(() {
                      _img = File(pickedFile.path);
                    });
                  }
                }
              },
              child: Stack(
                alignment: Alignment.bottomRight,
                clipBehavior: Clip.none,
                children: [
                  _image(),
                  if (_img == null)
                    Positioned(
                      right: 15.w,
                      bottom: 15.h,
                      child: Image.asset(
                        AppImages.iconCamera.path,
                        width: 12.h,
                        height: 12.h,
                      ),
                    )
                ],
              ),
            ),
            SizedBox(height: 15.h),
          ],
          if (widget.selectDate) ...[
            Text(
              "WHEN_DID_YOU_START_PLAYING".tr(context),
              style: AppTextStyles.sansMedium16
                  .copyWith(color: AppColors.white),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            Text(
              "WHEN_DID_YOU_START_PLAYING_EXPLANATION".tr(context),
              style: AppTextStyles.sansRegular15
                  .copyWith(color: AppColors.white),
              textAlign: TextAlign.start,
            ),
            SizedBox(height: 5.h),
            InkWell(
              onTap: () async {
                await DatePicker.showPicker(
                  context,
                  onConfirm: (date) {
                    selectedDate = date;
                  },
                  pickerModel: CustomMonthPicker(
                    minTime: DubaiDateTime.now()
                        .dateTime
                        .subtract(const Duration(days: 365 * 60)),
                    maxTime: DubaiDateTime.now().dateTime,
                    currentTime: selectedDate,
                  ),
                );

                setState(() {});
              },
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.white25,
                  borderRadius: BorderRadius.circular(100.r)
                ),
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedDate == null
                          ? "mm/yyyy"
                          : selectedDate!.format("MMMM/yyyy"),
                      style: AppTextStyles.sansRegular13
                          .copyWith(color: AppColors.white95),
                    ),
                    const Icon(
                      Icons.keyboard_arrow_down,
                      size: 25,
                      color: AppColors.white,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 25.h),
          ],
          MainButton(
            enabled: canProceed,
            label: "SAVE".tr(context),
            isForPopup: true,
            onTap: () async {
              final user = ref.read(userManagerProvider).user?.user;

              User? updatedUser;
              final Map<String, dynamic> customData = {};
              if (widget.selectDate == true) {
                customData[kStartedPlayindCustomID] =
                    selectedDate?.toIso8601String();
              }
              if (widget.selectDate == true) {
                updatedUser = user?.copyWithForUpdate(customFields: customData);
              }
              final done = await Utils.showLoadingDialog(context,
                  updatePictureAndUserProvider(_img, updatedUser), ref);
              if (done.$1 == true && done.$2 == true && context.mounted) {
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _image() {
    if (_img != null) {
      return Container(
        width: 90.h,
        height: 90.h,
        decoration: BoxDecoration(
          // shape: BoxShape.circle,
          borderRadius: BorderRadius.circular(17.r),
          image: DecorationImage(
            image: PlatformC().isCurrentOSMobile
                ? FileImage(_img!)
                : NetworkImage(_img!.path),
          ),
        ),
      );
    }
    return NetworkCircleImage(
      path: ref.read(userManagerProvider).user?.user?.profileUrl,
      width: 90.h,
      height: 90.h,
      isYellowBg: true,
    );
  }
}

class CustomMonthPicker extends DatePickerModel {
  CustomMonthPicker(
      {DateTime? currentTime,
      DateTime? minTime,
      DateTime? maxTime,
      LocaleType? locale})
      : super(
            locale: locale,
            minTime: minTime,
            maxTime: maxTime,
            currentTime: currentTime);

  @override
  List<int> layoutProportions() {
    return [1, 1, 0];
  }
}
