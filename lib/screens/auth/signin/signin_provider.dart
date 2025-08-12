import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'signin_provider.g.dart';

@Riverpod(keepAlive: false)
Future<bool> test(Ref ref) {
  return Future.delayed(Duration(seconds: 2), () => true);
}

@Riverpod(keepAlive: false)
Future<String> test2(Ref ref) {
  return Future.delayed(Duration(seconds: 2), () => throw Exception('Error'));
}
