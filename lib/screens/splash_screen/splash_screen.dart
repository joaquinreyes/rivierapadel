import 'package:acepadel/app_styles/app_colors.dart';
import 'package:acepadel/components/update_app_dialog.dart';
import 'package:acepadel/models/app_update_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:acepadel/globals/images.dart';
import 'package:acepadel/managers/user_manager.dart';
import 'package:acepadel/repository/club_repo.dart';
import 'package:acepadel/repository/user_repo.dart';
import 'package:acepadel/routes/app_pages.dart';
import 'package:acepadel/routes/app_routes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  String? currentAppVersion;
  @override
  void initState() {
    PackageInfo.fromPlatform().then((value) {
      Future(() {
        setState(() {
          currentAppVersion = value.version;
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final update = ref.watch(checkUpdateProvider);

    if (currentAppVersion == null) {
      return const _SplashBody();
    }
    return update.when(
      data: (data) {
        if (data != null && data.showUpdate(currentAppVersion!)) {
          Future(() {
            showUpdateDialog(data);
          });
        } else {
          listenToAuthentication();
        }
        return const _SplashBody();
      },
      error: (_, __) {
        listenToAuthentication();
        return const _SplashBody();
      },
      loading: () => const _SplashBody(),
    );
  }

  void listenToAuthentication() {
    ref.listen(isAuthenticatedProvider, (previous, current) {
      if (previous != current && current.value != null) {
        final isAuthenticated = current.value ?? false;

        ref.read(clubLocationsProvider);
        if (isAuthenticated) {
          ref.watch(fetchUserProvider);
        }

        Future(() {
          ref
              .read(goRouterProvider)
              .go(isAuthenticated ? RouteNames.home : RouteNames.auth);
        });
      }
    });
  }

  void showUpdateDialog(AppUpdateModel updateModel) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return PopScope(
          canPop: false,
          child: AppUpdateDialog(
            url: updateModel.url,
          ),
        );
      },
    );
  }
}

class _SplashBody extends StatelessWidget {
  const _SplashBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.lightPink,
        child: const Center(child: _Logo()),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppImages.splashLogo.path,
      width: double.infinity,
      height: 250.h,
    );
  }
}
