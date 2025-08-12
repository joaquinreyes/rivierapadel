import 'package:acepadel/screens/app_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:acepadel/globals/api_endpoints.dart';
import 'package:acepadel/managers/api_manager.dart';
import 'package:acepadel/models/calculated_level_data.dart';
import 'package:acepadel/models/level_questions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../screens/home_screen/tabs/play_match_tab/play_match_tab.dart';

part 'level_repo.g.dart';

class LevelRepo {
  Future<List<LevelQuestion>> getQuestions(Ref ref) async {
    try {
      final response = await ref.read(apiManagerProvider).get(
            ref,
            ApiEndPoint.getQuestions,
          );
      final List<LevelQuestion> questions = [];
      for (final item in response['data']["questions"]) {
        questions.add(LevelQuestion.fromJson(item));
      }
      return questions;
    } catch (e) {
      if (e is Map<String, dynamic>) {
        throw e['message'];
      }
      rethrow;
    }
  }

  Future<CalculatedLevelData> calculateLevel(
      Ref ref, List<double?> answers) async {
    try {
      final response = await ref.read(apiManagerProvider).post(
        ref,
        ApiEndPoint.calculateLevel,
        {
          "answers": answers,
          "scale": 7,
          "sport_name": getSportsName(ref),
        },
      );
      final calculatedLevelData =
          CalculatedLevelData.fromJson(response['data']);
      return calculatedLevelData;
    } catch (e) {
      if (e is Map<String, dynamic>) {
        throw e['message'];
      }
      rethrow;
    }
  }
}

@riverpod
LevelRepo levelRepo(Ref ref) => LevelRepo();

@riverpod
Future<List<LevelQuestion>> levelQuestions(LevelQuestionsRef ref) async {
  return await ref.read(levelRepoProvider).getQuestions(ref);
}

@riverpod
Future<CalculatedLevelData> calculateLevel(
    CalculateLevelRef ref, List<double?> answers) async {
  return await ref.read(levelRepoProvider).calculateLevel(ref, answers);
}
