import 'dart:developer';

import 'package:acepadel/globals/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:acepadel/app_styles/app_colors.dart';
import 'package:acepadel/app_styles/app_text_styles.dart';
import 'package:acepadel/components/c_divider.dart';
import 'package:acepadel/components/network_circle_image.dart';
import 'package:acepadel/components/secondary_text.dart';
import 'package:acepadel/globals/images.dart';
import 'package:acepadel/models/app_user.dart';
import 'package:acepadel/models/base_classes/booking_player_base.dart';
import 'package:acepadel/models/service_detail_model.dart';
import 'package:acepadel/models/user_assessment.dart';
import 'package:acepadel/repository/user_repo.dart';
import 'package:acepadel/routes/app_pages.dart';
import 'package:acepadel/utils/custom_extensions.dart';

import '../../components/custom_dialog.dart';
import '../../routes/app_routes.dart';
import '../home_screen/tabs/play_match_tab/play_match_tab.dart';
import '../open_match_detail/match_result_dialog/enter_match_result.dart';

part 'components.dart';

class RankingProfile extends ConsumerStatefulWidget {
  const RankingProfile(
      {super.key, required this.customerID, this.isPage = true});

  final int customerID;
  final bool isPage;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RankingProfileState();
}

class _RankingProfileState extends ConsumerState<RankingProfile> {
  @override
  Widget build(BuildContext context) {
    final assessment =
        ref.watch(fetchUserAssessmentProvider(id: widget.customerID));

    if (!widget.isPage) {
      return assessment.when(
        data: (data) {
          return _body(data);
        },
        loading: () => const Center(child: CupertinoActivityIndicator()),
        error: (error, stack) {
          log("stack: $stack");
          return Center(child: Text(error.toString()));
        },
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              SizedBox(height: 35.5.h),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 17.w),
                  child: GestureDetector(
                    onTap: () => ref.read(goRouterProvider).pop(),
                    child: Image.asset(
                      AppImages.backArrow.path,
                      height: 20.h,
                      width: 20.h,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 6.h),
              Expanded(
                child: assessment.when(
                  data: (data) {
                    return _body(data);
                  },
                  loading: () =>
                      const Center(child: CupertinoActivityIndicator()),
                  error: (error, stack) {
                    log("stack: $stack");
                    return Center(child: Text(error.toString()));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _body(UserAssessment assessment) {
    final userFromAssessment = fetchCustomer(assessment);
    if (userFromAssessment == null || assessment.customer == null) {
      return Center(
        child: SecondaryText(
          text: "NO_PAST_RANKED_MATCHES".trU(context),
        ),
      );
    }
    (assessment.assessments ?? [])
        .sort((a, b) => b.bookingDate.compareTo(a.bookingDate));
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          if (widget.isPage)
            Column(
              children: [
                InkWell(
                  onTap: () {
                    ref.read(goRouterProvider).push(RouteNames.showImage,
                        extra: [userFromAssessment.profileUrl ?? ""]);
                  },
                  child: Hero(
                    tag: "imageHero${userFromAssessment.profileUrl}",
                    child: NetworkCircleImage(
                      path: userFromAssessment.profileUrl,
                      width: 100.w,
                      height: 100.h,
                      showBG: false,
                    ),
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  (userFromAssessment.firstName ?? "").toLowerCase(),
                  style: AppTextStyles.gothamRegular16,
                ),
              ],
            ),
          SizedBox(height: 15.h),
          _PlayerRanking(level: userFromAssessment.levelD(getSportsName(ref))),
          SizedBox(height: 18.h),
          _PlayerStats(
            customerFromAssessment: userFromAssessment,
            customer: assessment.customer!,
          ),
          const SizedBox(height: 37),
          _PastMatches(
            assessments: assessment.assessments ?? [],
            customer: assessment.customer!,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  BookingCustomerBase? fetchCustomer(UserAssessment assessment) {
    if ((assessment.assessments ?? []).isEmpty) {
      if (assessment.customer != null) {
        try {
          return BookingCustomerBase.fromJson(assessment.customer!.toJson());
        } catch (e) {
          return null;
        }
      }
      return null;
    }
    int index = assessment.assessments?.first.players?.indexWhere(
          (element) => element.customer?.id == widget.customerID,
        ) ??
        -1;
    if (index == -1) {
      return null;
    }
    return assessment.assessments?.first.players?[index].customer;
  }
}
