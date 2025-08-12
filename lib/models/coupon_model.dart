class CouponModel {
  double? discount;
  int? couponId;
  String? coupon;

  CouponModel({
    this.discount,
    this.couponId,
    this.coupon = "",
  });

  CouponModel.fromJson(Map<String, dynamic> json) {
    discount = json['discount']?.toDouble();
    couponId = json['couponId'];
    coupon = "";
  }
}
