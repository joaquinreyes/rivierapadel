import 'package:acepadel/components/main_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:acepadel/app_styles/app_colors.dart';
import 'package:acepadel/app_styles/app_text_styles.dart';
import 'package:acepadel/components/custom_dialog.dart';
import 'package:acepadel/globals/images.dart';
import 'package:acepadel/utils/custom_extensions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

class AsyncDialog<T> extends ConsumerWidget {
  const AsyncDialog({super.key, required this.provider});
  final AutoDisposeFutureProvider<T> provider;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(provider);
    ref.listen(provider, (pre, next) {
      if (pre == next) {
        return;
      }
      if (next.hasError) {
        return;
      }
      if (next.value is T) {
        Navigator.pop(context, next.value);
      }
    });
    return CustomDialog(
        color: async.hasError ? AppColors.darkBlue : AppColors.backgroundColor,
        showCloseIcon: false,
        // showCloseIcon: async.hasError,
        contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: async.when(
          data: (data) {
            return _loading(context);
          },
          error: (error, stackTrace) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 10.h),
                Image.asset(
                  AppImages.warning2.path,
                  width: 90.w,
                  height: 90.w,
                ),
                SizedBox(height: 15.h),
                SelectableText(
                  error.toString(),
                  textAlign: TextAlign.center,
                  style: AppTextStyles.popupHeaderTextStyle,
                ),
                SizedBox(height: 25.h),
                MainButton(
                  label: 'CONTINUE'.trU(context),
                  // color: AppColors.yellow,
                  isForPopup: true,
                  // labelStyle: AppTextStyles.balooMedium13,
                  onTap: () {
                    Navigator.pop(context, error.toString());
                  },
                ),
                SizedBox(height: 15.h),
              ],
            );
          },
          loading: () {
            return _loading(context);
          },
        ));
  }

  Row _loading(BuildContext context) {
    return Row(
      children: [
        Image.asset(AppImages.loadingGif.path, height: 50.h),
        const SizedBox(width: 10),
        Text(
          "${"loading".tr(context).capitalizeFirst}...",
          style: AppTextStyles.balooBold15.copyWith(color: AppColors.darkBlue),
        ),
      ],
    );
  }
}
