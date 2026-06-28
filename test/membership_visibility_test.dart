import 'package:flutter_test/flutter_test.dart';
import 'package:acepadel/models/active_memberships.dart';
import 'package:acepadel/models/user_membership.dart';

/// GZ#1508 — a customer who holds TWO active memberships of the same type
/// (same membership_id 421) — one freshly topped up with hours, one already at
/// 0 hours — saw only ONE of them in the app, and it was the depleted pass. The
/// freshly topped-up pass was invisible even though the backend returned BOTH
/// rows in `activeMembership`.
///
/// Root cause: `UserActiveMembership.activeMemberships(id)` used `lastWhere`,
/// collapsing every active row sharing a membership_id down to a single one —
/// the LAST in the list, which happened to be the depleted (0h) pass. The
/// membership tab iterated the catalog and looked up exactly one active row per
/// membership_id, so the second pass could never render.
///
/// Fix: expose ALL active rows for a membership_id so the tab renders one card
/// per active membership.
void main() {
  // The 8h-remaining pass (id 15645) first, the depleted 0h pass (id 12615)
  // last — exactly the order that made `lastWhere` pick the wrong one.
  UserActiveMembership customer() => UserActiveMembership(
        membershipModel: [],
        membershipCategories: [],
        activeMembership: [
          ActiveMemberships(
            id: 15645,
            membershipId: 421,
            membershipName: 'Pass',
            usageDurationLeft: 28800, // hours remaining
            finishDate: '2026-09-03T23:59:59.999Z',
          ),
          ActiveMemberships(
            id: 12615,
            membershipId: 421,
            membershipName: 'Pass',
            usageDurationLeft: 0, // depleted
            finishDate: '2026-07-24T23:59:59.999Z',
          ),
        ],
      );

  group('GZ#1508 multiple active memberships of the same type', () {
    test('activeMembershipsFor returns EVERY active row for a membership_id',
        () {
      final visible = customer().activeMembershipsFor(421);
      expect(visible.length, 2,
          reason: 'both active Pass rows must be visible');
    });

    test('the topped-up (hours-remaining) pass is among the visible rows', () {
      final visible = customer().activeMembershipsFor(421);
      final hasHours =
          visible.any((m) => (m.usageDurationLeft ?? 0) > 0 && m.id == 15645);
      expect(hasHours, isTrue,
          reason: 'the 8h pass (id 15645) must not be hidden by the 0h pass');
    });

    test('ignores placeholder rows with a null id', () {
      final um = UserActiveMembership(
        membershipModel: [],
        membershipCategories: [],
        activeMembership: [ActiveMemberships(membershipId: 421)],
      );
      expect(um.activeMembershipsFor(421), isEmpty);
    });

    test('returns empty when the customer has no active row for that id', () {
      expect(customer().activeMembershipsFor(999), isEmpty);
    });
  });
}
