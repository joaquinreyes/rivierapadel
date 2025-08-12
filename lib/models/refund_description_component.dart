import 'package:acepadel/globals/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:acepadel/utils/custom_extensions.dart';
import '../app_styles/app_text_styles.dart';
import '../models/cancellation_policy_model.dart';

class RefundDescriptionComponent extends StatelessWidget {
  final CancellationPolicy? policy;

  final TextStyle? style;
  final String? text;

  const RefundDescriptionComponent(
      {super.key, required this.policy, this.style, this.text});

  @override
  Widget build(BuildContext context) {
    final cancellationHour = policy?.cancellationHours ?? 0;
    final refundAmount = policy?.refund ?? 0;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          text ??
              (refundAmount == 0
                  ? "NO_REFUND_TEXT".tr(context)
                  : "CANCELLATION_POLICY_3".tr(context, params: {
                      "HOUR": cancellationHour.toString(),
                      "REFUND": Utils.formatPrice(refundAmount)
                    })),
          textAlign: TextAlign.center,
          style: style ?? AppTextStyles.popupBodyTextStyle,
        ),
        // SizedBox(height: 5.h),
        // if (policy?.refundHours != null && policy?.percentage != null)
        //   Text(
        //     "REFUND_DESCRIPTION".tr(context, params: {
        //       "HOUR": (policy?.refundHours ?? 24).toStringAsFixed(0),
        //       "PERCENTAGE": (policy?.percentage ?? 100).toStringAsFixed(1)
        //     }),
        //     textAlign: TextAlign.center,
        //     style: style ??
        //         AppTextStyles.popupBodyTextStyle,
        //   ),
      ],
    );
  }
}
