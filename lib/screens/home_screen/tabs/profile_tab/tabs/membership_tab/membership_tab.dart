import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:acepadel/components/c_divider.dart';
import 'package:acepadel/components/custom_dialog.dart';
import 'package:acepadel/models/active_memberships.dart';
import 'package:acepadel/utils/custom_extensions.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart' as inset;
import '../../../../../../app_styles/app_colors.dart';
import '../../../../../../app_styles/app_text_styles.dart';
import '../../../../../../components/secondary_text.dart';
import '../../../../../../globals/constants.dart';
import '../../../../../../repository/booking_repo.dart';

part 'membership_tab_component.dart';
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
        final membershipName = membership.membershipName ?? "";

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
                  await showDialog(
                    context: context,
                    builder: (context) {
                      return _MembershipInfoDialog(membership: membership);
                    },
                  );
                },
                child: Container(
                  width: 120.w,
                  margin: EdgeInsets.symmetric(horizontal: 15.w),
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: inset.BoxDecoration(
                    color: AppColors.darkBlue,
                    boxShadow: kInsetShadow,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  alignment: Alignment.center,
                  child: Center(child: membership.usesLeftString(context)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
