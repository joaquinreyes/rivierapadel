part of 'booking_tab.dart';

final _dateBookableLesson = StateProvider<bool>((ref) => true);
final _selectedDuration = StateProvider<int?>((ref) => null);
final _selectedLessonCoachId = StateProvider<List<int>>((ref) => []);
final _selectedTabIndex = StateProvider<int>((ref) => 0);
final _pageControllerFor = StateProvider((ref) => PageController());
final _lessonVariantList = StateProvider< List<LessonVariants>>((ref) => []);
final _selectedCoachLessonDuration = StateProvider<LessonVariants?>((ref) => null);




final _dateLessonsRangeProvider = StateProvider<PickerDateRange>(
  (ref) => PickerDateRange(
    DateTime.now(),
    DateTime.now().add(const Duration(days: 7)),
  ),
);
final _selectedTimeSlotAndLocationID =
    StateProvider<(DateTime?, int?)>((ref) => (null, null));

final _pageViewController = StateProvider<PageController>((ref) {
  return PageController();
});

final _selectedLessonsLocationProvider =
    StateProvider<ClubLocationData>((ref) => kLessonsAllLocation);

final kLessonsAllLocation =
    ClubLocationData(id: -1, locationName: 'All Locations');

final kLessonsAllCoaches =
    ClubLocationData(id: -1, locationName: 'All Coaches');
