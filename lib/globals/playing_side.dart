import 'package:acepadel/utils/custom_extensions.dart';

enum PlayingSide {
  right,
  left,
  both;

  String get userFacingString => this == PlayingSide.both
      ? "${name.capitalizeFirst} Sides"
      : "${name.capitalizeFirst} Side";

  String get string => name;

  String get getApiString => name.capitalizeFirst;
  static PlayingSide fromString(String name) {
    switch (name.toLowerCase()) {
      case "right":
        return PlayingSide.right;
      case "left":
        return PlayingSide.left;
      case "both":
        return PlayingSide.both;
      default:
        return PlayingSide.right;
    }
  }
}
