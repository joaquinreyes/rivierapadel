part of 'settings.dart';

class _EditProfile extends ConsumerStatefulWidget {
  const _EditProfile({super.key, required this.user});
  final User user;
  @override
  ConsumerState<_EditProfile> createState() => __EDITProfileState();
}

class __EDITProfileState extends ConsumerState<_EditProfile> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _levelController = TextEditingController();

  Map<String, dynamic> userCustomFields = {};
  Map<String, dynamic> customFieldTextFields = {};
  Map<String, GlobalKey<CustomDropDownState>> customFieldDropDownsKeys = {};
  @override
  void initState() {
    _firstNameController.text = widget.user.firstName ?? "";
    _lastNameController.text = widget.user.lastName ?? "";
    _emailController.text = widget.user.email ?? "";
    _phoneController.text = widget.user.phoneNumber ?? "";
    _levelController.text = widget.user.level(getSportsName(ref)).toString();
    userCustomFields = widget.user.customFields.map(
      (key, value) => MapEntry(key, value),
    );
    super.initState();
  }

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
                "EDIT_YOUR_INFORMATION".tr(context),
                style: AppTextStyles.popupHeaderTextStyle,
              ),
              SizedBox(height: 10.h),
              _buildTextField(
                "FIRST_NAME".tr(context),
                _firstNameController,
              ),
              SizedBox(height: 10.h),
              _buildTextField(
                "LAST_NAME".tr(context),
                _lastNameController,
              ),
              SizedBox(height: 10.h),
              _buildTextField(
                "EMAIL".tr(context),
                _emailController,
                enabled: false,
              ),
              SizedBox(height: 10.h),
              _buildTextField(
                "PHONE_NUMBER".tr(context),
                _phoneController,
                isNumber: true,
              ),
              SizedBox(height: 10.h),
              _buildTextField(
                "LEVEL".tr(context),
                _levelController,
                enabled: false,
                isNumber: true,
              ),
              SizedBox(height: 10.h),
              _editCustomFields(),
              SizedBox(height: 20.h),
              MainButton(
                label: "SAVE".tr(context),
                enabled: true,
                isForPopup: true,
                onTap: () async {
                  final customFields = <String, dynamic>{};
                  for (final key in userCustomFields.keys) {
                    customFields[key] = userCustomFields[key];
                  }
                  User user = widget.user.copyWithForUpdate(
                    firstName: _firstNameController.text,
                    lastName: _lastNameController.text,
                    email: _emailController.text,
                    phoneNumber: _phoneController.text,
                    customFields: customFields,
                  );

                  bool? done = await Utils.showLoadingDialog(
                      context, updateUserProvider(user), ref);
                  if (done == true && context.mounted) {
                    Navigator.pop(context);
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _editCustomFields() {
    final data = ref.watch(fetchAllCustomFieldsProvider);
    return data.when(
      data: (data) {
        final allCustomFields = data;
        for (int i = 0; i < allCustomFields.length; i++) {
          final customField = allCustomFields[i];
          if (userCustomFields.containsKey(customField.columnName)) {
            userCustomFields[customField.sId!] =
                userCustomFields.remove(customField.columnName);
          }
        }
        return ListView.separated(
          shrinkWrap: true,
          itemCount: allCustomFields.length,
          separatorBuilder: (context, index) {
            final customField = allCustomFields[index];
            if (customField.columnType == null ||
                (customField.columnName?.isEmpty ?? true) ||
                (customField.sId?.isEmpty ?? true)) {
              return Container();
            }
            return SizedBox(height: 10.h);
          },
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final customField = allCustomFields[index];
            switch (customField.columnType) {
              case ColumnType.date:
                return _buildDateField(customField);
              case ColumnType.selectbox:
                return _buildMultiSelectDropDown(
                  customField,
                );
              case ColumnType.radiobutton:
              case ColumnType.dropdown:
                return _buildSingleSelectDropDownField(
                  customField,
                );
              case ColumnType.number:
                if (!customFieldTextFields.containsKey(customField.sId ?? "")) {
                  final controller = TextEditingController();
                  controller.text =
                      (userCustomFields[customField.sId ?? ""] ?? "")
                          .toString();
                  customFieldTextFields[customField.sId ?? ""] = controller;
                }
                return _buildTextField(
                  customField.columnName ?? "",
                  customFieldTextFields[customField.sId ?? ""]!,
                  id: customField.sId,
                  isNumber: true,
                );

              case ColumnType.string:
                if (!customFieldTextFields.containsKey(customField.sId ?? "")) {
                  final controller = TextEditingController();
                  controller.text =
                      (userCustomFields[customField.sId ?? ""] ?? "")
                          .toString();
                  customFieldTextFields[customField.sId ?? ""] = controller;
                }
                return _buildTextField(
                  customField.columnName ?? "",
                  customFieldTextFields[customField.sId ?? ""]!,
                  id: customField.sId,
                  isNumber: false,
                );

              default:
                return Container(
                  height: 10,
                  color: Colors.red,
                  child: Text(customField.columnName ?? ""),
                );
            }
          },
        );
      },
      error: (err, st) => Container(),
      loading: () => Container(),
    );
  }

  Widget _buildDateField(CustomFields customField) {
    String id = customField.sId ?? "";
    String label = customField.columnName ?? "";
    DateTime? selectedDate = userCustomFields[id] != null
        ? DateTime.tryParse(userCustomFields[id])
        : null;
    return Opacity(
      opacity: customField.editableForUsers == true ? 1 : 0.5,
      child: _buildField(
        label,
        InkWell(
          onTap: customField.editableForUsers != true
              ? null
              : () async {
                  FocusScope.of(context).unfocus();
                  await DatePicker.showPicker(
                    context,
                    onConfirm: (date) {
                      setState(() {
                        userCustomFields[id] = date.toIso8601String();
                      });
                      FocusScope.of(context).unfocus();
                    },
                    pickerModel: CustomMonthPicker(
                      minTime: DubaiDateTime.now()
                          .dateTime
                          .subtract(const Duration(days: 365 * 60)),
                      maxTime: DubaiDateTime.now().dateTime,
                      currentTime: selectedDate ?? DubaiDateTime.now().dateTime,
                    ),
                  );
                },
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 12.w,
              vertical: 6.h,
            ),
            decoration: BoxDecoration(
              color: AppColors.white25,
              borderRadius: BorderRadius.circular(5.r),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    selectedDate != null
                        ? selectedDate.format("MMMM yyyy")
                        : "mm/yyyy",
                    style: AppTextStyles.helveticaRegular12.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                ),
                Image.asset(
                  AppImages.dropdownIcon.path,
                  width: 10.w,
                  color: AppColors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMultiSelectDropDown(
    CustomFields customField,
  ) {
    String id = customField.sId ?? "";
    String label = customField.columnName ?? "";
    List<String> options = customField.options ?? [];
    if (!customFieldDropDownsKeys.containsKey(id)) {
      customFieldDropDownsKeys[id] = GlobalKey<CustomDropDownState>();
    }
    String labelToShow = "Select $label";
    if (userCustomFields.containsKey(id)) {
      labelToShow = userCustomFields[id].join(", ");
    }
    return AbsorbPointer(
      absorbing: customField.editableForUsers == false ||
          customField.editableForUsers == null,
      child: Opacity(
        opacity: customField.editableForUsers != true ? 0.5 : 1,
        child: _buildField(
          label,
          CustomDropDown(
            key: customFieldDropDownsKeys[id],
            label: labelToShow,
            items: options,
            onExpansionChanged: (isExpanded) {
              for (final key in customFieldDropDownsKeys.keys) {
                if (key != id) {
                  customFieldDropDownsKeys[key]?.currentState?.close();
                }
              }
            },
            childrenBuilder: (str, index) {
              bool isSelected = false;
              if (userCustomFields.containsKey(id)) {
                isSelected = userCustomFields[id].contains(str);
              }
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 0.5.h),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      if (userCustomFields[id] == null) {
                        userCustomFields[id] = [str];
                      } else {
                        if (isSelected) {
                          userCustomFields[id].remove(str);
                        } else {
                          userCustomFields[id].add(str);
                        }
                      }
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: !isSelected
                          ? AppColors.white25
                          : AppColors.yellow50Popup,
                      borderRadius: BorderRadius.circular(5.r),
                    ),
                    child: Text(
                      str,
                      style: isSelected
                          ? AppTextStyles.helveticaRegular12
                          : AppTextStyles.helveticaLight12
                              .copyWith(color: AppColors.white),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSingleSelectDropDownField(
    CustomFields customField,
  ) {
    String id = customField.sId ?? "";
    String label = customField.columnName ?? "";
    List<String> options = customField.options ?? [];
    if (!customFieldDropDownsKeys.containsKey(id)) {
      customFieldDropDownsKeys[id] = GlobalKey<CustomDropDownState>();
    }
    return Opacity(
      opacity: customField.editableForUsers == true ? 1 : 0.5,
      child: AbsorbPointer(
        absorbing: customField.editableForUsers == false ||
            customField.editableForUsers == null,
        child: _buildField(
          label,
          CustomDropDown(
            key: customFieldDropDownsKeys[id],
            label: userCustomFields[id] ?? "Select $label",
            items: options,
            onExpansionChanged: (isExpanded) {
              for (final key in customFieldDropDownsKeys.keys) {
                if (key != id) {
                  customFieldDropDownsKeys[key]?.currentState?.close();
                }
              }
            },
            childrenBuilder: (str, index) {
              bool isSelected = userCustomFields[id] == str;
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 0.5.h),
                child: InkWell(
                  onTap: () {
                    customFieldDropDownsKeys[id]
                        ?.currentState
                        ?.toggleExpansion();
                    setState(() {
                      userCustomFields[id] = str;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: !isSelected
                          ? AppColors.white25
                          : AppColors.yellow50Popup,
                      borderRadius: BorderRadius.circular(5.r),
                    ),
                    child: Text(
                      str,
                      style: isSelected
                          ? AppTextStyles.helveticaRegular12
                          : AppTextStyles.helveticaLight12
                              .copyWith(color: AppColors.white),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {String? id, bool isNumber = false, bool enabled = true}) {
    return _buildField(
      label,
      SecondaryTextField(
        controller: controller,
        isEnabled: enabled,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        onChanged: (_) {
          if (id != null) {
            if (isNumber) {
              int? val = int.tryParse(controller.text);
              userCustomFields[id] = val;
              controller.text = val != null ? val.toString() : "";
            } else {
              userCustomFields[id] = controller.text;
            }
          }
          setState(() {});
        },
      ),
    );
  }

  Widget _buildField(String header, Widget widget) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            header,
            style: AppTextStyles.panchangMedium12.copyWith(
              color: AppColors.white,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: widget,
        ),
      ],
    );
  }
}
