import 'dart:io';
import 'dart:typed_data';
import 'package:acepadel/models/club_locations.dart';
import 'package:acepadel/models/payment_methods.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:acepadel/components/async_dialog.dart';
import 'package:acepadel/components/message_dialog.dart';
import 'package:acepadel/utils/custom_extensions.dart';
import 'package:acepadel/utils/dubai_date_time.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;
import 'package:image/image.dart' as img;
import 'package:url_launcher/url_launcher.dart';

import '../managers/dynamic_link_handler.dart';
import '../models/base_classes/booking_player_base.dart';
import '../models/lesson_models.dart';
import '../models/service_detail_model.dart';
import 'constants.dart';

class Utils {
  static showLoadingDialog<T>(
      BuildContext context, AutoDisposeFutureProvider value, WidgetRef ref,
      {bool? barrierDismissible}) async {
    ref.invalidate(value);
    return await showDialog(
      barrierDismissible: barrierDismissible ?? true,
      context: context,
      builder: (context) {
        return AsyncDialog(provider: value);
      },
    );
  }

  static List<ServiceDetail_Coach> fetchLessonCoaches(LessonsModel lesson) {
    List<ServiceDetail_Coach> coaches = [];
    Set<int> seenIds = {};
    lesson.coaches.map((e) {
      if (!seenIds.contains(e.id)) {
        seenIds.add(e.id ?? 0);
        coaches.add(e);
      }
    }).toList();
    return coaches;
  }

  static Future<void> openWhatsapp(
      {required BuildContext context, message}) async {
    try {
      final encodedMessage = Uri.encodeComponent(message);
      final Uri url = Uri.parse('whatsapp://send?text=$encodedMessage');
      // final Uri url = Uri.parse('$kWhatsAppLink?text=$encodedMessage');

      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        if (!context.mounted) {
          return;
        }
        Utils.showMessageDialog(
          context,
          "NO_WHATSAPP_APP_DETECTED".tr(context),
        );
      }
    } catch (_) {
      myPrint('Error opening whatsapp');
    }
  }

  static Future<void> showMessageDialog(
      BuildContext context, String message) async {
    await showDialog(
      context: context,
      builder: (context) {
        return MessageDialog(message: message);
      },
    );
  }

  static List<List<T>> getChunks<T>(List<T> list, int chunkSize) {
    List<List<T>> chunks = [];
    int len = list.length;
    for (var i = 0; i < len; i += chunkSize) {
      int size = i + chunkSize;
      chunks.add(list.sublist(i, size > len ? len : size));
    }
    return chunks;
  }

  static String formatPrice(double? price) {
    if (price == null) {
      return '0 $currency';
    }

    final formatter = NumberFormat('#,##0', 'id_ID');

    // Format the price with thousands separator (.)
    return '${formatter.format(price).replaceAll(',', '.')} $currency';
  }

  static String formatPrice2(double? price, String currency) {
    if (price == null) {
      return '0 $currency';
    }

    final formatter = NumberFormat('#,##0', 'id_ID');

    // Format the price with thousands separator (.)
    return '${formatter.format(price).replaceAll(',', '.')} $currency';
  }

  static DateTime serverTimeToDateTime(String time, DateTime date) {
    final timeSplit = time.split(':');
    final dateTime = DubaiDateTime.custom(
      date.year,
      date.month,
      date.day,
      int.parse(timeSplit[0]),
      int.parse(timeSplit[1]),
    ).dateTime;
    return dateTime;
  }

  static String formatBookingDate(DateTime date, BuildContext context) {
    final now = DubaiDateTime.now().dateTime;
    final today = DubaiDateTime.custom(now.year, now.month, now.day).dateTime;
    final tomorrow =
        DubaiDateTime.custom(now.year, now.month, now.day + 1).dateTime;
    final bookingDate =
        DubaiDateTime.custom(date.year, date.month, date.day).dateTime;
    if (today.isAtSameMomentAs(bookingDate)) {
      return 'TODAY'.tr(context);
    } else if (tomorrow.isAtSameMomentAs(bookingDate)) {
      return 'TOMORROW'.tr(context);
    } else {
      return date.format('EE d MMM');
    }
  }

  static double calculateDistance(
      double lat1, double lng1, double lat2, double lng2) {
    const double earthRadius = 6371; // Earth's radius in kilometers

    // Convert latitude and longitude from degrees to radians
    double lat1Rad = radians(lat1);
    double lng1Rad = radians(lng1);
    double lat2Rad = radians(lat2);
    double lng2Rad = radians(lng2);

    // Calculate the differences between coordinates
    double deltaLat = lat2Rad - lat1Rad;
    double deltaLng = lng2Rad - lng1Rad;

    // Haversine formula
    double a = math.sin(deltaLat / 2) * math.sin(deltaLat / 2) +
        math.cos(lat1Rad) *
            math.cos(lat2Rad) *
            math.sin(deltaLng / 2) *
            math.sin(deltaLng / 2);
    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    // Calculate the distance
    double distance = earthRadius * c;

    return distance;
  }

  static double radians(double degrees) {
    return degrees * (math.pi / 180);
  }

  static Color calculateColorOverBackground(
      Color color, String alphaHex, Color backgroundColor) {
    double opacity = int.parse(alphaHex, radix: 16) / 255.0;

    int red =
        ((color.red * opacity) + (backgroundColor.red * (1 - opacity))).round();
    int green =
        ((color.green * opacity) + (backgroundColor.green * (1 - opacity)))
            .round();
    int blue = ((color.blue * opacity) + (backgroundColor.blue * (1 - opacity)))
        .round();

    return Color.fromRGBO(red, green, blue, 1.0);
  }

  static Future<File?> bakeImageOrientation(File imageFile) async {
    // Step 1: Read the file as a byte array
    final Uint8List imageBytes = await imageFile.readAsBytes();

    // Step 2: Decode the image to handle EXIF data
    img.Image? image = img.decodeImage(imageBytes);

    if (image == null) {
      return null; // Return null if decoding fails
    }

    // Step 3: Correct the orientation by baking EXIF orientation into the image
    final img.Image orientedImage = img.bakeOrientation(image);

    // Step 4: Write the corrected image back to the file
    final File bakedFile =
        await imageFile.writeAsBytes(img.encodeJpg(orientedImage));

    return bakedFile; // Return the corrected image file
  }

  // static calculateMDR(double amount, MDRRates mdrRate) {
  //   double percentage = mdrRate.percentage ?? 0;
  //   double fixedAmount = mdrRate.fixedAmount ?? 0;
  //   return (amount * percentage / 100) + fixedAmount;
  // }
  static double calculateMDR(double amount, MDRRates mdrRate) {
    double percentage = mdrRate.percentage ?? 0;
    double fixedAmount = mdrRate.fixedAmount ?? 0;

    // Calculate the base amount including the MDR fixed amount
    double baseAmount = amount + fixedAmount;

    // Calculate the denominator based on the MDR percentage
    double denominator = (100 - percentage) / 100;

    // Calculate the final amount before rounding
    double finalAmount = baseAmount / denominator;

    // Round up to the nearest hundred
    return roundupHundreds(finalAmount) - amount;
  }

// Helper function to round up to the nearest hundred
  static double roundupHundreds(double value) {
    return (value / 100).ceil() * 100;
  }

  static List<ClubLocationSports> fetchSportsList(
      List<ClubLocationData> locations) {
    List<ClubLocationSports> sportsList = [];
    for (var location in locations) {
      for (var sport in location.sports) {
        final alreadyExists = sportsList
                .firstWhere(
                    (element) =>
                        (element.sportName ?? "").toLowerCase() ==
                        (sport.sportName ?? "").toLowerCase(),
                    orElse: () => ClubLocationSports(sportName: ''))
                .sportName !=
            '';
        if ((sport.sportName?.isNotEmpty ?? false) && !alreadyExists) {
          sportsList.add(sport);
        }
      }
    }
    sportsList.removeWhere((element) => element.sportName?.isEmpty ?? true);
    return sportsList.reversed.toList();
    // return sportsList;
  }

  static int getFutureDateLength(
      List<ClubLocationData> locations, String sportName) {
    int maxLen = 0;

    for (var location in locations) {
      int indexOfSport = location.sports.indexWhere((element) =>
          element.sportName?.toLowerCase() == sportName.toLowerCase());
      if (indexOfSport == -1) {
        continue;
      }
      final sport = location.sports[indexOfSport];
      for (ClubLocationSportsCourts court in sport.courts ?? []) {
        final courtLength = court.appBookableDaysInFuture ?? 0;
        if (courtLength > maxLen) {
          maxLen = courtLength;
        }
      }
    }
    return maxLen;
  }

  static String eventLessonStatusText({
    required BuildContext context,
    required int playersCount,
    int? maxCapacity,
    int? minCapacity,
  }) {
    maxCapacity = maxCapacity ?? 0;
    minCapacity = minCapacity ?? 0;

    if (playersCount >= maxCapacity) {
      return "FILLED".tr(context);
    } else if (playersCount >= minCapacity) {
      return "CONFIRMED".tr(context);
    } else {
      return "OPEN".tr(context);
    }
  }

  static Future<void> openWhatsappSupport(
      {String message = "Hello $kAppName",
      required BuildContext context}) async {
    try {
      final Uri url =
          Uri.parse('whatsapp://send?phone=$kWhatsAppContact&text=$message');
      // Uri.parse('$kWhatsAppLink?phone=$kWhatsAppContact&text=$message');
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        if (!context.mounted) {
          return;
        }
        Utils.showMessageDialog(
          context,
          "NO_WHATSAPP_APP_DETECTED".tr(context),
        );
      }
    } catch (_) {}
  }

  static shareOpenMatch(BuildContext context, ServiceDetail service) {
    final level = service.openMatchLevelRange;
    final date = service.formattedDateStartEndTimeForShare;
    final playerNames = service.players?.map((e) {
      return (e.reserved ?? false)
          ? "Reserved"
          : ("${e.getCustomerName} (${e.customer?.level("padel")})");
    }).toList();
    final missingPlayers = 4 - (playerNames?.length ?? 0);
    final court = service.courtName;
    final link = DynamicLinkHandler.instance.getMatchURL(service.id!);
    final location = service.service?.location?.locationName ?? "";
    final playerNamesStr = "- ${playerNames?.join("\n- ") ?? ""}";

    String shareStr = """
*OPEN MATCH $level*
📅 $date
📍$location
- Missing $missingPlayers players
- $court
              
$playerNamesStr
              
Click to join 👇🏼
$link
""";
    Utils.openWhatsapp(message: shareStr, context: context);
  }

  static void shareEventLessonUrl(
      {required BuildContext context,
      required ServiceDetail service,
      required bool isLesson}) {
    String level = (isLesson
            ? service.service?.lesson?.levelRestriction
            : service.service?.event?.levelRestriction) ??
        "";
    if (level.isNotEmpty) {
      level = "($level)";
    }
    // Fixed partner or Single signup
    String title =
        "${(service.service?.isDoubleEvent ?? false) ? "Fixed Partner" : "Single Signup"} ${((isLesson ? service.service?.lesson?.lessonName : service.service?.event?.eventName) ?? "").trim()}${level.trim().isEmpty ? "" : " $level"}";
    // Fri 10 Jan, 07:00 (2 hr)
    String date = service.formattedDateStartEndTimeForShare;
    String location = service.service?.location?.locationName ?? "";
    final maxSLots = service.getMaximumCapacity;
    String info = service.service?.additionalService ?? "";
    if (info.isNotEmpty) {
      info = "•⁠  ⁠Info:\n$info\n";
    }
    int availableSlots;
    int currentParticipants;
    String playerNamesString;
    if (service.service?.isDoubleEvent ?? false) {
      final totalTeams = maxSLots ~/ 2;
      final playersL = service.players ?? [];
      int playersCount = math.min(maxSLots, playersL.length);
      List<BookingPlayerBase?> players = List.generate(
        maxSLots,
        (_) => null,
      );

      for (int i = 0; i < playersCount; i++) {
        final player = playersL[i];
        int? pos = player.position; // Get the player's position
        int posIndex = (pos ?? (i + 1)) - 1; // Calculate index
        if (posIndex < players.length) {
          players[posIndex] = player; // Assign player to their position
        }
      }

      List<String> playerNames = players.map((e) {
        if (e == null) {
          return "Available Slot";
        } else {
          return (e.reserved ?? false)
              ? "Reserved"
              : "${e.getCustomerName} (${e.customer?.level("padel")})";
        }
      }).toList();

      currentParticipants =
          playerNames.where((name) => name != "Available Slot").length;
      availableSlots = maxSLots - currentParticipants;

      List<String> playerNames2 = [];
      for (int i = 0; i < playerNames.length; i += 2) {
        if (i + 1 < playerNames.length) {
          playerNames2.add("${playerNames[i]} + ${playerNames[i + 1]}");
        } else {
          playerNames2.add("${playerNames[i]} + Available Slot");
        }
      }

      if (playerNames2.length < totalTeams) {
        playerNames2.addAll(List.generate(totalTeams - playerNames2.length,
            (index) => "Available Slot + Available Slot"));
      }

      playerNames2.asMap().forEach((index, element) {
        playerNames2[index] = "${index + 1}. $element";
      });

      playerNamesString = playerNames2.map((line) => line.trim()).join("\n");
    } else {
      final playerNames = service.players?.map((e) {
            return (e.reserved ?? false)
                ? "Reserved"
                : ("${e.getCustomerName} (${e.customer?.level("padel")})");
          }).toList() ??
          [];
      currentParticipants = playerNames.length;
      availableSlots = maxSLots - currentParticipants;

      if (playerNames.length < maxSLots) {
        playerNames.addAll(List.generate(
            maxSLots - playerNames.length, (index) => "Available"));
      }
      // add counting to player names
      playerNames.asMap().forEach((index, element) {
        playerNames[index] = "${index + 1}. $element";
      });
      playerNamesString = playerNames.join("\n");
    }
    final link = isLesson
        ? DynamicLinkHandler.instance.getLessonUrl(service.id!)
        : DynamicLinkHandler.instance.getEventURL(service.id!);
    final text =
        """*${title.toUpperCase()}*\n📅 $date\n📍 $location\n• ${availableSlots > 0 ? availableSlots : 0} Spots Available\n• $currentParticipants Current Participants
  $info\n$playerNamesString\n\nClick to Join 👇🏼\n$link""";

    Utils.openWhatsapp(context: context, message: text);
  }

  static shareBookingWhatsapp(
      BuildContext context, ServiceDetail service, WidgetRef ref) {
    final level = service.openMatchLevelRange;
    final date = service.formattedDateStartEndTimeForShare;
    final court = service.courtName;
    final link = DynamicLinkHandler.instance.getBookingURL(service.id!);
    final location = service.service?.location?.locationName ?? "";
    String shareStr = """
*BOOKING$level*\n📅$date\n📍$location\n-Court $court\nClick to join👇🏼\n$link
""";
    Utils.openWhatsapp(context: context, message: shareStr);
  }

  static List<ClubLocationData> sortLocations(
      List<ClubLocationData> locationsData, Position? userLoc) {
    final locations = locationsData.toSet().toList();
    locations.sort((a, b) {
      final distanceA =
          a.getLocationRadius(userLoc?.latitude, userLoc?.longitude);
      final distanceB =
          b.getLocationRadius(userLoc?.latitude, userLoc?.longitude);
      return distanceA.compareTo(distanceB);
    });
    return locations;
  }

  static void closeKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  static List<ServiceDetail_Coach> fetchLocationCoaches(
      List<ClubLocationData>? location) {
    List<ServiceDetail_Coach> coaches = [];

    Set<int> seenIds = {};

    for (var service in (location ?? [])) {
      for (var coach in service.coaches ?? []) {
        if (!seenIds.contains(coach.id)) {
          seenIds.add(coach.id);
          coaches.add(coach);
        }
      }
    }

    return coaches;
  }
}
