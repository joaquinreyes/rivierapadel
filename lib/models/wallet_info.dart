//  {
//       "id": 299,
//       "customer_id": 11611,
//       "currency": "IDR",
//       "balance": 0
//     }

class WalletInfo {
  WalletInfo({
    required this.id,
    required this.customerId,
    required this.currency,
    required this.balance,
  });

  int id;
  int customerId;
  String currency;
  double balance;

  factory WalletInfo.fromJson(Map<String, dynamic> json) => WalletInfo(
        id: json["id"],
        customerId: json["customer_id"],
        currency: json["currency"],
        balance: json["balance"]?.toDouble() ?? 0.0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "customer_id": customerId,
        "currency": currency,
        "balance": balance,
      };
}
