class CourtPriceModel {
  double? price;
  double? discountedPrice;
  double? openMatchPrice;
  double? openMatchDiscountedPrice;
  CancellationPolicyDiscountPrice? cancellationPolicy;

  CourtPriceModel(
      {this.price,
      this.discountedPrice,
      this.openMatchPrice,
      this.openMatchDiscountedPrice,
      this.cancellationPolicy});

  CourtPriceModel.fromJson(Map<String, dynamic> json) {
    price = (json['calculatedPrice']['price'] ?? 0).toDouble();
    discountedPrice =
        (json['calculatedPrice']['discountedPrice'] ?? 0).toDouble();
    openMatchPrice =
        (json['calculatedPrice']['openMatchPrice'] ?? 0).toDouble();
    openMatchDiscountedPrice = (json['calculatedPrice']
                ['openMatchDiscountedPrice'] ??
            json['calculatedPrice']['openMatchdiscountedPrice'] ??
            0)
        .toDouble();
    cancellationPolicy = json['cancellationPolicy'] != null
        ? CancellationPolicyDiscountPrice.fromJson(json['cancellationPolicy'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['price'] = price;
    data['discountedPrice'] = discountedPrice;
    data['openMatchDiscountedPrice'] = openMatchDiscountedPrice;
    data['openMatchPrice'] = openMatchPrice;
    if (cancellationPolicy != null) {
      data['cancellationPolicy'] = cancellationPolicy!.toJson();
    }
    return data;
  }
}

class CancellationPolicyDiscountPrice {
  int? cancellationTime;
  int? openMatchCancellationTime;

  CancellationPolicyDiscountPrice(
      {this.cancellationTime, this.openMatchCancellationTime});

  int? get cancellationTimeInHours {
    if (cancellationTime == null) {
      return null;
    }
    return (cancellationTime ?? 0) ~/ 3600;
  }

  int? get openMatchCancellationTimeInHours {
    if (openMatchCancellationTime == null) {
      return null;
    }
    return (openMatchCancellationTime ?? 0) ~/ 3600;
  }

  CancellationPolicyDiscountPrice.fromJson(Map<String, dynamic> json) {
    cancellationTime = json['cancellationTime'];
    openMatchCancellationTime = json['openMatchCancellationTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cancellationTime'] = cancellationTime;
    data['openMatchCancellationTime'] = openMatchCancellationTime;
    return data;
  }
}
