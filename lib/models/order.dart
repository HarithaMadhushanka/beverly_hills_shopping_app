class Order {
  String productTitle;
  String productID;
  String productPrice;
  String productPicUrl;
  String orderID;
  String quantity;
  String purchaseTime;
  String purchasedBy;
  String soldBy;

  Order();

  Order.fromJson(Map<String, dynamic> json)
      : productTitle = json['productTitle'],
        productID = json['productID'],
        productPrice = json['productPrice'],
        productPicUrl = json['productPicUrl'],
        orderID = json['orderID'],
        quantity = json['quantity'],
        purchaseTime = json['purchaseTime'],
        purchasedBy = json['purchasedBy'],
        soldBy = json['soldBy'];

  Map<String, dynamic> toJson() => {
        'productTitle': productTitle,
        'productID': productID,
        'productPrice': productPrice,
        'productPicUrl': productPicUrl,
        'orderID': orderID,
        'quantity': quantity,
        'purchaseTime': purchaseTime,
        'purchasedBy': purchasedBy,
        'soldBy': soldBy,
      };
}
