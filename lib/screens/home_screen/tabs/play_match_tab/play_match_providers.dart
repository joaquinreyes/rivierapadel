part of 'play_match_tab.dart';

final kAllLocation = ClubLocationData(id: -1, locationName: 'All Locations');
final kAllCoaches = ServiceDetail_Coach(id: -1, fullName: 'All Coaches');
final _pageController = StateProvider((ref) => PageController());
final _selectedTabIndex = StateProvider<int>((ref) => 0);
final _dateRangeProvider = StateProvider<PickerDateRange>(
  (ref) => PickerDateRange(
    DateTime.now(),
    DateTime.now().add(const Duration(days: 7)),
  ),
);

final _selectedLocationProvider =
    StateProvider<ClubLocationData>((ref) => kAllLocation);
final _selectedCoachesProvider =
    StateProvider<ServiceDetail_Coach>((ref) => kAllCoaches);
final _selectedLevelProvider = StateProvider<List<double>>((ref) {
  final userLevel =
      ref.watch(userProvider)?.user?.level(getSportsName(ref)) ?? 0;
  if (userLevel == 0) {
    return const [0, 0];
  } else {
    if (userLevel >= 1.5 && userLevel <= (7.0 - 1.0)) {
      return [userLevel - 1.5, userLevel + 1.0];
    } else if (userLevel >= 1.5 && userLevel > (7.0 - 1.0)) {
      return [userLevel - 1.5, 7.0];
    } else if (userLevel < 1.5 && userLevel <= (7.0 - 1.0)) {
      return [0, userLevel + 1.0];
    } else {
      return const [0, 0];
    }
  }
});

String getSportsName(var ref) {
  return "Padel";
  // return ref.read(selectedSportProvider.notifier).name;
}
