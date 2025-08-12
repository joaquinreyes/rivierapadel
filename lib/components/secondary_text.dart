import 'package:flutter/cupertino.dart';
import 'package:acepadel/app_styles/app_colors.dart';
import 'package:acepadel/app_styles/app_text_styles.dart';

class SecondaryText extends StatelessWidget {
  const SecondaryText({super.key, required this.text, this.textColor});
  final String text;
  final Color? textColor;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        style: AppTextStyles.gothamRegular14
            .copyWith(color: textColor ?? AppColors.black),
      ),
    );
  }
}
