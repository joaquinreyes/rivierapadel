import 'dart:developer';
import 'dart:isolate';

import 'package:acepadel/components/custom_dialog.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:acepadel/app_styles/app_colors.dart';
import 'package:acepadel/app_styles/app_text_styles.dart';
import 'package:acepadel/components/custom_textfield.dart';
import 'package:acepadel/components/main_button.dart';
import 'package:acepadel/components/selected_tag.dart';
import 'package:acepadel/globals/constants.dart';
import 'package:acepadel/globals/current_platform.dart';
import 'package:acepadel/globals/images.dart';
import 'package:acepadel/globals/playing_side.dart';
import 'package:acepadel/globals/utils.dart';
import 'package:acepadel/models/app_user.dart';
import 'package:acepadel/models/level_questions.dart';
import 'package:acepadel/models/register_model.dart';
import 'package:acepadel/repository/level_repo.dart';
import 'package:acepadel/repository/user_repo.dart';
import 'package:acepadel/repository/club_repo.dart';
import 'package:acepadel/routes/app_pages.dart';
import 'package:acepadel/routes/app_routes.dart';
import 'package:acepadel/screens/app_provider.dart';
import 'package:acepadel/utils/custom_extensions.dart';

import '../../../managers/fcm_manager.dart';
part 'signup_form_tab.dart';
part 'select_your_position_tab.dart';
part 'level_assessment_tab.dart';
part 'level_score_tab.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(levelQuestionsProvider);
    final height = MediaQuery.of(context).size.height;
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (notification) {
        notification.disallowIndicator();
        return true;
      },
      child: Container(
        decoration: BoxDecoration(
          image: PlatformC().isCurrentDesignPlatformDesktop
              ? DecorationImage(
                  image: AssetImage(AppImages.webStaticPage.path),
                  fit: BoxFit.fitWidth,
                )
              : null,
        ),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Scaffold(
            backgroundColor: PlatformC().isCurrentDesignPlatformDesktop
                ? Colors.transparent
                : AppColors.lightPink,
            body: provider.when(
              data: (data) {
                return _SignupFlow(levelQuestions: data);
              },
              loading: () => const Center(child: CupertinoActivityIndicator()),
              error: (e, _) => Center(child: Text(e.toString())),
            ),
          ),
        ),
      ),
    );
  }
}

class _SignupFlow extends ConsumerStatefulWidget {
  const _SignupFlow({super.key, required this.levelQuestions});
  final List<LevelQuestion> levelQuestions;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => __SignupFlowState();
}

class __SignupFlowState extends ConsumerState<_SignupFlow> {
  int pageIndex = 0;
  PageController pageController = PageController();
  RegisterModel registerModel = RegisterModel();
  int totalPages = 3;
  @override
  void initState() {
    totalPages = widget.levelQuestions.length + 3;
    registerModel.levelAnswers =
        List.filled(widget.levelQuestions.length, null);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Center(
        child: Container(
          height: height,
          color: AppColors.lightPink,
          margin: EdgeInsets.symmetric(
              vertical: PlatformC().isCurrentDesignPlatformDesktop ? 30 : 0),
          constraints: kComponentWidthConstraint,
          child: SafeArea(
            child: Column(
              children: [
                SizedBox(height: 34.5.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 32.w),
                  alignment: AlignmentDirectional.centerStart,
                  child: InkWell(
                    onTap: _onBack,
                    child: Image.asset(
                      AppImages.arrowBack.path,
                      height: 24.h,
                    ),
                  ),
                ),
                Text(
                  'REGISTER'.tr(context),
                  style: AppTextStyles.panchangBold26,
                ),
                Expanded(
                  child: PageView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: pageController,
                    onPageChanged: (i) => pageIndex = i,
                    children: [
                      _SignUpFormTab(
                        registerModel: registerModel,
                        onProceed: () {
                          pageController.animateToPage(
                            1,
                            duration: kAnimationDuration,
                            curve: Curves.linear,
                          );
                        },
                      ),
                      for (int i = 0; i < widget.levelQuestions.length; i++)
                        _LevelAssessmentTab(
                          index: i,
                          isLastQuestion: i == widget.levelQuestions.length - 1,
                          levelQuesiton: widget.levelQuestions[i],
                          registerModel: registerModel,
                          onProceed: () {
                            pageController.animateToPage(
                              pageIndex + 1,
                              duration: kAnimationDuration,
                              curve: Curves.linear,
                            );
                          },
                        ),
                      _LevelScoreTab(
                        registerModel: registerModel,
                        onProceed: () {
                          pageController.animateToPage(
                            pageIndex + 1,
                            duration: kAnimationDuration,
                            curve: Curves.linear,
                          );
                        },
                      ),
                      _SelectYourPosition(
                        registerModel: registerModel,
                        onProceed: () async {
                          final signupProvider =
                              registerUserProvider(registerModel);
                          final AppUser? user = await Utils.showLoadingDialog(
                              context, signupProvider, ref);

                          if (user != null && context.mounted) {
                            if (FcmManager().token.isNotEmpty) {
                              ref.watch(
                                  saveFCMTokenProvider(FcmManager().token));
                            }
                            ref.watch(getCourtBookingProvider);
                            ref.read(pageIndexProvider.notifier).index = 1;
                            ref.read(goRouterProvider).go(RouteNames.home);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _onBack() {
    if (pageIndex == 0) {
      Navigator.pop(context);
    } else if (pageIndex == 1) {
      pageController.animateToPage(0,
          duration: kAnimationDuration, curve: Curves.linear);
    } else {
      pageController.animateToPage(pageIndex - 1,
          duration: kAnimationDuration, curve: Curves.linear);
    }
  }
}
