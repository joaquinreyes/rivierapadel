typedef UpgradeToOpenMatchResult = (int? serviceId, double? amountDue);

UpgradeToOpenMatchResult parseUpgradeToOpenMatchResponse(dynamic response) {
  final Map body = response is Map ? response : const {};
  final data = body['data'];
  final message = body['message']?.toString() ?? '';

  // Pay-extra branch: `data` is the remaining amount, never a booking object.
  if (data is num || message.contains('process for payments')) {
    final amount = double.tryParse(data?.toString() ?? '');
    if (amount != null) return (null, amount);
  }
  // Converted branch: `data` is the updated service booking.
  if (data is Map) {
    final serviceId = int.tryParse(data['service_id']?.toString() ?? '');
    if (serviceId != null) return (serviceId, null);
  }
  return (null, null);
}
