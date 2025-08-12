part of 'settings.dart';

class _DeletePasswordBtns extends ConsumerWidget {
  const _DeletePasswordBtns();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        SecondaryButton(
          applyShadow: false,
          onTap: () async {
            final done = await showDialog(
              context: context,
              builder: (context) => const _DeleteAccountConfirmation(),
            );
            if (done == true && context.mounted) {
              Utils.showMessageDialog(
                context,
                "ACCOUNT_DELETED".tr(context),
              );
              ref.read(userManagerProvider).signout(ref);
              ref.read(goRouterProvider).pushReplacement(RouteNames.auth);
            }
          },
          child: Text(
            "DELETE_ACCOUNT".tr(context),
            style: AppTextStyles.gothamLight12,
          ),
        ),
        const Spacer(),
        SecondaryButton(
          applyShadow: false,
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => const _ChangePasswordDialog(),
            );
          },
          child: Text(
            "CHANGE_PASSWORD".tr(context),
            style: AppTextStyles.gothamLight12,
          ),
        )
      ],
    );
  }
}

class _CustomFields extends ConsumerStatefulWidget {
  const _CustomFields({required this.user});

  final User user;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => __CustomFieldsState();
}

class __CustomFieldsState extends ConsumerState<_CustomFields> {
  @override
  Widget build(BuildContext context) {
    final data = ref.watch(fetchAllCustomFieldsProvider);
    final userCustomFields = widget.user.customFields.map((key, value) {
      return MapEntry(key, value);
    });
    if (widget.user.customFields.isEmpty) {
      return Container();
    }

    return data.when(
      data: (data) {
        final allCustomFields = data;
        allCustomFields.removeWhere((element) =>
            element.visibleForUsers == false ||
            element.visibleForUsers == null);
        for (int i = 0; i < allCustomFields.length; i++) {
          final customField = allCustomFields[i];
          if (userCustomFields.containsKey(customField.columnName)) {
            userCustomFields[customField.sId!] =
                userCustomFields.remove(customField.columnName);
          }
        }
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: allCustomFields.map((customField) {
            String value = "";
            if (userCustomFields.containsKey(customField.sId)) {
              value = userCustomFields[customField.sId].toString();
            }
            if (customField.columnType == ColumnType.date) {
              final date = DateTime.tryParse(value);
              value = date == null ? "" : date.format("MMMM yyyy");
            }
            if ((customField.columnName ?? "").toLowerCase() == "level") {
              return const SizedBox();
            }
            return Padding(
              padding: EdgeInsets.only(top: 10.h),
              child: _buildInfoField(
                (customField.columnName ?? "").capitalizeFirst,
                value,
              ),
            );
          }).toList(),
        );
      },
      loading: () => Container(),
      error: (error, _) => Text(error.toString()),
    );
  }
}

Row _buildInfoField(String heading, String value) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        heading,
        style: AppTextStyles.gothamRegular13,
      ),
      Text(
        value,
        style: AppTextStyles.gothamLight13,
      ),
    ],
  );
}

class _ChangePasswordDialog extends ConsumerStatefulWidget {
  const _ChangePasswordDialog();

  @override
  ConsumerState<_ChangePasswordDialog> createState() =>
      __ChangePasswordDialogState();
}

class __ChangePasswordDialogState extends ConsumerState<_ChangePasswordDialog> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();

  bool get enabled =>
      _oldPasswordController.text.isNotEmpty &&
      _newPasswordController.text.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomDialog(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "CHANGE_PASSWORD".tr(context),
                style: AppTextStyles.popupHeaderTextStyle,
              ),
              SizedBox(height: 25.h),
              Row(
                children: [
                  Text(
                    "CURRENT_PASSWORD".tr(context),
                    style: AppTextStyles.balooMedium12.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    "RECOVER".tr(context),
                    style: AppTextStyles.gothamLight13.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5.h),
              SecondaryTextField(
                controller: _oldPasswordController,
                hintText: "TYPE_HERE".tr(context),
                obscureText: true,
                onChanged: (p0) {
                  setState(() {});
                },
              ),
              SizedBox(height: 15.h),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  "NEW_PASSWORD".tr(context),
                  style: AppTextStyles.balooMedium12.copyWith(
                    color: AppColors.white,
                  ),
                ),
              ),
              SizedBox(height: 5.h),
              SecondaryTextField(
                controller: _newPasswordController,
                hintText: "TYPE_HERE".tr(context),
                obscureText: true,
                onChanged: (p0) {
                  setState(() {});
                },
              ),
              SizedBox(height: 25.h),
              MainButton(
                label: "CHANGE_PASSWORD".tr(context),
                isForPopup: true,
                enabled: enabled,
                onTap: () async {
                  // ref.read(updatePasswordProvider);
                  final provider = updatePasswordProvider(
                    oldPassword: _oldPasswordController.text,
                    newPassword: _newPasswordController.text,
                  );
                  final done =
                      await Utils.showLoadingDialog(context, provider, ref);
                  if (done == true && context.mounted) {
                    Navigator.pop(context);
                    Utils.showMessageDialog(
                      context,
                      "PASSWORD_SUCCESSFULLY_CHANGED".tr(context),
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _DeleteAccountConfirmation extends ConsumerStatefulWidget {
  const _DeleteAccountConfirmation();

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      __DeleteAccountConfirmationState();
}

class __DeleteAccountConfirmationState
    extends ConsumerState<_DeleteAccountConfirmation> {
  final TextEditingController _passwordController = TextEditingController();

  bool get enabled => _passwordController.text.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomDialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "DELETE_CONFIRMATION".tr(context),
              style: AppTextStyles.popupHeaderTextStyle,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 5.h),
            Text(
              "DELETE_CONFIRMATION_DESC".tr(context),
              style: AppTextStyles.popupBodyTextStyle,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 15.h),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                "PASSWORD".tr(context),
                style: AppTextStyles.balooMedium12.copyWith(
                  color: AppColors.white,
                ),
              ),
            ),
            SizedBox(height: 5.h),
            SecondaryTextField(
              controller: _passwordController,
              hintText: "TYPE_HERE".tr(context),
              obscureText: true,
              onChanged: (p0) {
                setState(() {});
              },
            ),
            SizedBox(height: 20.h),
            MainButton(
              label: "DELETE_ACCOUNT".tr(context),
              enabled: enabled,
              isForPopup: true,
              onTap: () async {
                final provider = deleteAccountProvider(
                  password: _passwordController.text,
                );
                final done =
                    await Utils.showLoadingDialog(context, provider, ref);
                if (done == true && context.mounted) {
                  Navigator.pop(context, true);
                }
              },
            )
          ],
        ),
      ),
    );
  }
}

class TransactionList extends ConsumerWidget {
  final bool isForPopUp;

  const TransactionList({super.key, this.isForPopUp = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(transactionsProvider);
    final showShareButton = ref.watch(_showShareButton);
    return Column(
      children: [
        if (!isForPopUp)
          Row(
            children: [
              Text(
                "TRANSACTION_HISTORY".tr(context),
                style: AppTextStyles.balooBold13,
              ),
              SizedBox(width: 5.w),
              if (showShareButton)
                InkWell(
                  onTap: () async {
                    await showDialog(
                      context: context,
                      builder: (context) {
                        return CustomDialog(
                            child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.h),
                              child: Text(
                                "TRANSACTION_HISTORY".tr(context),
                                style: AppTextStyles.balooBold13
                                    .copyWith(color: AppColors.white),
                              ),
                            ),
                            const TransactionList(isForPopUp: true)
                          ],
                        ));
                      },
                    );
                  },
                  child: Image.asset(AppImages.shareIcon.path,
                      width: 17.w, height: 17.w),
                ),
              SizedBox(width: 10.w),
              Text(
                "(${"LATEST".tr(context)})",
                style: AppTextStyles.gothamLight13
                    .copyWith(color: AppColors.darkGreen),
              ),
            ],
          ),
        if (!isForPopUp) SizedBox(height: 5.h),
        transactions.when(
          data: (data) {
            List<TransactionModel> list = [...data];
            if (!showShareButton) {
              Future(() {
                ref.read(_showShareButton.notifier).state = data.length > 3;
              });
            }
            if (list.length > 3 && !isForPopUp) {
              list = list.sublist(0, 3);
            }
            return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: list.map((e) {
                  String showDate = e.date ?? "-";
                  final date = DateTime.tryParse(showDate);
                  if (date != null) {
                    showDate = date.format("dd/MM/yyyy");
                  } else {
                    showDate = "-";
                  }

                  final status = e.status ?? "-";
                  final paymentMethod = e.paymentMethod ?? "-";
                  final amount = Utils.formatPrice(e.amount);

                  return Padding(
                      padding: EdgeInsets.only(bottom: 3.h),
                      child: Row(
                        children: [
                          Expanded(
                              child: Text(
                            showDate,
                            style: AppTextStyles.gothamLight13.copyWith(
                                color: isForPopUp
                                    ? AppColors.white
                                    : AppColors.darkGreen),
                          )),
                          Expanded(
                              child: Text(
                            status,
                            style: AppTextStyles.gothamLight13.copyWith(
                                color: isForPopUp
                                    ? AppColors.white
                                    : AppColors.darkGreen),
                            textAlign: TextAlign.center,
                          )),
                          Expanded(
                              flex: 1,
                              child: Text(
                                paymentMethod.capitalizeFirst,
                                style: AppTextStyles.gothamRegular14
                                    .copyWith(
                                        color: isForPopUp
                                            ? AppColors.white
                                            : AppColors.darkGreen),
                                textAlign: TextAlign.center,
                              )),
                          Expanded(
                              child: Text(
                            amount,
                            style: AppTextStyles.gothamLight13.copyWith(
                                color: isForPopUp
                                    ? AppColors.white
                                    : AppColors.darkGreen),
                            textAlign: TextAlign.center,
                          )),
                        ],
                      ));
                }).toList());
          },
          error: (err, __) => SecondaryText(text: err.toString()),
          loading: () => const Center(
            child: CupertinoActivityIndicator(),
          ),
        )
      ],
    );
  }
}
