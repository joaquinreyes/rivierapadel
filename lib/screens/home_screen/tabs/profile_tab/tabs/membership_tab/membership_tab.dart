import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:acepadel/models/active_memberships.dart';
import 'package:acepadel/utils/custom_extensions.dart';
import '../../../../../../app_styles/app_colors.dart';
import '../../../../../../app_styles/app_text_styles.dart';
import '../../../../../../components/secondary_text.dart';
import '../../../../../../repository/booking_repo.dart';

part 'membership_tab_provider.dart';

class MembershipTab extends ConsumerWidget {
  const MembershipTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final membership = ref.watch(activeMembershipProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'MEMBERSHIP_INFORMATION'.trU(context),
          style: AppTextStyles.balooMedium22,
        ),
        SizedBox(height: 10.h),
        membership.when(
            data: (data) {
              if (data.isEmpty) {
                return SecondaryText(text: "NO_MEMBERSHIP_FOUND".tr(context));
              }
              return _MembershipListComponent(memberships: data);
            },
            error: (e, _) =>
                SecondaryText(text: "NO_MEMBERSHIP_FOUND".tr(context)),
            loading: () => const Center(child: CupertinoActivityIndicator()))
      ],
    );
  }
}

class _MembershipListComponent extends StatelessWidget {
  final List<ActiveMemberships> memberships;

  const _MembershipListComponent({required this.memberships});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: memberships.length,
      padding: EdgeInsets.symmetric(vertical: 10.h),
      itemBuilder: (context, index) {
        final membership = memberships[index];
        return Container(
          margin: EdgeInsets.only(bottom: 10.h),
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
          decoration: BoxDecoration(
            color: AppColors.clay05,
            borderRadius: BorderRadius.circular(15.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (membership.membershipName ?? "").toUpperCase(),
                      style: AppTextStyles.balooMedium16,
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      membership.finishDateString(context),
                      style: AppTextStyles.sansRegular14.copyWith(
                        color: AppColors.clay70,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: AppColors.darkBlue,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: membership.usesLeftString(context),
              ),
            ],
          ),
        );
      },
    );
  }
}
