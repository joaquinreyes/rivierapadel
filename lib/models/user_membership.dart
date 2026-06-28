import '../globals/constants.dart';
import 'active_memberships.dart';
import 'membership_list_category_model.dart';
import 'membership_model.dart';

class UserActiveMembership {
  List<ActiveMemberships> activeMembership = [];
  List<MembershipModel> membershipModel = [];
  List<MembershipCategory> membershipCategories = [];
  List<ShowMembershipCategory> showMembershipCategories = [];

  ActiveMemberships? activeMemberships(int id) {
    final value = activeMembership.lastWhere(
        (element) => element.membershipId == id,
        orElse: () => ActiveMemberships());
    return value.id != null ? value : null;
  }

  /// GZ#1508 — a customer can hold MORE THAN ONE active membership of the same
  /// type (e.g. a depleted pass plus a freshly topped-up one). Return every
  /// real active row for [id] so the UI can render one card per pass, instead of
  /// `activeMemberships()` collapsing them to a single `lastWhere` match (which
  /// hid the topped-up pass behind the 0-hour one).
  List<ActiveMemberships> activeMembershipsFor(int id) {
    return activeMembership
        .where((element) => element.membershipId == id && element.id != null)
        .toList();
  }

  Map<String, List<MembershipModel>> getMembershipDetails(
      List<int> selectedMembershipCategory, bool showAllMembership) {
    final Map<String, List<MembershipModel>> membershipDetails = {};
    for (int id in selectedMembershipCategory) {
      List<MembershipModel> memberships = membershipModel
          .where((element) => element.membershipCategoryId == id)
          .toList();
      final categoryName = membershipCategories
              .firstWhere((category) => category.id == id,
                  orElse: () => MembershipCategory())
              .categoryName ??
          "Unknown";

      if (!showAllMembership) {
        memberships = memberships
            .where((element) =>
                activeMemberships(element.id ?? 0) != null ||
                (element.appAvailable ?? false))
            .toList();
      }

      membershipDetails[categoryName] = memberships;
    }
    return membershipDetails;
  }

  UserActiveMembership(
      {required this.activeMembership,
      required this.membershipModel,
      required this.membershipCategories}) {
    this.activeMembership = [...activeMembership];
    this.membershipModel = [...membershipModel];
    this.membershipCategories = [...membershipCategories];
    _prepareShowMembershipCategories();
  }

  void _prepareShowMembershipCategories() {
    try {
      final Map<String, ShowMembershipCategory> categoryMap = {};

      for (var category in membershipCategories) {
        final categoryName = (category.categoryName ?? "").toLowerCase();
        if (categoryName.isNotEmpty) {
          if (!categoryMap.containsKey(categoryName)) {
            categoryMap[categoryName] =
                ShowMembershipCategory(categoryName: categoryName);
          }
          categoryMap[categoryName]!.id.add(category.id ?? 0);
        }
      }
      showMembershipCategories = categoryMap.values.toList();
    } catch (e) {
      myPrint("-------- Error in Membership $e");
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['activeMembership'] = activeMembership.map((v) => v.toJson()).toList();
    data['membershipModel'] = membershipModel.map((v) => v.toJson()).toList();
    data['membershipCategories'] =
        membershipCategories.map((v) => v.toJson()).toList();
    return data;
  }
}
