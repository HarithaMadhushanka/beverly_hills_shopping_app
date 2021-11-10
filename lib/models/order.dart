class Order {
  String productTitle;
  String productPrice;
  String purchaseTime;
  String purchasedBy;

  Order();

  Order.fromJson(Map<String, dynamic> json)
      : productTitle = json['productTitle'],
        productPrice = json['productPrice'],
        purchaseTime = json['purchaseTime'],
        purchasedBy = json['purchasedBy'];

  Map<String, dynamic> toJson() => {
        'productTitle': productTitle,
        'productPrice': productPrice,
        'purchaseTime': purchaseTime,
        'purchasedBy': purchasedBy,
      };
}
