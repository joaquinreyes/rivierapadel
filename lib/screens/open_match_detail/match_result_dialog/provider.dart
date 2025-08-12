part of 'enter_match_result.dart';

final _scoreFocusNodes = Provider<List<FocusNode>>((ref) {
  return List.generate(6, (index) => FocusNode());
});

final currentPlayerID = StateProvider<int>((ref) => -1);
final _assesmentReqModelProvider =
    StateProvider<AssessmentReqModel>((ref) => AssessmentReqModel());

final _teamAScoreProvider =
    StateProvider<List<int?>>((ref) => List.generate(3, (index) => null));
final _teamBScoreProvider =
    StateProvider<List<int?>>((ref) => List.generate(3, (index) => null));

final _isDrawProvider = StateProvider<bool>((ref) => false);

final _sortedPlayersProvider =
    StateProvider<List<ServiceDetail_Players>>((ref) => []);

final _otherPlayersProvider =
    StateProvider<List<ServiceDetail_Players>>((ref) => []);

final _otherNonReservedPlayersProvider =
    StateProvider<List<ServiceDetail_Players>>((ref) => []);

final isTeamAWinner = Provider<bool>((ref) {
  final teamAScore = ref.watch(_teamAScoreProvider);
  final teamBScore = ref.watch(_teamBScoreProvider);

  // if (teamAScore.contains(null)) {
  //   return false;
  // }
  // if (teamBScore.contains(null)) {
  //   return false;
  // }
  // return teamAScore.fold(0, (a, b) => a + (b ?? 0)) >
  //     teamBScore.fold(0, (a, b) => a + (b ?? 0));
  if (checkCanSetWinners(teamAScore, teamBScore)) {
    Map<String, bool> result = determineWinner(teamAScore, teamBScore);
    return result['isAWin']!;
  }
  return false;
});

final isTeamBWinner = Provider<bool>((ref) {
  final teamAScore = ref.watch(_teamAScoreProvider);
  final teamBScore = ref.watch(_teamBScoreProvider);
  // if (teamAScore.contains(null)) {
  //   return false;
  // }
  // if (teamBScore.contains(null)) {
  //   return false;
  // }
  // return teamBScore.fold(0, (a, b) => a + (b ?? 0)) >
  //     teamAScore.fold(0, (a, b) => a + (b ?? 0));

  if (checkCanSetWinners(teamAScore, teamBScore)) {
    Map<String, bool> result = determineWinner(teamAScore, teamBScore);
    return !result['isAWin']!;
  }
  return false;
});

final canProceed = Provider<bool>((ref) {
  final isDraw = ref.watch(_isDrawProvider);
  final teamAScore = ref.watch(_teamAScoreProvider);
  final teamBScore = ref.watch(_teamBScoreProvider);
  if (isDraw) {
    return true;
  }
  if (teamAScore.contains(null) || teamBScore.contains(null)) {
    return false;
  }
  return true;
});
