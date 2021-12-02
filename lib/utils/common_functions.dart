import 'dart:convert';
import 'dart:io';

import 'package:beverly_hills_shopping_app/database/db_helper.dart';
import 'package:beverly_hills_shopping_app/models/customer.dart';
import 'package:beverly_hills_shopping_app/models/outlet.dart';
import 'package:beverly_hills_shopping_app/models/report.dart';
import 'package:beverly_hills_shopping_app/utils/enums.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

void showToast(BuildContext context, String msg, {Duration duration}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: duration != null ? duration : Duration(seconds: 2),
      backgroundColor: PrimaryColorLight,
      content: Text(
        msg,
        style: TextStyle(color: PrimaryColorDark),
      ),
    ),
  );
}

Future<void> saveUpdatedUserDetailsLocally({@required String userType}) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  Customer customerObj = Customer();
  Outlet outletObj = Outlet();

  await userType == "customer"
      ? customerCollectionReference.get().then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            if (loggedInUserID == (doc.data() as dynamic)["userID"]) {
              customerObj.profilePicUrl = doc["profilePicUrl"];
              customerObj.firstName = doc["firstName"];
              customerObj.lastName = doc["lastName"];
              customerObj.mobileNo = doc["mobileNo"];
              customerObj.email = doc["email"];
              customerObj.addressLine1 = doc["addressLine1"];
              customerObj.addressLine2 = doc["addressLine2"];
              customerObj.addressLine3 = doc["addressLine3"];

              sharedPreferences.setString(
                  'customerObj', jsonEncode(customerObj));
            }
          });
        })
      : outletCollectionReference.get().then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            if (loggedInUserID == (doc.data() as dynamic)['userID']) {
              outletObj.profilePicUrl = doc["profilePicUrl"];
              outletObj.outletName = doc["outletName"];
              outletObj.mobileNo = doc["mobileNo"];
              outletObj.category = doc["category"];
              outletObj.outletDesc = doc["outletDesc"];
              outletObj.category = doc["category"];
              outletObj.email = doc["email"];
              outletObj.addressLine1 = doc["addressLine1"];
              outletObj.addressLine2 = doc["addressLine2"];
              outletObj.addressLine3 = doc["addressLine3"];

              sharedPreferences.setString('outletObj', jsonEncode(outletObj));
            }
          });
        });
}

Future<dynamic> getUserDetails({@required bool isCustomer}) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String customerObj = sharedPreferences.get('customerObj');
  String outletObj = sharedPreferences.get('outletObj');

  Customer customer = Customer();
  customer = Customer.fromJson(jsonDecode(customerObj));

  Outlet outlet = Outlet();
  outlet = Outlet.fromJson(jsonDecode(outletObj));

  return isCustomer ? customer : outlet;
}

Future<File> pickImage(
    {@required ImagePicker picker, @required File imageFile}) async {
  /// Picks a Profile pic from gallery
  try {
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    imageFile = File(pickedFile.path);
  } catch (e) {
    print(e.toString());
  }
  return imageFile;
}

Future<File> cropImage({@required File imageFile}) async {
  try {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: imageFile.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Crop your image',
            toolbarColor: PrimaryColorDark,
            toolbarWidgetColor: SecondaryColorLight,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Crop your image',
        ));
    if (croppedFile != null) {
      imageFile = croppedFile;
    }
  } catch (e) {
    print(e.toString());
  }

  return imageFile;
}

Future<String> selectDate(BuildContext context, String dateType) async {
  String date = "";

  final DateTime picked = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime.now(),
    lastDate: DateTime(2023),
  );
  if (picked != null) date = picked.toLocal().toString().split(' ')[0];

  return date;
}

Future getOutletData() async {
  DBHelper _dbHelper = DBHelper();

  navigationStartList = await _dbHelper.getOutletsWithRoutes();
  navigationEndList = await _dbHelper.getOutletsWithRoutes();
}

String truncateWithEllipsis(int cutoff, String myString) {
  return (myString.length <= cutoff)
      ? myString
      : '${myString.substring(0, cutoff)}...';
}

String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

List<String> getWeek() {
  final date = DateTime.now();

  print('Date: $date');
  final weekDay = date.weekday == 7 ? 0 : date.weekday;

  return [
    getDate(
      date.subtract(
        Duration(days: weekDay - 1),
      ),
    ).toString().split(' ')[0],
    getDate(date.add(Duration(days: DateTime.daysPerWeek - weekDay)))
        .toString()
        .split(' ')[0]
  ];
}

DateTime getDate(DateTime d) => DateTime(d.year, d.month, d.day);

String getDay() {
  DateTime date = DateTime.now();
  String day = DateFormat('EEEE').format(date);

  return day;
}

String getCurrentHourIn24() {
  final now = new DateTime.now();
  String formatter = DateFormat('H').format(now);
  print(formatter.toString());

  return formatter.toString();
}

Future<List> getHighestCountItem(Report report, {String type}) async {
  int theValue = 0;
  String theKey = "";

  if (type == "product") {
    report.products.forEach((k, v) {
      if (v > theValue) {
        theValue = v;
        theKey = k;
      }
    });
  }
  if (type == "order") {
    report.orders.forEach((k, v) {
      if (v > theValue) {
        theValue = v;
        theKey = k;
      }
    });
  }
  if (type == "outlet") {
    report.outlets.forEach((k, v) {
      if (v > theValue) {
        theValue = v;
        theKey = k;
      }
    });
  }
  if (type == "category") {
    report.categories.forEach((k, v) {
      if (v > theValue) {
        theValue = v;
        theKey = k;
      }
    });
  }

  // print(theKey);

  return [theKey, theValue];
}
