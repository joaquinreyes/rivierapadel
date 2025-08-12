class AssessmentReqModel {
  Map<String, int> positions = {};
  // assessments
  Map<String, double> assessments = {};
  // teamA
  Map<String, int> teamA = {};
  // teamB
  Map<String, int> teamB = {};

  toJson() {
    return {
      'positions': positions,
      'assessments': assessments,
      'teamA': teamA,
      'teamB': teamB,
    };
  }
}
