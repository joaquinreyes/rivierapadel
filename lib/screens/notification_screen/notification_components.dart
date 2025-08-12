part of 'notification_screen.dart';

class _ClearAllBtn extends StatelessWidget {
  const _ClearAllBtn({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: SecondaryImageButton(
        label: "CLEAR_ALL".tr(context),
        image: AppImages.crossIcon.path,
        imageHeight: 10.h,
        imageWidth: 10.w,
        onTap: () {},
      ),
    );
  }
}

class NotificationTile extends StatelessWidget {
  const NotificationTile({Key? key}) : super(key: key);
  // final NotificationModel notification;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // switch (notification.data?.notificationType) {
        //   case NotificationType.chat:
        //     Get.toNamed(Routes.chat,
        //         arguments: {"bookingId": notification.data?.bookingId});
        //     break;
        //   case NotificationType.join:
        //   case NotificationType.cancel:
        //     Get.offAllNamed(Routes.home, arguments: {
        //       "initialIndex": 2,
        //     });
        //     break;
        //   default:
        //     break;
        // }
      },
      child: Container(
        padding:
            EdgeInsets.only(left: 15.w, right: 15.w, top: 10.h, bottom: 10.h),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(5.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // if (notification.createdAt != null)
                Text(
                  "28 Oct. 19:31 hrs",
                  style: AppTextStyles.gothamLight12,
                ),
                // if (notification.createdAt == null) const Spacer(),
                InkWell(
                  onTap: () {
                    // if (notification.id == null) return;
                    // FirebaseService.I.clearNotification(notification.id!);
                  },
                  child: Image.asset(
                    AppImages.crossIcon.path,
                    height: 13.h,
                    width: 13.h,
                  ),
                ),
              ],
            ),
            SizedBox(height: 5.h),
            Text(
              "A new player has joined the open match",
              style: AppTextStyles.balooBold10,
            ),
            SizedBox(height: 5.h),
            Text(
              "John has joined the match to be held at 8:00 in Padel 1",
              style: AppTextStyles.gothamRegular13,
            ),
          ],
        ),
      ),
    );
  }
}
