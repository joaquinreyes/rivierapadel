part of 'membership_tab.dart';

class _MembershipInfoDialog extends StatelessWidget {
  final ActiveMemberships membership;

  const _MembershipInfoDialog({required this.membership});

  @override
  Widget build(BuildContext context) {
    final membershipName = membership.membershipName?.toUpperCase() ?? "";
    final membershipDuration = membership.duration ?? "";
    final membershipLocation = membership.location ?? "";
    final membershipValidity = membership.finishDateString(context);

    return CustomDialog(
      maxHeight: MediaQuery.of(context).size.height * 0.85,
      closeIconColor: AppColors.white,
      child: Column(
        children: [
          SizedBox(height: 5.h),
          Text(
            "${"MEMBERSHIP".trU(context)} ${"INFORMATION".trU(context)}",
            style: AppTextStyles.balooMedium22.copyWith(color: AppColors.white),
          ),
          SizedBox(height: 20.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
            margin: EdgeInsets.symmetric(horizontal: 3.w),
            constraints: kComponentWidthConstraint,
            decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12.r)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  membershipName,
                  style: AppTextStyles.balooMedium16.copyWith(
                    color: AppColors.darkBlue,
                  ),
                  textAlign: TextAlign.start,
                ),
                CDivider(
                  color: AppColors.clay70.withOpacity(0.3),
                ),
                SizedBox(height: 4.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      membershipValidity,
                      style: AppTextStyles.sansRegular15,
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (membershipDuration.isNotEmpty || membershipLocation.isNotEmpty)
            SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 15.h),
                  if (membershipDuration.isNotEmpty) ...[
                    Text(
                      "${"DURATION".tr(context)} :",
                      style: AppTextStyles.balooMedium16
                          .copyWith(color: AppColors.white),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      membershipDuration,
                      style: AppTextStyles.sansRegular14
                          .copyWith(color: AppColors.white),
                    ),
                    SizedBox(height: 10.h),
                  ],
                  if (membershipLocation.isNotEmpty) ...[
                    Text(
                      "${"LOCATION".tr(context)} :",
                      style: AppTextStyles.balooMedium16
                          .copyWith(color: AppColors.white),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      membershipLocation.capitalizeFirst,
                      style: AppTextStyles.sansRegular14
                          .copyWith(color: AppColors.white),
                    ),
                  ],
                ],
              ),
            ),
          SizedBox(height: 25.h),
        ],
      ),
    );
  }
}
