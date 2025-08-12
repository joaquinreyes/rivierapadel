import 'package:acepadel/components/custom_dialog.dart';
import 'package:acepadel/components/secondary_button.dart';
import 'package:acepadel/models/transaction_model.dart';
import 'package:acepadel/routes/app_pages.dart';
import 'package:acepadel/routes/app_routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:acepadel/CustomDatePicker/flutter_datetime_picker.dart';
import 'package:acepadel/app_styles/app_colors.dart';
import 'package:acepadel/app_styles/app_text_styles.dart';
import 'package:acepadel/components/custom_dropdown.dart';
import 'package:acepadel/components/main_button.dart';
import 'package:acepadel/components/secondary_textfield.dart';
import 'package:acepadel/globals/images.dart';
import 'package:acepadel/globals/utils.dart';
import 'package:acepadel/managers/user_manager.dart';
import 'package:acepadel/models/app_user.dart';
import 'package:acepadel/models/custom_fields.dart';
import 'package:acepadel/repository/user_repo.dart';
import 'package:acepadel/screens/home_screen/home_screen.dart';
import 'package:acepadel/utils/custom_extensions.dart';
import 'package:acepadel/utils/dubai_date_time.dart';

import '../../../../../components/secondary_text.dart';
import '../../play_match_tab/play_match_tab.dart';

part 'settings_edit_profile.dart';
part 'providers.dart';
part 'settings_components.dart';

class Settings extends ConsumerStatefulWidget {
  const Settings({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UpComingBookingsState();
}

class _UpComingBookingsState extends ConsumerState<Settings> {
  @override
  Widget build(BuildContext context) {
    final appUser = ref.watch(userProvider);
    final user = appUser?.user;
    final userLevel = user?.level(getSportsName(ref));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'PERSONAL_INFORMATION'.tr(context),
              style: AppTextStyles.panchangBold13,
            ),
            SecondaryImageButton(
              label: "EDIT".tr(context),
              image: AppImages.editIcon.path,
              imageHeight: 15.h,
              imageWidth: 13.w,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => _EditProfile(
                    user: user!,
                  ),
                );
              },
            )
          ],
        ),
        SizedBox(height: 20.h),
        _buildInfoField("FIRST_NAME".tr(context), user?.firstName ?? ""),
        SizedBox(height: 10.h),
        _buildInfoField("LAST_NAME".tr(context), user?.lastName ?? ""),
        SizedBox(height: 10.h),
        _buildInfoField("EMAIL".tr(context), user?.email ?? ""),
        SizedBox(height: 10.h),
        _buildInfoField("PHONE_NUMBER".tr(context), user?.phoneNumber ?? ""),
        SizedBox(height: 10.h),
        _buildInfoField("LEVEL".tr(context), (userLevel ?? 0).formatString()),
        if (user != null)
          _CustomFields(
            user: user,
          ),
        // const _PaymentInfo(),
        SizedBox(height: 20.h),
        const TransactionList(),
        SizedBox(height: 20.h),
        const _DeletePasswordBtns(),
        SizedBox(height: 20.h),
      ],
    );
  }
}

// class _PaymentInfo extends ConsumerWidget {
//   const _PaymentInfo({super.key});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final paymentDetails = ref.watch(walletInfoProvider);
//     return paymentDetails.when(
//       loading: () => const Center(child: CupertinoActivityIndicator()),
//       error: (e, _) {
//         return _body(context, null);
//       },
//       data: (data) {
//         if (data.isEmpty) {
//           return _body(context, null);
//         }
//         return _body(context, data.first.balance);
//       },
//     );
//   }
//
//   Column _body(BuildContext context, double? walletAmount) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         SizedBox(height: 40.h),
//         Text(
//           'PAYMENT_INFORMATION'.tr(context),
//           style: AppTextStyles.panchangBold13,
//         ),
//         SizedBox(height: 12.h),
//         _buildInfoField(
//           "BALANCE".tr(context),
//           Utils.formatPrice(walletAmount),
//         ),
//       ],
//     );
//   }
// }
