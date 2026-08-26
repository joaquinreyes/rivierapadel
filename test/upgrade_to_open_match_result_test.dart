import 'package:acepadel/globals/upgrade_to_open_match_result.dart';
import 'package:flutter_test/flutter_test.dart';

/// GZ#3021 / knowhow #402 — PATCH upgrade-to-open-match returns two shapes.
/// The old repo did `response['data']['service_id'].toDouble()` on both.
void main() {
  group('upgrade-to-open-match response shapes', () {
    test('BUG REPRO: indexing a bare int data as a map throws', () {
      final response = <String, dynamic>{
        'message': 'process for payments:',
        'data': 150000,
      };
      expect(
        () => response['data']['service_id'],
        throwsA(isA<NoSuchMethodError>()),
      );
    });

    test('pay-extra: bare number data returns (null, amountDue)', () {
      expect(
        parseUpgradeToOpenMatchResponse({
          'message': 'process for payments:',
          'data': 150000,
        }),
        (null, 150000.0),
      );
    });

    test('converted: booking map returns (serviceId, null)', () {
      expect(
        parseUpgradeToOpenMatchResponse({
          'message': 'Booking updated to Open Match,refunds processed.',
          'data': {'service_id': 809378},
        }),
        (809378, null),
      );
    });

    test('decimal amount is parsed as double', () {
      expect(
        parseUpgradeToOpenMatchResponse({
          'message': 'process for payments:',
          'data': 150000.5,
        }),
        (null, 150000.5),
      );
    });

    test('string amount is parsed as double', () {
      expect(
        parseUpgradeToOpenMatchResponse({
          'message': 'process for payments:',
          'data': '150000',
        }),
        (null, 150000.0),
      );
    });

    test('unreadable body returns (null, null)', () {
      expect(parseUpgradeToOpenMatchResponse(null), (null, null));
      expect(parseUpgradeToOpenMatchResponse('oops'), (null, null));
      expect(parseUpgradeToOpenMatchResponse({'foo': 1}), (null, null));
      expect(
        parseUpgradeToOpenMatchResponse({'data': true}),
        (null, null),
      );
    });
  });
}
