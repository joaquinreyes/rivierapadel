part of 'profile_tab.dart';

class _HeaderInfo extends ConsumerWidget {
  const _HeaderInfo();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)?.user;
    final level = user?.level(getSportsName(ref)) ?? 0;
    final playingSide = user?.playingSide;
    final paymentDetails = ref.watch(walletInfoProvider);

    return Column(
      children: [
        Container(
          alignment: Alignment.centerRight,
          margin: EdgeInsets.only(right: 18.w),
          child: SecondaryButton(
            applyShadow: false,
            color: AppColors.clay05,
            onTap: () async {
              bool? logout = await showDialog(
                  context: context,
                  builder: (_) => const _SignOutConfirmation());
              if (logout == true) {
                ref.read(userManagerProvider).signout(ref);
                ref.read(goRouterProvider).pushReplacement(RouteNames.auth);
              }
            },
            child: Text(
              "SIGN_OUT".tr(context),
              style: AppTextStyles.gothamLight12,
            ),
          ),
        ),
        10.verticalSpace,
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
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
                    final File file = File(pickedFile.path);
                    if (context.mounted) {
                      await Utils.showLoadingDialog(
                          context, updateProfileProvider(file), ref);
                    }
                  }
                }
              },
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  NetworkCircleImage(
                    path: user?.profileUrl,
                    width: 90.w,
                    height: 90.h,
                    borderRadius: BorderRadius.circular(18.r),
                    showBG: false,
                    scale: 1,
                    reservedLogo: true,
                    isYellowBg: false,
                  ),
                  Positioned(
                    right: 12.w,
                    bottom: 10.h,
                    child: Image.asset(
                      AppImages.iconCamera.path,
                      width: 13.w,
                      height: 13.w,
                      color: AppColors.white,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(width: 20.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 5.h),
                Text(
                  user?.firstName ?? "",
                  style: AppTextStyles.balooMedium22,
                ),
                SizedBox(height: 1.h),
                Text(
                  "$level • $playingSide",
                  style: AppTextStyles.sansRegular15.copyWith(height: 1),
                ),
                SizedBox(height: 4.h),
                paymentDetails.when(
                    data: (data) {
                      double walletBalance = 0;
                      String currency = "Rp";
                      if (data.isNotEmpty) {
                        walletBalance = data.first.balance;
                        currency = data.first.currency;
                      }
                      return walletView(context, walletBalance, currency);
                    },
                    loading: () =>
                        const Center(child: CupertinoActivityIndicator()),
                    error: (e, _) => walletView(context, 0, "Rp"))
              ],
            )
          ],
        ),
      ],
    );
  }

  Widget walletView(
      BuildContext context, double walletBalance, String currency) {
    return Row(
      children: [
        Text(
          "WALLET".tr(context),
          style: AppTextStyles.sansMedium15,
        ),
        SizedBox(width: 5.w),
        Text(
          Utils.formatPrice2(walletBalance, currency),
          style: AppTextStyles.sansRegular15,
        )
      ],
    );
  }
}

class _Membership extends ConsumerWidget {
  const _Membership();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final membership = ref.watch(activeMembershipProvider);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: membership.when(
          data: (data) {
            final memberShip = getMemberShipName(data);
            return Row(
              children: [
                Text(
                  "${"LOYALTY_PROGRAM".trU(context)} ${memberShip.trU(context)}",
                  style: AppTextStyles.balooMedium14,
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => const _LoyaltyInfoDialog(),
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "INFO".tr(context),
                        style: AppTextStyles.sansRegular13,
                      ),
                      SizedBox(width: 5.w),
                      Image.asset(
                        AppImages.infoIcon.path,
                        width: 12.h,
                        height: 11.h,
                        color: AppColors.darkBlue,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
          error: (e, _) => SecondaryText(text: "Error ${e.toString()}"),
          loading: () => const Center(child: CupertinoActivityIndicator())),
    );
  }

  String getMemberShipName(List<ActiveMemberships> memberships) {
    if (memberships.isEmpty) {
      return "SILVER";
    }

    final membershipNames = {
      for (var membership in memberships)
        membership.membershipName?.toLowerCase()
    };

    if (membershipNames.contains("platinum")) {
      return "PLATINUM";
    } else if (membershipNames.contains("gold")) {
      return "GOLD";
    } else {
      return "SILVER";
    }
  }
}

class _PlayedHours extends ConsumerStatefulWidget {
  const _PlayedHours();

  @override
  ConsumerState<_PlayedHours> createState() => _PlayedHoursState();
}

class _PlayedHoursState extends ConsumerState<_PlayedHours> {
  @override
  void initState() {
    Future(() {
      ref.invalidate(playedHoursProvider);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final playedHrs = ref.watch(playedHoursProvider);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: playedHrs.when(
        data: (data) {
          double hours = data.padelHrs;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(flex: 2,
                    child: Text(
                      "${"THIS_MONTH".tr(context)} $hours hrs",
                      style: AppTextStyles.sansRegular12,
                    ),
                  ),
                  // const Spacer(),
                  Expanded(
                    child: Center(
                      child: Text(
                        "GOLD".tr(context),
                        style: AppTextStyles.sansMedium14,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Expanded(
                    child: Center(
                      child: Text(
                        "PLATINUM".tr(context),
                        style: AppTextStyles.sansMedium14,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                      tween: Tween<double>(
                        begin: 0,
                        end: 0.5,
                      ),
                      builder: (context, value, _) => LinearProgressIndicator(
                        minHeight: 10,
                        value: normalize(hours.abs(), 0, 35),
                        color: AppColors.oak,
                        borderRadius: BorderRadius.circular(20),
                        backgroundColor: AppColors.darkBlue,
                      ),
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Expanded(child: SizedBox()),
                      Container(
                        width: 2.w,
                        height: 10.h,
                        color: Colors.white,
                      ),
                      const Expanded(child: SizedBox()),
                      Container(
                        width: 2.w,
                        height: 10.h,
                        color: Colors.white,
                      ),
                      const Expanded(child: SizedBox())
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Expanded(child: SizedBox()),
                      Text("15HRS".tr(context),style: AppTextStyles.sansRegular12,
                      ),
                      const Expanded(child: SizedBox()),
                      Text("26HRS".tr(context),style: AppTextStyles.sansRegular12,
                      ),
                      const Expanded(child: SizedBox())
                    ],
                  ),
                ],
              ),
            ],
          );
        },
        loading: () => const Center(child: CupertinoActivityIndicator()),
        error: (e, __) =>
            Center(child: SecondaryText(text: "Error ${e.toString()}")),
      ),
    );
  }

  double normalize(double value, double min, double max) {
    return ((value - min) / (max - min)).clamp(0, 1);
  }
}

class _SignOutConfirmation extends StatelessWidget {
  const _SignOutConfirmation();

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "SIGN_OUT_CONFIRMATION".trU(context),
            style: AppTextStyles.popupHeaderTextStyle,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20.h),
          MainButton(
            label: "SIGN_OUT".trU(context),
            isForPopup: true,
            enabled: true,
            onTap: () {
              Navigator.pop(context, true);
            },
          )
        ],
      ),
    );
  }
}

class _LoyaltyInfoDialog extends StatelessWidget {
  const _LoyaltyInfoDialog();

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      color: AppColors.backgroundColor,
      closeIconColor: AppColors.darkGreen,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              AppImages.goldCard.path,
              width: 100.w,
              height: 100.w,
            ),
            SizedBox(height: 20.h),
            Text(
              "LOYALTY_PROGRAM".trU(context),
              style: AppTextStyles.popupHeaderTextStyle.copyWith(color: AppColors.darkBlue),
            ),
            Text(
              "GOLD".trU(context),
              style: AppTextStyles.popupHeaderTextStyle.copyWith(color: AppColors.darkBlue,height: 1.2),
            ),
            SizedBox(height: 15.h),
            _benefitsReqRowWidget(
              context,
              "GOLD_BENEFITS_DESC".tr(context),
              "GOLD_REQ_DESC".tr(context),
            ),
            SizedBox(height: 15.h),
            Text(
              "ONCE_YOU_ATTAIN_THIS_CARD".tr(context),
              style: AppTextStyles.sansRegular15,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.h),
            Image.asset(
              AppImages.platinumCard.path,
              width: 100.w,
              height: 100.w,
            ),
            Text(
              "LOYALTY_PROGRAM".trU(context),
              style: AppTextStyles.popupHeaderTextStyle.copyWith(color: AppColors.darkBlue),
            ),
            Text(
              "PLATINUM".trU(context),
              style: AppTextStyles.popupHeaderTextStyle.copyWith(color: AppColors.darkBlue,height: 1.2),
            ),
            SizedBox(height: 15.h),
            _benefitsReqRowWidget(
              context,
              "PLATINUM_BENEFITS_DESC".tr(context),
              "PLATINUM_REQ_DESC".tr(context),
            ),
            SizedBox(height: 15.h),
            Text(
              "ONCE_YOU_ATTAIN_THIS_CARD".tr(context),
              style: AppTextStyles.sansRegular15,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  SizedBox _benefitsReqRowWidget(
      BuildContext context, String benefits, String req) {
    return SizedBox(
      height: 143.h,
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 10.w),
              decoration: BoxDecoration(
                color: AppColors.darkBlue,
                borderRadius: BorderRadius.all(Radius.circular(12.r)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "BENEFITS".tr(context),
                    style: AppTextStyles.balooMedium16
                        .copyWith(color: AppColors.white,height: 1),
                  ),
                  const CDivider(color: AppColors.white25),
                  5.verticalSpace,
                  Text(
                    benefits,
                    style: AppTextStyles.sansRegular13
                        .copyWith(color: AppColors.white),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 5.w),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 10.w),
              decoration: BoxDecoration(
                color: AppColors.darkBlue.withOpacity(0.25),
                borderRadius: BorderRadius.all(Radius.circular(12.r)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "REQUIREMENTS".tr(context),
                    style: AppTextStyles.balooMedium16.copyWith(height: 1),
                  ),
                  CDivider(color: AppColors.darkBlue.withOpacity(0.25)),
                  5.verticalSpace,

                  Text(
                    req,
                    style: AppTextStyles.sansRegular13,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
