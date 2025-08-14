part of 'events_applicant_dialog.dart';

class ApplicantEventInfoCard extends StatelessWidget {
  const ApplicantEventInfoCard({super.key, required this.service});
  final ServiceDetail service;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15.h),
      constraints: kComponentWidthConstraint,
      decoration: BoxDecoration(
        color: AppColors.oak,
        borderRadius: BorderRadius.all(Radius.circular(12.r)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                service.service?.event?.eventName ?? "",
                style: AppTextStyles.balooMedium16
                    .copyWith(color: AppColors.white),
              ),
              const Spacer(),
              Text(
                "DATE_AND_TIME".tr(context),
                style: AppTextStyles.balooMedium16
                    .copyWith(color: AppColors.white),
              )
            ],
          ),
          // SizedBox(height: 1.h),
          const CDivider(color: AppColors.white25,),
          // SizedBox(height: 2.h),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (service.service?.location?.locationName ?? "")
                        .capitalizeFirst,
                    style: AppTextStyles.sansRegular15
                        .copyWith(color: AppColors.white),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "${"PRICE".tr(context)} ${Utils.formatPrice(service.service?.price?.toDouble())}",
                    style: AppTextStyles.sansRegular15
                        .copyWith(color: AppColors.white),
                  ),
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    service.formatBookingDate,
                    style: AppTextStyles.sansRegular15
                        .copyWith(color: AppColors.white),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    service.formatStartEndTimeAm,
                    style: AppTextStyles.sansRegular15
                        .copyWith(color: AppColors.white),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
