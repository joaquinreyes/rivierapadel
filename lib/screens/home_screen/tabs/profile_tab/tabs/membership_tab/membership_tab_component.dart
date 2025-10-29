part of 'membership_tab.dart';

class _MembershipInfoDialog extends StatelessWidget {
  final ActiveMemberships? activeMembership;

  final MembershipModel membershipModel;

  const _MembershipInfoDialog(
      {required this.activeMembership, required this.membershipModel});

  @override
  Widget build(BuildContext context) {
    final membershipName = membershipModel.membershipName?.toUpperCase() ?? "";
    final membershipDuration = membershipModel.duration ?? "";
    final membershipLocation = membershipModel.locationName;
    final membershipValidity = activeMembership?.finishDateString(context);
    final membershipUsage =
        activeMembership?.usesLeftString(context, textColor: AppColors.black);

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
                    if (membershipValidity != null)
                      Text(
                        membershipValidity,
                        style: AppTextStyles.sansRegular15,
                      ),
                    if (membershipDuration.isNotEmpty)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${"DURATION".tr(context)} :",
                            style: AppTextStyles.sansRegular15,
                          ),
                          Text(
                            membershipDuration,
                            style: AppTextStyles.sansRegular15,
                          ),
                        ],
                      )
                    // if(membershipUsage != null)
                    // Column(
                    //   crossAxisAlignment: CrossAxisAlignment.end,
                    //   mainAxisAlignment: MainAxisAlignment.end,
                    //   children: [
                    //     Text(
                    //       "${"USAGE".tr(context)} :",
                    //       style: AppTextStyles.sansRegular15,
                    //     ),
                    //     membershipUsage,
                    //   ],
                    // )
                  ],
                ),
              ],
            ),
          ),
          if (membershipLocation.isNotEmpty)
            SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 15.h),
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
          SizedBox(height: 10.h),
          if (activeMembership == null)
            Column(
              children: [
                SizedBox(height: 20.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "BOOKING_PAYMENT".trU(context),
                    style: AppTextStyles.balooMedium16
                        .copyWith(color: AppColors.white),
                  ),
                ),
                SizedBox(height: 10.h),
                MainButton(
                  isForPopup: true,
                  label: "PROCEED_WITH_PAYMENT".trU(context),
                  onTap: () {
                    Navigator.pop(context, true);
                  },
                ),
              ],
            ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }
}

class _MembershipCategorySelection extends ConsumerWidget {
  final List<ShowMembershipCategory> showMembershipCategories;

  const _MembershipCategorySelection({required this.showMembershipCategories});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(selectedMembershipCatIndex);
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        decoration: inset.BoxDecoration(
          color: AppColors.clay05,
          boxShadow: kInsetShadow,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: showMembershipCategories.map((e) {
            final id = e.id;
            final isSelected = listEquals(e.id, value);
            final categoryName = e.categoryName ?? "";
            return InkWell(
              onTap: () {
                if (!isSelected) {
                  ref.read(selectedMembershipCatIndex.notifier).state = id;
                }
              },
              child: Container(
                width: 100.w,
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
                margin: EdgeInsets.symmetric(
                  vertical: 4.h,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.darkBlue : Colors.transparent,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  categoryName.capitalizeFirst,
                  textAlign: TextAlign.center,
                  style: isSelected
                      ? AppTextStyles.sansMedium12.copyWith(
                          color: AppColors.white,
                        )
                      : AppTextStyles.sansRegular12.copyWith(
                          color: AppColors.clay70,
                        ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class MembershipListComponent extends ConsumerWidget {
  final UserActiveMembership data;
  final bool showAllMembership;

  const MembershipListComponent({
    super.key,
    required this.data,
    this.showAllMembership = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMembershipCategory = ref.watch(selectedMembershipCatIndex);

    final Map<String, List<MembershipModel>> membershipDetails = data
        .getMembershipDetails(selectedMembershipCategory, showAllMembership);

    if (membershipDetails.isEmpty) {
      return const SizedBox();
    }

    return Column(
      children: membershipDetails.entries.map((entry) {
        final membershipCategoryName = entry.key;
        final membershipModels = entry.value;

        return SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.only(bottom: 15.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!showAllMembership)
                  Padding(
                    padding: EdgeInsets.only(bottom: 10.h),
                    child: Text(
                      membershipCategoryName.toUpperCase(),
                      style: AppTextStyles.balooMedium16,
                      textAlign: TextAlign.start,
                    ),
                  ),
                membershipModels.isEmpty
                    ? Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        child: Text("NO_PURCHASE_MEMBERSHIP_FOUND".tr(context),
                            style: AppTextStyles.sansRegular14),
                      )
                    : _listMembership(
                        ref: ref, membershipModels: membershipModels),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _listMembership({
    required WidgetRef ref,
    required List<MembershipModel> membershipModels,
  }) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: membershipModels.length,
      itemBuilder: (BuildContext context, int index) {
        final e = membershipModels[index];
        final membershipName = e.membershipName ?? "";
        final activeMembership = data.activeMemberships(e.id ?? 0);

        return Padding(
          padding: EdgeInsets.only(bottom: 5.h),
          child: Row(
            children: [
              Expanded(
                flex: 4,
                child: Text(
                  membershipName,
                  style: AppTextStyles.balooMedium16,
                ),
              ),
              InkWell(
                onTap: () async {
                  final value = await showDialog(
                    context: context,
                    builder: (context) {
                      return _MembershipInfoDialog(
                          membershipModel: e,
                          activeMembership: activeMembership);
                    },
                  );

                  if (value is! bool && !value) {
                    return;
                  }

                  final data = await showDialog(
                    context: context,
                    builder: (context) {
                      return PaymentInformation(
                        type: PaymentDetailsRequestType.membership,
                        locationID: e.locationId,
                        allowCoupon: false,
                        allowMembership: false,
                        allowWallet: false,
                        purchaseMembership: true,
                        price: e.price ?? 0,
                        requestType: PaymentProcessRequestType.membership,
                        serviceID: e.id ?? 0,
                        startDate: null,
                        duration: null,
                        transactionRequestType: TransactionRequestType.normal,
                      );
                    },
                  );
                  if(data is! bool || !data){
                   return;
                  }
                  if (data && context.mounted) {
                    await Utils.showMessageDialog(
                      context,
                      "YOU_HAVE_PURCHASED_MEMBERSHIP_SUCCESSFULLY".tr(context),
                    );
                  }
                  ref.invalidate(fetchActiveAndAllMembershipsProvider);
                },
                child: activeMembership == null
                    ? Container(
                        width: 120.w,
                        margin: EdgeInsets.symmetric(horizontal: 15.w),
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 6.h),
                        decoration: inset.BoxDecoration(
                            color: AppColors.clay05,
                            boxShadow: kInsetShadow,
                            borderRadius: BorderRadius.circular(12.r)),
                        alignment: Alignment.center,
                        child: Text(
                          "GET_MEMBERSHIP".tr(context),
                          style: AppTextStyles.sansRegular12,
                        ),
                      )
                    : Container(
                        width: 120.w,
                        margin: EdgeInsets.symmetric(horizontal: 15.w),
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 4.h),
                        decoration: inset.BoxDecoration(
                            color: AppColors.darkBlue,
                            boxShadow: kInsetShadow,
                            borderRadius: BorderRadius.circular(12.r)),
                        alignment: Alignment.center,
                        child: Center(
                            child: activeMembership.usesLeftString(context)),
                      ),
              )
            ],
          ),
        );
      },
    );
  }
}
