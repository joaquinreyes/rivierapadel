part of 'book_court_dialog.dart';

final _isOpenMatchProvider = StateProvider<bool>((ref) => false);
final _isFriendlyMatchProvider = StateProvider<bool>((ref) => false);
final _isApprovePlayersProvider = StateProvider<bool>((ref) => false);
final _organizerNoteProvider = StateProvider<String>((ref) => '');
final _matchLevelProvider = StateProvider<List<double>>((ref) => []);
final _reserveSpotsForMatchProvider = StateProvider<int>((ref) => 0);
