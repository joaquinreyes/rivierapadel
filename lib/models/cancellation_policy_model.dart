class CancellationPolicy {
  int? cancellationHours;
  double? refund;
  int? refundHours;
  double? percentage;

  CancellationPolicy(
      {this.cancellationHours, this.refund, this.refundHours, this.percentage});

  CancellationPolicy.fromJson(Map<String, dynamic> json) {
    cancellationHours = json['cancellation_hours'];
    refund = double.tryParse(json['refund'].toString());
    refundHours = json['refund_hours'];
    percentage = double.tryParse(json['percentage'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cancellation_hours'] = cancellationHours;
    data['refund'] = refund;
    data['refund_hours'] = refundHours;
    data['percentage'] = percentage;
    return data;
  }
}
