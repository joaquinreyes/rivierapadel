part of 'signup_screen.dart';

class _SignUpFormTab extends ConsumerStatefulWidget {
  const _SignUpFormTab(
      {super.key, required this.onProceed, required this.registerModel});
  final Function() onProceed;
  final RegisterModel registerModel;
  @override
  ConsumerState<_SignUpFormTab> createState() => _SignUpFormTabState();
}

class _SignUpFormTabState extends ConsumerState<_SignUpFormTab> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _firstNameNode = FocusNode();
  final _lastNameNode = FocusNode();
  final _emailNode = FocusNode();
  final _phoneNode = FocusNode();
  final _passNode = FocusNode();
  bool isTermsChecked = false;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String dialCode = '+62';
  bool get _canProceed =>
      _firstNameController.text.isNotEmpty &&
      _lastNameController.text.isNotEmpty &&
      _emailController.text.isNotEmpty &&
      _phoneController.text.isNotEmpty &&
      _passwordController.text.isNotEmpty &&
      isTermsChecked;
  @override
  void initState() {
    _emailController.text = widget.registerModel.email ?? '';
    _phoneController.text = widget.registerModel.phoneNumber ?? '';
    _passwordController.text = widget.registerModel.password ?? '';
    _firstNameController.text = widget.registerModel.firstName ?? '';
    _lastNameController.text = widget.registerModel.lastName ?? '';
    dialCode = widget.registerModel.phoneCode ?? '+62';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.w),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              ref.read(goRouterProvider).push(RouteNames.signIn);
            },
            child: RichText(
              text: TextSpan(
                text: '${'ALREADY_HAVE_AN_ACCOUNT'.tr(context)} ',
                style: AppTextStyles.sansRegular18.copyWith(
                  height: 1
                ),
                children: [
                  TextSpan(
                    text: 'SIGN_IN'.tr(context),
                    style: AppTextStyles.sansMedium18,
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 45.h),
          Form(
            key: formKey,
            child: Expanded(
              flex: 10,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 7.w),
                child: ListView(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  shrinkWrap: true,
                  children: [
                    Text(
                      'FIRST_NAME'.tr(context),
                      style: AppTextStyles.balooMedium19,
                    ),
                    CustomTextField(
                      controller: _firstNameController,
                      node: _firstNameNode,
                      isRequired: true,
                      textInputAction: TextInputAction.next,
                    ),
                    SizedBox(height: 50.h),
                    Text(
                      'LAST_NAME'.tr(context),
                      style: AppTextStyles.balooMedium19,
                    ),
                    CustomTextField(
                      controller: _lastNameController,
                      node: _lastNameNode,
                      isRequired: true,
                      textInputAction: TextInputAction.next,
                    ),
                    SizedBox(height: 50.h),
                    Text(
                      'EMAIL'.tr(context),
                      style: AppTextStyles.balooMedium19,
                    ),
                    CustomTextField(
                      controller: _emailController,
                      node: _emailNode,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (!(value?.isValidEmail ?? true)) {
                          return "PLEASE_ENTER_VALID_".tr(
                            context,
                            params: {'FIELD': "EMAIL"},
                          );
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 50.h),
                    Text(
                      'PHONE_NUMBER'.tr(context),
                      style: AppTextStyles.balooMedium19,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CountryCodePicker(
                          onChanged: (code) {
                            setState(() {
                              dialCode = code.dialCode ?? "+62";
                            });
                          },
                          initialSelection: dialCode,
                          padding: EdgeInsets.zero,
                          textStyle: AppTextStyles.balooMedium14
                              .copyWith(color: AppColors.darkGreen),
                          searchStyle: AppTextStyles.balooMedium14
                              .copyWith(color: AppColors.darkGreen),
                          dialogTextStyle: AppTextStyles.balooMedium14
                              .copyWith(color: AppColors.darkGreen),
                          flagWidth: 25.w,
                          backgroundColor: AppColors.backgroundColor,
                        ),
                        Expanded(
                          child: CustomTextField(
                            controller: _phoneController,
                            node: _phoneNode,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp("[+0-9]"),
                              )
                            ],
                            isRequired: true,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 50.h),
                    Text(
                      'PASSWORD'.tr(context),
                      style: AppTextStyles.balooMedium19,
                    ),
                    CustomTextField(
                      controller: _passwordController,
                      node: _passNode,
                      obscureText: true,
                      isRequired: true,
                      textInputAction: TextInputAction.done,
                      validator: (val) {
                        if ((val?.isEmpty ?? true) || (val?.length ?? 0) < 6) {
                          return "PASSWORD_MUST_BE_".tr(context);
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20.h),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isTermsChecked = !isTermsChecked;
                              });
                            },
                            child: Container(
                                height: 15.h,
                                width: 15.h,
                                decoration: BoxDecoration(border: Border.all(color: AppColors.darkBlue,width: 1.w)),
                                margin: EdgeInsets.only(left: 10.w),
                                child: isTermsChecked
                                    ? Center(
                                  child: Icon(
                                    Icons.check,
                                    size: 12.sp,
                                    color: AppColors.black,
                                  ),
                                )
                                    : null),
                          ),
                          // Container(
                          //   height: 15.h,
                          //   width: 15.h,
                          //   margin: EdgeInsets.only(left: 10.w),
                          //   child: Checkbox(
                          //     // activeColor: AppColors.white,
                          //     value: isTermsChecked,
                          //     onChanged: (v) {
                          //       setState(() {
                          //         isTermsChecked = v ?? false;
                          //       });
                          //     },
                          //   ),
                          // ),
                          SizedBox(width: 15.w),
                          RichText(
                            text: TextSpan(
                              text: 'I_ACCEPT_THE'.tr(context),
                              style: AppTextStyles.sansRegular15,
                              children: [
                                TextSpan(
                                  text:
                                      '${'TERMS_AND_CONDITIONS'.tr(context)}.',
                                  style: AppTextStyles.gothamLight16
                                      .copyWith(
                                          color: AppColors.darkGreen,
                                          fontStyle: FontStyle.italic,
                                          decoration: TextDecoration.underline),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () =>
                                        _termsAndCommunicationDialog(true),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Spacer(),
          MainButton(
            enabled: _canProceed,
            label: 'REGISTER'.tr(context).capitalEnabled(context, canProceed: _canProceed),
            showArrow: true,
            onTap: () {
              if (!(formKey.currentState?.validate() ?? false)) return;
              if (_canProceed) {
                widget.registerModel.firstName = _firstNameController.text;
                widget.registerModel.lastName = _lastNameController.text;
                widget.registerModel.email = _emailController.text;
                widget.registerModel.phoneNumber = _phoneController.text;
                widget.registerModel.phoneCode = dialCode;
                widget.registerModel.password = _passwordController.text;

                widget.onProceed();
              }
            },
          ),
          SizedBox(height: 50.h),
        ],
      ),
    );
  }

  _termsAndCommunicationDialog(bool isTerms) {
    showDialog(
      context: context,
      builder: (context) {
        return CustomDialog(
          color: AppColors.backgroundColor,
          closeIconColor: AppColors.darkBlue,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isTerms
                    ? "TERMS_AND_CONDITIONS".trU(context)
                    : "COMMUNICATIONS".trU(context),
                style: AppTextStyles.popupHeaderTextStyle.copyWith(color: AppColors.darkBlue),
              ),
              SizedBox(height: 20.h),
              Text(
                isTerms
                    ? 'TERMS_AND_CONDITIONS_TEXT'.tr(context)
                    : "OPT_IN_FOR_COMMUNICATIONS_TEXT".tr(context),
                textAlign: TextAlign.center,
                style: AppTextStyles.sansRegular15,
              ),
              SizedBox(height: 40.h),
            ],
          ),
        );
      },
    );
  }
}
