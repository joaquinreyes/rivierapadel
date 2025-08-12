enum ApiEndPoint {
  login("users/login", isAuthRequired: false),
  register("users/register", isAuthRequired: false, successCode: 201),
  locations("locations", isAuthRequired: false),
  courtBooking("court-bookings", isAuthRequired: false),
  getVouchers("vouchers", isAuthRequired: true),
  deleteCartBooking("court-bookings/cart", isAuthRequired: true),
  courtBookingPost("court-bookings", isAuthRequired: true, successCode: 200),
  courtPricePost("court-bookings/discount-price",
      isAuthRequired: true, successCode: 201),
  coachesOff("court-bookings/coaches-off", isAuthRequired: true),
  userProfileUpdate("users/profiles/upload", isAuthRequired: true),
  userBookings("users/bookings", isAuthRequired: true),
  userBookingsWaitingList("users/bookings/waiting-list", isAuthRequired: true),
  userBookingCartList("court-bookings/cart-details", isAuthRequired: true),
  usersMe("users/me", isAuthRequired: true),
  usersPost("users", isAuthRequired: true),
  customFields("users/custom-fields", isAuthRequired: true),
  paymentDetails("payments/details", isAuthRequired: true),
  paymentsProcess("payments/process", isAuthRequired: true),
  multiBookingPaymentsProcess("payments/process/cart", isAuthRequired: true),
  purchaseVoucherProcess("vouchers/location/purchase", isAuthRequired: true),
  openMatches("services/open-matches", isAuthRequired: true),
  coachList("court-bookings/club-coaches", isAuthRequired: true),
  events("services/events", isAuthRequired: true),
  lessons("services/lessons", isAuthRequired: true),
  services("services", isAuthRequired: true),
  joinService("services/join", isAuthRequired: true),
  serviceCancel("services/cancel", isAuthRequired: true),
  serviceWaitingList("services/waiting-list"),
  serviceApprovePlayer("services/request"),
  serviceDeleteReservedPlayer("services/reserved/delete"),
  getQuestions("get-questions", isAuthRequired: false, isWithoutClub: true),
  calculateLevel("calculate-level", isAuthRequired: false, isWithoutClub: true),
  transaction("transaction", isAuthRequired: true, isWithoutClub: true),
  couponsVerify("payments/coupons/verify", isAuthRequired: true),
  updatePassword("users/update-password", isAuthRequired: true),
  deleteAccount("users/delete-account", isAuthRequired: true),
  appUpdates("app-updates", isAuthRequired: false),
  usersTotalHours("users/booking/total-hours", isAuthRequired: true),
  usersActiveMembership("users/active-membership", isAuthRequired: true),
  usersWallets("users/wallets", isAuthRequired: true),
  transactions("users/transactions", isAuthRequired: true),
  serviceSubmitAssessment("services/submit-assessment"),
  usersAssessments("users/assessments", isAuthRequired: true),
  serviceAssessment("services/assessment"),
  fcmToken("users/user-fcmtoken", successCode: 201),
  cancellationPolicy("services/cancellation-policy", isAuthRequired: true),

  bookingLessons("court-bookings/lessons", isAuthRequired: true),
  upgradeBookingToOpen("services/upgrade-to-open-match",
      isAuthRequired: true, successCode: 200),
  joinEventWaitingList("services/events/waiting-list",
      isAuthRequired: true, successCode: 201),
  userRecoverPassword("users/recover-password", isAuthRequired: false),
  userUpdateRecoverPassword("users/update-recover-password",
      isAuthRequired: false),
  openMatchCalculatePriceApi("services/open-match-calculate-price",
      isAuthRequired: true),

  fetchChatCount("chat-contacts", isAuthRequired: true, isWebSocketUrl: true);

  final String _path;
  final int successCode;
  final bool isAuthRequired;
  final bool isWithoutClub;
  final bool isWebSocketUrl;

  const ApiEndPoint(
    String path, {
    this.successCode = 200,
    this.isAuthRequired = true,
    this.isWithoutClub = false,
    this.isWebSocketUrl = false,
  }) : _path = path;

  String path({List<String> id = const [""]}) {
    if (this == ApiEndPoint.paymentDetails) {
      return "payments/${id.first}/details";
    }
    if (this == ApiEndPoint.cancellationPolicy) {
      return "services/${id.first}/cancellation-policy";
    }
    if (this == ApiEndPoint.deleteCartBooking) {
      return "court-bookings/cart/${id.first}";
    }
    if (this == ApiEndPoint.services) {
      return "services/${id.first}";
    }
    if (this == ApiEndPoint.openMatchCalculatePriceApi) {
      return "services/${id.first}/open-match-calculate-price";
    }
    if (this == ApiEndPoint.joinService) {
      return "services/join/${id.first}";
    }
    if (this == ApiEndPoint.serviceCancel) {
      return "services/cancel/${id.first}";
    }
    if (this == ApiEndPoint.joinEventWaitingList) {
      return "services/${id.first}/events/waiting-list";
    }
    if (this == ApiEndPoint.purchaseVoucherProcess) {
      return "vouchers/${id.first}/location/${id.last}/purchase";
    }
    if (this == ApiEndPoint.serviceWaitingList) {
      return "services/waiting-list/${id.first}";
    }
    if (this == ApiEndPoint.fetchChatCount) {
      return "chat-contacts/${id.first}";
    }
    if (this == ApiEndPoint.serviceApprovePlayer) {
      return "services/request/${id.first}/${id[1]}/${id.last}";
    }
    if (this == ApiEndPoint.serviceDeleteReservedPlayer) {
      return "services/${id.first}/reserved/${id[1]}/delete";
    }
    if (this == ApiEndPoint.upgradeBookingToOpen) {
      return "services/${id.first}/upgrade-to-open-match";
    }
    if (this == ApiEndPoint.serviceSubmitAssessment) {
      return "services/submit-assessment/${id.first}";
    }
    if (this == ApiEndPoint.serviceAssessment) {
      return "services/assessment/${id.first}";
    }
    if (this == ApiEndPoint.usersAssessments) {
      return "users/${id.first}/assessments";
    }
    return _path;
  }
}
