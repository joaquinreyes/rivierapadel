import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:acepadel/components/c_divider.dart';
import 'package:acepadel/components/custom_dialog.dart';
import 'package:acepadel/models/active_memberships.dart';
import 'package:acepadel/models/membership_list_category_model.dart';
import 'package:acepadel/models/membership_model.dart';
import 'package:acepadel/models/user_membership.dart';
import 'package:acepadel/utils/custom_extensions.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart' as inset;
import '../../../../../../app_styles/app_colors.dart';
import '../../../../../../app_styles/app_text_styles.dart';
import '../../../../../../components/main_button.dart';
import '../../../../../../components/secondary_text.dart';
import '../../../../../../globals/constants.dart';
import '../../../../../../globals/utils.dart';
import '../../../../../../repository/booking_repo.dart';
import '../../../../../../repository/payment_repo.dart';
import '../../../../../payment_information/payment_information.dart';

part 'membership_tab_component.dart';
part 'membership_tab_provider.dart';

class MembershipTab extends ConsumerWidget {
  const MembershipTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final membership = ref.watch(fetchActiveAndAllMembershipsProvider);
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
              if (data.membershipModel.isEmpty) {
                return SecondaryText(text: "NO_MEMBERSHIP_FOUND".tr(context));
              }
              final selectedMembershipCategory =
                  ref.watch(selectedMembershipCatIndex);

              if (data.showMembershipCategories.isNotEmpty &&
                  selectedMembershipCategory.isEmpty) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ref.read(selectedMembershipCatIndex.notifier).state =
                      data.showMembershipCategories.first.id;
                });
              }

              return Column(
                children: [
                  if (data.showMembershipCategories.length > 1)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: _MembershipCategorySelection(
                          showMembershipCategories:
                              data.showMembershipCategories),
                    ),
                  MembershipListComponent(data: data, showAllMembership: false),
                ],
              );
            },
            error: (e, _) =>
                SecondaryText(text: "NO_MEMBERSHIP_FOUND".tr(context)),
            loading: () => const Center(child: CupertinoActivityIndicator()))
      ],
    );
  }
}
