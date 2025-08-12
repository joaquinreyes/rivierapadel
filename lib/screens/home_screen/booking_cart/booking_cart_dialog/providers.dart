part of 'booking_cart_dialog.dart';

final _isOpenMatchProvider = StateProvider<bool>((ref) => false);
final _isFriednlyMatchProvider = StateProvider<bool>((ref) => false);
final _isApprovePlayersProvider = StateProvider<bool>((ref) => false);
final _organizerNoteProvider = StateProvider<String>((ref) => '');
final _matchLevelProvider = StateProvider<List<double>>((ref) => []);
final _reserveSpotsForMatchProvider = StateProvider<int>((ref) => 0);
final totalMultiBookingAmount = StateProvider<double>((ref) => 0);
