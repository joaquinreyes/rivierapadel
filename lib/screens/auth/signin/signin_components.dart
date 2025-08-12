part of 'signin_screen.dart';

_forgotPasswordDialog(BuildContext context, WidgetRef ref) {
  final emailController = TextEditingController();
  final emailNode = FocusNode();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          bool canProceed = emailController.text.isNotEmpty;

          return KeyboardVisibilityBuilder(
            builder: (context, child, insets, isVisible) {
              return Padding(
                padding: EdgeInsets.only(bottom: insets),
                child: child,
              );
            },
            child: CustomDialog(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'RECOVER_PASSWORD'.trU(context),
                    style: AppTextStyles.popupHeaderTextStyle,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 25.h),
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      'ENTER_EMAIL_ADDRESS'.tr(context),
                      style: AppTextStyles.sansRegular16.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Form(
                    key: formKey,
                    child: CustomTextField(
                      controller: emailController,
                      node: emailNode,
                      validator: (val) {
                        if (val?.isEmpty ?? true) {
                          return "PLEASE_ENTER_"
                              .tr(context, params: {'FIELD': "EMAIL"});
                        }
                        if (!(val?.isValidEmail ?? true)) {
                          return "PLEASE_ENTER_VALID_".tr(
                            context,
                            params: {'FIELD': "EMAIL"},
                          );
                        }
                        return null;
                      },
                      style: AppTextStyles.sansRegular13
                          .copyWith(color: AppColors.white),
                      fillColor: AppColors.white,
                      keyboardType: TextInputType.emailAddress,
                      isForPopup: true,
                        hintText: 'TYPE_HERE'.tr(context),
                      onChanged: (_) {
                        setState(() {});
                      },
                    ),
                  ),
                  SizedBox(height: 25.h),
                  MainButton(
                    enabled: canProceed,
                    isForPopup: true,
                    label: 'SEND_RECOVER_EMAIL'.tr(context).capitalizeFirst.capitalEnabled(context, canProceed: canProceed),
                    showArrow: false,
                    onTap: () async {
                      if (!(formKey.currentState?.validate() ?? true)) {
                        return;
                      }
                      if (canProceed) {
                        final provider = recoverPasswordProvider(
                            emailController.text.trim());
                        final sent = await Utils.showLoadingDialog(
                            context, provider, ref);
                        if (sent && context.mounted) {
                          Navigator.pop(context);
                          showDialog(
                            context: context,
                            builder: (context) => _RecoverPassword2(
                              email: emailController.text.trim(),
                            ),
                          );
                        }
                      }
                    },
                  ),
                  SizedBox(height: 30.h),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

class _RecoverPassword2 extends ConsumerStatefulWidget {
  const _RecoverPassword2({
    required this.email,
  });

  final String email;

  @override
  _RecoverPassword2State createState() => _RecoverPassword2State();
}

class _RecoverPassword2State extends ConsumerState<_RecoverPassword2> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final tokenController = TextEditingController();
  final tokenNode = FocusNode();

  final newPasswordController = TextEditingController();
  final newPasswordNode = FocusNode();

  bool get canProceed =>
      (tokenController.text.isNotEmpty) &&
      (newPasswordController.text.isNotEmpty) &&
      (newPasswordController.text.length >= 6);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomDialog(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'RECOVER_PASSWORD'.trU(context),
                style: AppTextStyles.popupHeaderTextStyle,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.h),
              // IF_YOU_HAVE_AN_ACCOUNT_YOU_WILL_RECEIVE_AN_EMAIL
              Text(
                'IF_YOU_HAVE_AN_ACCOUNT_YOU_WILL_RECEIVE_AN_EMAIL'.tr(context),
                style: AppTextStyles.popupBodyTextStyle,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10.h),
              Text(
                'EMAIL_MAY_IN_JUNK'.tr(context),
                style: AppTextStyles.popupBodyTextStyle,
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 20.h),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  'ENTER_TOKEN'.tr(context),
                  style: AppTextStyles.sansRegular16.copyWith(color: AppColors.white),
                ),
              ),
              SizedBox(height: 5.h),
              CustomTextField(
                controller: tokenController,
                node: tokenNode,
                hintText: "TYPE_HERE".tr(context),
                validator: (val) {
                  if (val?.isEmpty ?? true) {
                    return "PLEASE_ENTER_"
                        .tr(context, params: {'FIELD': "TOKEN"});
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
                // style: AppTextStyles.gothamLight12
                //     .copyWith(color: AppColors.white),
                textInputAction: TextInputAction.next,
                isForPopup: true,
                onChanged: (_) {
                  setState(() {});
                },
              ),
              SizedBox(height: 20.h),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  'ENTER_NEW_PASSWORD'.tr(context),
                  style: AppTextStyles.sansRegular16.copyWith(color: AppColors.white),
                ),
              ),
              SizedBox(height: 5.h),
              CustomTextField(
                controller: newPasswordController,
                node: newPasswordNode,
                hintText: "TYPE_HERE".tr(context),
                validator: (val) {
                  if ((val?.isEmpty ?? true) || (val?.length ?? 0) < 6) {
                    return "PASSWORD_MUST_BE_".tr(context);
                  }
                  return null;
                },
                keyboardType: TextInputType.text,
                // style: AppTextStyles.gothamLight12
                //     .copyWith(color: AppColors.white),
                isForPopup: true,
                onChanged: (_) {
                  setState(() {});
                },
              ),
              SizedBox(height: 25.h),
              MainButton(
                enabled: canProceed,
                label: 'UPDATE_PASSWORD'.tr(context).capitalEnabled(context, canProceed: canProceed),
                showArrow: false,
                isForPopup: true,
                applyShadow: true,
                // padding: EdgeInsets.symmetric(vertical: 12.h),
                onTap: () async {
                  if (!(formKey.currentState?.validate() ?? true)) {
                    return;
                  }
                  if (canProceed) {
                    final provider = updateRecoveryPasswordProvider(
                        email: widget.email,
                        token: tokenController.text.trim(),
                        password: newPasswordController.text.trim());
                    final sent =
                        await Utils.showLoadingDialog(context, provider, ref);
                    if (sent && context.mounted) {
                      Navigator.pop(context);
                      Utils.showMessageDialog(
                          context, "PASSWORD_UPDATED_SUCCESS".trU(context));
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
