class Product {
  String productTitle;
  String productID;
  String productPrice;
  String addedBy;
  String productCategory;
  String addedTime;
  String productDesc;
  String productPicUrl;

  Product();

  Product.fromJson(Map<String, dynamic> json)
      : productTitle = json['productTitle'],
        productID = json['productID'],
        productPrice = json['productPrice'],
        addedBy = json['addedBy'],
        productCategory = json['productCategory'],
        addedTime = json['addedTime'],
        productDesc = json['productDesc'],
        productPicUrl = json['productPicUrl'];

  Map<String, dynamic> toJson() => {
        'productTitle': productTitle,
        'productID': productID,
        'productPrice': productPrice,
        'addedBy': addedBy,
        'productCategory': productCategory,
        'addedTime': addedTime,
        'productDesc': productDesc,
        'productPicUrl': productPicUrl,
      };
}
