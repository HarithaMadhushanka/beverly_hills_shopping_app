class Outlet {
  String profilePicUrl;
  String outletName;
  String outletID;
  String email;
  String mobileNo;
  String category;
  String outletDesc;
  String addressLine1;
  String addressLine2;
  String addressLine3;

  Outlet();

  Outlet.fromJson(Map<String, dynamic> json)
      : profilePicUrl = json['profilePicUrl'],
        outletName = json['outletName'],
        outletID = json['outletID'],
        email = json['email'],
        mobileNo = json['mobileNo'],
        category = json['category'],
        outletDesc = json['outletDesc'],
        addressLine1 = json['addressLine1'],
        addressLine2 = json['addressLine2'],
        addressLine3 = json['addressLine3'];

  Map<String, dynamic> toJson() => {
        'profilePicUrl': profilePicUrl,
        'outletName': outletName,
        'outletID': outletID,
        'email': email,
        'mobileNo': mobileNo,
        'category': category,
        'outletDesc': outletDesc,
        'addressLine1': addressLine1,
        'addressLine2': addressLine2,
        'addressLine3': addressLine3,
      };
}
