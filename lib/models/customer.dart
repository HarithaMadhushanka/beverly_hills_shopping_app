class Customer {
  String profilePicUrl;
  String firstName;
  String lastName;
  String email;
  String mobileNo;
  String addressLine1;
  String addressLine2;
  String addressLine3;

  Customer();

  Customer.fromJson(Map<String, dynamic> json)
      : profilePicUrl = json['profilePicUrl'],
        firstName = json['firstName'],
        lastName = json['lastName'],
        email = json['email'],
        mobileNo = json['mobileNo'],
        addressLine1 = json['addressLine1'],
        addressLine2 = json['addressLine2'],
        addressLine3 = json['addressLine3'];

  Map<String, dynamic> toJson() => {
        'profilePicUrl': profilePicUrl,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'mobileNo': mobileNo,
        'addressLine1': addressLine1,
        'addressLine2': addressLine2,
        'addressLine3': addressLine3,
      };
}
