class TransactionModel {
  int? id;
  String? date;
  String? status;
  String? currency;
  String? paymentMethod;
  double? amount;
  int? customerId;
  int? serviceBookingId;

  TransactionModel(
      {this.id,
      this.date,
      this.status,
      this.currency,
      this.paymentMethod,
      this.amount,
      this.customerId,
      this.serviceBookingId});

  TransactionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    status = json['status'];
    currency = json['currency'];
    paymentMethod = json['payment_method'];
    amount = double.tryParse(json['amount'].toString());
    customerId = json['customer_id'];
    serviceBookingId = json['service_booking_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['date'] = date;
    data['status'] = status;
    data['currency'] = currency;
    data['payment_method'] = paymentMethod;
    data['amount'] = amount;
    data['customer_id'] = customerId;
    data['service_booking_id'] = serviceBookingId;
    return data;
  }
}
