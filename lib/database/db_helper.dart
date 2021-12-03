import 'dart:async';
import 'dart:io';

import 'package:beverly_hills_shopping_app/models/customer.dart';
import 'package:beverly_hills_shopping_app/models/feedback.dart' as fdb;
import 'package:beverly_hills_shopping_app/models/order.dart';
import 'package:beverly_hills_shopping_app/models/outlet.dart';
import 'package:beverly_hills_shopping_app/models/product.dart';
import 'package:beverly_hills_shopping_app/models/promotion.dart';
import 'package:beverly_hills_shopping_app/models/report.dart';
import 'package:beverly_hills_shopping_app/utils/common_functions.dart'
    as common;
import 'package:beverly_hills_shopping_app/utils/enums.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DBHelper {
  FirebaseAuth _auth = FirebaseAuth.instance;

  /// Registers the User (Firebase Auth)
  Future<UserCredential> registerUser(
      String email, String password, BuildContext context) async {
    UserCredential userCredential;

    userCredential = await _auth
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        .catchError((error) {
      common.showToast(context, error.message.toString());
    });
    return userCredential;
  }

  /// Logs in the User (Firebase Auth)
  Future<UserCredential> loginUser(
      String email, String password, BuildContext context) async {
    UserCredential userCredential;
    userCredential = await _auth
        .signInWithEmailAndPassword(
      email: email,
      password: password,
    )
        .catchError((error) {
      common.showToast(context, error.message.toString());
    });

    return userCredential;
  }

  /// Gets Admin Username and Password
  Future getAdminCredentials() async {
    String adminEmail;
    String adminPassword;
    List<String> adminCredentials = [];

    await FirebaseFirestore.instance
        .collection('admin')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        adminEmail = doc["username"];
        adminPassword = doc["password"];

        adminCredentials.add(adminEmail);
        adminCredentials.add(adminPassword);
      });
    });

    return adminCredentials;
  }

  /// Logs in the Admin
  Future<UserCredential> loginAdmin() async {
    UserCredential userCredential =
        await FirebaseAuth.instance.signInAnonymously();

    print("Admin Logged In");
    return userCredential;
  }

  /// Logs out the users
  Future<void> commonUserSignOut() async {
    await FirebaseAuth.instance.signOut();
    print("User Signed Out!");
  }

  /// Saves User's entry details in Firestore
  Future saveUserInfoToFireStore(
      User firebaseUser, String collectionName) async {
    collectionName == "customers"
        ? customerCollectionReference.doc(firebaseUser.uid).set({
            "userID": firebaseUser.uid,
            "email": firebaseUser.email,
            "isRegCompleted": false,
          })
        : outletCollectionReference.doc(firebaseUser.uid).set({
            "userID": firebaseUser.uid,
            "email": firebaseUser.email,
            "isRegCompleted": false,
            "isRouteAdded": false,
          });
  }

  /// Uploads User's Profile pic (Firebase Storage)
  Future uploadUserProfilePic(
      String _userID, File _imageFile, String userType) async {
    try {
      Reference storageReference = FirebaseStorage.instance.ref().child(
          userType == "customer"
              ? 'customerProPics/$_userID'
              : 'outletProPics/$_userID');
      UploadTask uploadTask = storageReference.putFile(_imageFile);
      await uploadTask;
      storageReference.getDownloadURL().then((fileURL) {
        updateUserProfilePicURL(_userID, fileURL, userType);
      });
    } catch (e) {
      print(e);
    }
  }

  /// Updates Firestore collection with Profile pic URL
  Future<void> updateUserProfilePicURL(
      String _userID, String _customerProPicUrl, String userType) {
    return userType == "customer"
        ? customerCollectionReference
            .doc(_userID)
            .update({"profilePicUrl": _customerProPicUrl})
            .then((value) => print("Customer Profile Picture Updated"))
            .catchError((error) => print("Failed to update user: $error"))
        : outletCollectionReference
            .doc(_userID)
            .update({"profilePicUrl": _customerProPicUrl})
            .then((value) => print("Outlet Profile Picture Updated"))
            .catchError((error) => print("Failed to update user: $error"));
  }

  /// Updates all the User details in Firestore
  Future<void> updateUserDetails(String _userID, userType,
      {Customer customer, Outlet outlet}) {
    return userType == "customer"
        ? customerCollectionReference
            .doc(_userID)
            .update({
              "firstName": customer.firstName,
              "lastName": customer.lastName,
              "mobileNo": customer.mobileNo,
              "addressLine1": customer.addressLine1,
              "addressLine2": customer.addressLine2,
              "addressLine3": customer.addressLine3,
              "isRegCompleted": true,
            })
            .then((value) => print("Customer Details Updated"))
            .catchError((error) => print("Failed to update user: $error"))
            .then((value) =>
                common.saveUpdatedUserDetailsLocally(userType: "customer"))
        : outletCollectionReference
            .doc(_userID)
            .update({
              "outletName": outlet.outletName,
              "mobileNo": outlet.mobileNo,
              "category": outlet.category,
              "outletDesc": outlet.outletDesc,
              "addressLine1": outlet.addressLine1,
              "addressLine2": outlet.addressLine2,
              "addressLine3": outlet.addressLine3,
              "isRegCompleted": true,
            })
            .then((value) => print("Outlet Details Updated"))
            .catchError((error) => print("Failed to update user: $error"))
            .then((value) =>
                common.saveUpdatedUserDetailsLocally(userType: "outlet"));
  }

  /// Gets User's registration state
  Future<bool> getUserRegState(String userID, String userType) async {
    bool isRegCompleted;
    DocumentSnapshot snapshot = userType == "customer"
        ? await customerCollectionReference.doc(userID).get()
        : await outletCollectionReference.doc(userID).get();
    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      isRegCompleted = data['isRegCompleted'];
    }
    return isRegCompleted;
  }

  /// Uploads Pictures (Firebase Storage) - COMMON DB Call
  Future<String> uploadPic(File _imageFile, String type,
      {String outletID, String imgName}) async {
    final promoRef = FirebaseFirestore.instance.collection('promotions').doc();
    final productRef = FirebaseFirestore.instance.collection('products').doc();

    try {
      if (type == "promotion") {
        Reference storageReference =
            FirebaseStorage.instance.ref().child('promotions/${promoRef.id}');
        UploadTask uploadTask = storageReference.putFile(_imageFile);
        await uploadTask;
        storageReference.getDownloadURL().then((fileURL) {
          updatePicUrl(promoRef.id, fileURL, type);
        });
      }
      if (type == "navigationRoute") {
        Reference storageReference = FirebaseStorage.instance
            .ref()
            .child('navigationRoutes/$outletID/$imgName');
        UploadTask uploadTask = storageReference.putFile(_imageFile);
        await uploadTask;
        storageReference.getDownloadURL().then((fileURL) {
          updatePicUrl(outletID, fileURL, type, imgName: imgName);
        });
      }
      if (type == "product") {
        Reference storageReference =
            FirebaseStorage.instance.ref().child('products/${productRef.id}');
        UploadTask uploadTask = storageReference.putFile(_imageFile);
        await uploadTask;
        storageReference.getDownloadURL().then((fileURL) {
          updatePicUrl(productRef.id, fileURL, type);
        });
      }
    } catch (e) {
      print(e);
    }

    return type == "promotion"
        ? promoRef.id
        : type == "product"
            ? productRef.id
            : null;
  }

  /// Updates Firestore collection with Pic URL - COMMON DB Call
  Future updatePicUrl(String _docID, String _picUrl, String picType,
      {String imgName}) async {
    if (picType == "promotion") {
      await promotionsCollectionReference
          .doc(_docID)
          .update({"promoPicUrl": _picUrl})
          .then((value) => print("Promotion Picture Updated"))
          .catchError(
              (error) => print("Failed to update Promotion Picture: $error"));
    } else if (picType == "navigationRoute") {
      await outletCollectionReference
          .doc(_docID)
          .update({imgName: _picUrl}).then((value) {
        print("Navigation Route Picture Updated");
        outletCollectionReference.doc(_docID).update({
          "isRouteAdded": true,
        });
        print("Route Status Updated!");
      }).catchError((error) =>
              print("Failed to update Navigation Route Picture: $error"));
    } else if (picType == "product") {
      await productCollectionReference
          .doc(_docID)
          .update({"productPicUrl": _picUrl})
          .then((value) => print("Product Picture Updated"))
          .catchError(
              (error) => print("Failed to update Product Picture: $error"));
    }
  }

  /// Updates all the Promotion details in Firestore
  Future updatePromoDetails(String _promoID, Promotion promotion) async {
    await promotionsCollectionReference
        .doc(_promoID)
        .set({
          "promoPicUrl": promotion.promoPicUrl,
          "promoTitle": promotion.promoTitle,
          "promoID": _promoID,
          "promoDesc": promotion.promoDesc,
          "promoStartingDate": promotion.promoStartingDate,
          "promoEndingDate": promotion.promoEndingDate,
          "promoAddedTime": promotion.promoAddedTime,
          "addedBy": loggedInUserID,
          "isApproved": false,
        })
        .then((value) => print("Promotion Details Updated: " + _promoID))
        .catchError(
            (error) => print("Failed to update promotion details: $error"));
  }

  /// Updates all the Promotion details in Firestore
  Future updateProductDetails(String _productID, Product product) async {
    await productCollectionReference
        .doc(_productID)
        .set({
          "productTitle": product.productTitle,
          "productPrice": product.productPrice,
          "addedTime": product.addedTime,
          "productDesc": product.productDesc,
          "productCategory": product.productCategory,
          "addedBy": product.addedBy,
          "productID": _productID,
        })
        .then((value) => print("Product Details Updated: " + _productID))
        .catchError(
            (error) => print("Failed to update Product details: $error"));
  }

  /// Approves the Promotion - Admin
  Future<void> approvePromotion(String _promoID) {
    return promotionsCollectionReference
        .doc(_promoID)
        .update({
          "isApproved": true,
        })
        .then((value) => print("Promotion Accepted"))
        .catchError((error) => print("Failed to accept promotion: $error"));
  }

  /// Removes the Promotion - Admin
  Future<void> removePromotion(String _promoID) {
    return promotionsCollectionReference
        .doc(_promoID)
        .delete()
        .then((value) => print("Promotion Deleted"))
        .catchError((error) => print("Failed to delete promotion: $error"));
  }

  /// Saves Feedback info - Customer
  Future<void> giveFeedBack(fdb.Feedback _feedback) async {
    await feedbacksCollectionReference
        .doc()
        .set({
          "feedback": _feedback.feedback,
          "rating": _feedback.rating,
          "givenBy": _feedback.givenBy,
          "outletID": _feedback.outletID,
          "addedDate": _feedback.addedDate,
        })
        .then((value) => print("Feedback Details Updated: "))
        .catchError(
            (error) => print("Failed to update feedback details: $error"));
  }

  /// Gets outlet Id when the outlet name is available
  Future<String> getOutletID(String outletName, {bool isCommon}) async {
    String selectedOutletID = "";
    await outletCollectionReference
        .where('outletName', isEqualTo: outletName)
        .where("isRouteAdded", isEqualTo: isCommon != null ? true : false)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        selectedOutletID = doc.id;
        // print(selectedOutletID);
      });
    });

    return selectedOutletID;
  }

  /// Gets route added outlet names
  Future<List> getOutletsWithRoutes() async {
    List<String> outletsList = [];
    await outletCollectionReference
        .where("isRouteAdded", isEqualTo: true)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        outletsList.add(doc.get('outletName'));
      });
    });
    print(outletsList);
    return outletsList;
  }

  /// Adds the order
  Future<void> addOrder(Order _order) async {
    final orderRef = FirebaseFirestore.instance.collection('orders').doc();

    await orderRef
        .set({
          "productTitle": _order.productTitle,
          "productPrice": _order.productPrice,
          "productPicUrl": _order.productPicUrl,
          "orderID": orderRef.id,
          "productID": _order.productID,
          "quantity": _order.quantity,
          "purchaseTime": _order.purchaseTime,
          "purchasedBy": _order.purchasedBy,
          "soldBy": _order.soldBy,
        })
        .then((value) => print("Order Details Updated: "))
        .catchError((error) => print("Failed to Order details: $error"));
  }

  /// Deleted the order
  Future<void> completeOrder(String _orderID) {
    return orderCollectionReference
        .doc(_orderID)
        .delete()
        .then((value) => print("Order Removed"))
        .catchError((error) => print("Failed to delete Order: $error"));
  }

  /// Send Report info to DB
  Future<void> sendStatistics(String currentDay, String currentHour,
      {String type, String id, bool shouldUpdate}) async {
    /// Gets the current weeks start and end dates
    List dates = common.getWeek();

    /// Converts the current hour into an int
    var currentHourInInt = int.parse(currentHour);
    assert(currentHourInInt is int);

    /// Converts the current day string to loverCase
    String currentDayInLowerCase = currentDay.toLowerCase();
    print(currentDayInLowerCase);

    await reportCollectionReference
        .doc(dates[0] + "-" + dates[1])
        .get()
        .then((doc) async {
      if (doc.exists) {
        if (shouldUpdate) {
          /// Updates count depending on time and date
          if (currentHourInInt >= 9 && currentHourInInt < 12) {
            switch (currentDayInLowerCase) {
              case "monday":
                {
                  updateStatistics({
                    "time9_12": FieldValue.increment(1),
                    "monday": FieldValue.increment(1),
                  });
                }
                break;

              case "tuesday":
                {
                  updateStatistics({
                    "time9_12": FieldValue.increment(1),
                    "tuesday": FieldValue.increment(1),
                  });
                }
                break;
              case "wednesday":
                {
                  updateStatistics({
                    "time9_12": FieldValue.increment(1),
                    "wednesday": FieldValue.increment(1),
                  });
                }
                break;
              case "thursday":
                {
                  updateStatistics({
                    "time9_12": FieldValue.increment(1),
                    "thursday": FieldValue.increment(1),
                  });
                }
                break;
              case "friday":
                {
                  updateStatistics({
                    "time9_12": FieldValue.increment(1),
                    "friday": FieldValue.increment(1),
                  });
                }
                break;
              case "saturday":
                {
                  updateStatistics({
                    "time9_12": FieldValue.increment(1),
                    "saturday": FieldValue.increment(1),
                  });
                }
                break;
              case "sunday":
                {
                  updateStatistics({
                    "time9_12": FieldValue.increment(1),
                    "sunday": FieldValue.increment(1),
                  });
                }
                break;
            }
          } else if (currentHourInInt >= 12 && currentHourInInt < 15) {
            switch (currentDayInLowerCase) {
              case "monday":
                {
                  updateStatistics({
                    "time12_15": FieldValue.increment(1),
                    "monday": FieldValue.increment(1),
                  });
                }
                break;

              case "tuesday":
                {
                  updateStatistics({
                    "time12_15": FieldValue.increment(1),
                    "tuesday": FieldValue.increment(1),
                  });
                }
                break;
              case "wednesday":
                {
                  updateStatistics({
                    "time12_15": FieldValue.increment(1),
                    "wednesday": FieldValue.increment(1),
                  });
                }
                break;
              case "thursday":
                {
                  updateStatistics({
                    "time12_15": FieldValue.increment(1),
                    "thursday": FieldValue.increment(1),
                  });
                }
                break;
              case "friday":
                {
                  updateStatistics({
                    "time12_15": FieldValue.increment(1),
                    "friday": FieldValue.increment(1),
                  });
                }
                break;
              case "saturday":
                {
                  updateStatistics({
                    "time12_15": FieldValue.increment(1),
                    "saturday": FieldValue.increment(1),
                  });
                }
                break;
              case "sunday":
                {
                  updateStatistics({
                    "time12_15": FieldValue.increment(1),
                    "sunday": FieldValue.increment(1),
                  });
                }
                break;
            }
          } else if (currentHourInInt >= 15 && currentHourInInt < 18) {
            switch (currentDayInLowerCase) {
              case "monday":
                {
                  updateStatistics({
                    "time15_18": FieldValue.increment(1),
                    "monday": FieldValue.increment(1),
                  });
                }
                break;

              case "tuesday":
                {
                  updateStatistics({
                    "time15_18": FieldValue.increment(1),
                    "tuesday": FieldValue.increment(1),
                  });
                }
                break;
              case "wednesday":
                {
                  updateStatistics({
                    "time15_18": FieldValue.increment(1),
                    "wednesday": FieldValue.increment(1),
                  });
                }
                break;
              case "thursday":
                {
                  updateStatistics({
                    "time15_18": FieldValue.increment(1),
                    "thursday": FieldValue.increment(1),
                  });
                }
                break;
              case "friday":
                {
                  updateStatistics({
                    "time15_18": FieldValue.increment(1),
                    "friday": FieldValue.increment(1),
                  });
                }
                break;
              case "saturday":
                {
                  updateStatistics({
                    "time15_18": FieldValue.increment(1),
                    "saturday": FieldValue.increment(1),
                  });
                }
                break;
              case "sunday":
                {
                  updateStatistics({
                    "time15_18": FieldValue.increment(1),
                    "sunday": FieldValue.increment(1),
                  });
                }
                break;
            }
          } else if (currentHourInInt >= 18 && currentHourInInt < 21) {
            switch (currentDayInLowerCase) {
              case "monday":
                {
                  updateStatistics({
                    "time18_21": FieldValue.increment(1),
                    "monday": FieldValue.increment(1),
                  });
                }
                break;

              case "tuesday":
                {
                  updateStatistics({
                    "time18_21": FieldValue.increment(1),
                    "tuesday": FieldValue.increment(1),
                  });
                }
                break;
              case "wednesday":
                {
                  updateStatistics({
                    "time18_21": FieldValue.increment(1),
                    "wednesday": FieldValue.increment(1),
                  });
                }
                break;
              case "thursday":
                {
                  updateStatistics({
                    "time18_21": FieldValue.increment(1),
                    "thursday": FieldValue.increment(1),
                  });
                }
                break;
              case "friday":
                {
                  updateStatistics({
                    "time18_21": FieldValue.increment(1),
                    "friday": FieldValue.increment(1),
                  });
                }
                break;
              case "saturday":
                {
                  updateStatistics({
                    "time18_21": FieldValue.increment(1),
                    "saturday": FieldValue.increment(1),
                  });
                }
                break;
              case "sunday":
                {
                  updateStatistics({
                    "time18_21": FieldValue.increment(1),
                    "sunday": FieldValue.increment(1),
                  });
                }
                break;
            }
          } else if (currentHourInInt >= 21 && currentHourInInt <= 00) {
            switch (currentDayInLowerCase) {
              case "monday":
                {
                  updateStatistics({
                    "time21_24": FieldValue.increment(1),
                    "monday": FieldValue.increment(1),
                  });
                }
                break;

              case "tuesday":
                {
                  updateStatistics({
                    "time21_24": FieldValue.increment(1),
                    "tuesday": FieldValue.increment(1),
                  });
                }
                break;
              case "wednesday":
                {
                  updateStatistics({
                    "time21_24": FieldValue.increment(1),
                    "wednesday": FieldValue.increment(1),
                  });
                }
                break;
              case "thursday":
                {
                  updateStatistics({
                    "time21_24": FieldValue.increment(1),
                    "thursday": FieldValue.increment(1),
                  });
                }
                break;
              case "friday":
                {
                  updateStatistics({
                    "time21_24": FieldValue.increment(1),
                    "friday": FieldValue.increment(1),
                  });
                }
                break;
              case "saturday":
                {
                  updateStatistics({
                    "time21_24": FieldValue.increment(1),
                    "saturday": FieldValue.increment(1),
                  });
                }
                break;
              case "sunday":
                {
                  updateStatistics({
                    "time21_24": FieldValue.increment(1),
                    "sunday": FieldValue.increment(1),
                  });
                }
                break;
            }
          }
        }

        /// Collects product/category/order/outlet click count
        if (type == "product") {
          updateStatistics({
            "products.$id": FieldValue.increment(1),
          });
        } else if (type == "outlet") {
          updateStatistics({
            "outlets.$id": FieldValue.increment(1),
          });
        } else if (type == "order") {
          updateStatistics({
            "orders.$id": FieldValue.increment(1),
          });
        } else if (type == "category") {
          updateStatistics({
            "categories.$id": FieldValue.increment(1),
          });
        } else {
          print("No Value");
        }
      } else {
        /// Updates with dummy data if the data is not available
        await reportCollectionReference
            .doc(dates[0] + "-" + dates[1])
            .set({
              "weekStartDate": dates[0],
              "weekEndDate": dates[1],
              "monday": 0,
              "tuesday": 0,
              "wednesday": 0,
              "thursday": 0,
              "friday": 0,
              "saturday": 0,
              "sunday": 0,
              "time9_12": 0,
              "time12_15": 0,
              "time15_18": 0,
              "time18_21": 0,
              "time21_24": 0,
              "products": {},
              "orders": {},
              "categories": {},
              "outlets": {},
            })
            .then((value) => print("Report Details Updated: "))
            .catchError((error) => print("Failed to Report details: $error"));
      }
    });
  }

  /// Updates report data in DB
  Future updateStatistics(Map<String, Object> map) async {
    List dates = common.getWeek();

    await reportCollectionReference
        .doc(dates[0] + "-" + dates[1])
        .update(map)
        .then((value) => print("Report Details Updated: "))
        .catchError((error) => print("Failed to Report details: $error"));
  }

  /// Gets report data
  Future<Report> getReportData(String dateRage) async {
    Report _report = Report();
    await reportCollectionReference
        .where(FieldPath.documentId, isEqualTo: dateRage)
        .get()
        .then((event) {
      if (event.docs.isNotEmpty) {
        Map<String, dynamic> documentData = event.docs.single.data();

        _report.monday = documentData['monday'].toString();
        _report.tuesday = documentData['tuesday'].toString();
        _report.wednesday = documentData['wednesday'].toString();
        _report.thursday = documentData['thursday'].toString();
        _report.friday = documentData['friday'].toString();
        _report.saturday = documentData['saturday'].toString();
        _report.sunday = documentData['sunday'].toString();
        _report.time9_12 = documentData['time9_12'].toString();
        _report.time12_15 = documentData['time12_15'].toString();
        _report.time15_18 = documentData['time15_18'].toString();
        _report.time18_21 = documentData['time18_21'].toString();
        _report.time21_24 = documentData['time21_24'].toString();
        _report.outlets = documentData['outlets'];
        _report.categories = documentData['categories'];
        _report.orders = documentData['orders'];
        _report.products = documentData['products'];
      }
    }).catchError((e) => print("error fetching data: $e"));

    return _report;
  }

  /// Gets date range list in the report screen - Admin
  Future<List> getDateRangeList() async {
    List _dateRangeList = [];
    await reportCollectionReference.get().then((snapshot) {
      snapshot.docs.forEach((doc) {
        _dateRangeList.add(doc.id.toString());
      });
    });
    return _dateRangeList;
  }

  /// Gets product data in the report screen - Admin
  Future<Product> getProductData(String productID) async {
    Product _product = Product();
    await productCollectionReference
        .where(FieldPath.documentId, isEqualTo: productID)
        .get()
        .then((event) {
      if (event.docs.isNotEmpty) {
        Map<String, dynamic> documentData = event.docs.single.data();

        _product.productTitle = documentData['productTitle'].toString();
        _product.productID = documentData['productID'].toString();
        _product.productPicUrl = documentData['productPicUrl'].toString();
      }
    }).catchError((e) => print("error fetching data: $e"));

    return _product;
  }

  /// Gets outlet data in the report screen - Admin
  Future<Outlet> getOutletData(String outletID) async {
    Outlet _outlet = Outlet();
    await outletCollectionReference
        .where(FieldPath.documentId, isEqualTo: outletID)
        .get()
        .then((event) {
      if (event.docs.isNotEmpty) {
        Map<String, dynamic> documentData = event.docs.single.data();

        _outlet.outletName = documentData['outletName'].toString();
        _outlet.outletID = documentData['userID'].toString();
        _outlet.profilePicUrl = documentData['profilePicUrl'].toString();
      }
    }).catchError((e) => print("error fetching data: $e"));

    return _outlet;
  }
}
