import 'dart:io';
import 'package:acepadel/components/custom_dialog.dart';
import 'package:acepadel/main.dart';
import 'package:acepadel/models/app_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:acepadel/CustomDatePicker/flutter_datetime_picker.dart';
import 'package:acepadel/CustomDatePicker/src/date_model.dart';
import 'package:acepadel/CustomDatePicker/src/i18n_model.dart';
import 'package:acepadel/app_styles/app_colors.dart';
import 'package:acepadel/app_styles/app_text_styles.dart';
import 'package:acepadel/components/image_src_sheet.dart';
import 'package:acepadel/components/main_button.dart';
import 'package:acepadel/components/network_circle_image.dart';
import 'package:acepadel/globals/constants.dart';
import 'package:acepadel/globals/current_platform.dart';
import 'package:acepadel/globals/images.dart';
import 'package:acepadel/globals/utils.dart';
import 'package:acepadel/managers/api_manager.dart';
import 'package:acepadel/managers/socket_manager/socket_manager.dart';
import 'package:acepadel/managers/user_manager.dart';
import 'package:acepadel/repository/location_repo.dart';
import 'package:acepadel/repository/user_repo.dart';
import 'package:acepadel/screens/app_provider.dart';
import 'package:acepadel/screens/home_screen/nav_bar.dart';
import 'package:acepadel/screens/home_screen/tabs/booking_tab/booking_tab.dart';
import 'package:acepadel/screens/home_screen/tabs/play_match_tab/play_match_tab.dart';
import 'package:acepadel/screens/home_screen/tabs/profile_tab/profile_tab.dart';
import 'package:acepadel/screens/responsive_widgets/home_responsive_widget.dart';
import 'package:acepadel/utils/custom_extensions.dart';
import 'package:acepadel/utils/dubai_date_time.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../managers/dynamic_link_handler.dart';
import '../../managers/fcm_manager.dart';
import 'booking_cart/booking_cart.dart';

part 'home_screen_components.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final List<Widget> _pages = [
    const PlayMatchTab(),
    const BookingTab(),
    const ProfileTab(),
  ];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      globalRef = ref;
      FcmManager().getInitialMessage();
      DynamicLinkHandler.instance.initialize(ref);
      final userID = ref.read(userManagerProvider).user?.user?.id;
      final token = ref.read(userManagerProvider).user?.accessToken;
      if (userID != null && token != null) {
        ref.read(socketProvider.notifier).connect(
              kClubID,
              userID,
              token,
            );
      }
      final user = ref.read(userManagerProvider).user;
      final image = user?.user?.profileUrl;
      final startedPlaying = user?.user?.startedPlaying;
      final bool selectImage = image?.isEmpty ?? true;
      final bool selectDate = startedPlaying?.isEmpty ?? true;
      if (selectImage || selectDate) {
        showDialog(
          context: context,
          builder: (context) {
            return _AddProfilePicture(
              selectDate: selectDate,
              selectImage: selectImage,
            );
          },
        );
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(fetchLocationProvider);
    ref.listen(
      pageIndexProvider,
      (previous, next) {
        if (previous != next) {
          ref.read(pageControllerProvider).animateToPage(
                next,
                duration: kAnimationDuration,
                curve: Curves.linear,
              );
        }
      },
    );
    final pageController = ref.watch(pageControllerProvider);
    return Scaffold(
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const BookingCart(),
          if (!(PlatformC().isCurrentDesignPlatformDesktop)) const NavBar(),
        ],
      ),
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (notification) {
          notification.disallowIndicator();
          return true;
        },
        child: SafeArea(
          child: HomeResponsiveWidget(
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: pageController,
              children: _pages,
            ),
          ),
        ),
      ),
    );
  }
}
