import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:acepadel/app_styles/app_colors.dart';
import 'package:acepadel/app_styles/app_text_styles.dart';
import 'package:acepadel/components/secondary_button.dart';
import 'package:acepadel/globals/current_platform.dart';
import 'package:acepadel/globals/images.dart';
import 'package:acepadel/routes/app_pages.dart';
import 'package:acepadel/utils/custom_extensions.dart';
part 'notification_components.dart';

class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NotificationScreenState();
}

class _NotificationScreenState extends ConsumerState<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Column(
            children: [
              SizedBox(height: 35.5.h),
              if (!PlatformC().isCurrentDesignPlatformDesktop)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 17.w),
                    child: InkWell(
                      onTap: () => ref.read(goRouterProvider).pop(),
                      child: Image.asset(
                        AppImages.backArrow.path,
                        height: 20.h,
                        width: 20.h,
                      ),
                    ),
                  ),
                ),
              Text(
                "NOTIFICATION".trU(context),
                style: AppTextStyles.panchangBold18,
              ),
              SizedBox(height: 40.h),
              // const _ClearAllBtn(),
              SizedBox(height: 15.h),
              Expanded(
                  child: ListView.separated(
                itemCount: 0,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  return const NotificationTile();
                },
              )),
            ],
          ),
        ),
      ),
    );
  }
}
