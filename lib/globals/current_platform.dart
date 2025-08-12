import 'dart:io' show Platform;

import 'package:flutter/widgets.dart';

enum PlatformsEnum { mobile, tablet, desktop }

class PlatformC {
  PlatformC._internal();

  factory PlatformC() => _selfInstance;

  static final PlatformC _selfInstance = PlatformC._internal();
  late PlatformsEnum currentDesignPlatform;

  init(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 450) {
      currentDesignPlatform = PlatformsEnum.mobile;
    } else if (width < 850) {
      currentDesignPlatform = PlatformsEnum.tablet;
    } else {
      currentDesignPlatform = PlatformsEnum.desktop;
    }
  }

  bool get isCurrentDesignPlatformMobile {
    return currentDesignPlatform == PlatformsEnum.mobile;
  }

  bool get isCurrentDesignPlatformTablet {
    return currentDesignPlatform == PlatformsEnum.tablet;
  }

  bool get isCurrentDesignPlatformDesktop {
    return currentDesignPlatform == PlatformsEnum.desktop;
  }

  bool get isCurrentOSMobile {
    try {
      if ((Platform.isAndroid || Platform.isIOS)) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
