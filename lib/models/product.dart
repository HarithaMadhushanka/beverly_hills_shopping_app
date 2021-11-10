class Product {
  String productTitle;
  String productPrice;
  String addedBy;
  String productCategory;
  String addedTime;
  String productDesc;
  String productPicUrl;

  Product();

  Product.fromJson(Map<String, dynamic> json)
      : productTitle = json['productTitle'],
        productPrice = json['productPrice'],
        addedBy = json['addedBy'],
        productCategory = json['productCategory'],
        addedTime = json['addedTime'],
        productDesc = json['productDesc'],
        productPicUrl = json['productPicUrl'];

  Map<String, dynamic> toJson() => {
        'productTitle': productTitle,
        'productPrice': productPrice,
        'addedBy': addedBy,
        'productCategory': productCategory,
        'addedTime': addedTime,
        'productDesc': productDesc,
        'productPicUrl': productPicUrl,
      };
}
