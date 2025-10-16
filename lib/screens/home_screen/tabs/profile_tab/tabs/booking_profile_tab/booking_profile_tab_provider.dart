part of 'booking_profile_tab.dart';

final _bookingPageController = StateProvider((ref) => PageController());
final _selectedTabIndex = StateProvider<int>((ref) => 0);

List<Widget> _pages = [
  const UserBookingsList(),
  const UserBookingsList(isPast: true),
];
