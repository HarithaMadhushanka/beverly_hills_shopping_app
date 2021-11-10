import 'dart:async';
import 'dart:io';

import 'package:beverly_hills_shopping_app/models/customer.dart';
import 'package:beverly_hills_shopping_app/models/feedback.dart' as fdb;
import 'package:beverly_hills_shopping_app/models/outlet.dart';
import 'package:beverly_hills_shopping_app/models/product.dart';
import 'package:beverly_hills_shopping_app/models/promotion.dart';
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

  StreamSubscription<User> checkAuthState() {
    return FirebaseAuth.instance.authStateChanges().listen(
      (User user) {
        if (user == null) {
          loggedInUserID = "";
          print('User is currently signed out!');
          isCustomerLoggedIn = false;
        } else {
          loggedInUserID = user.uid;

          customerCollectionReference.get().then((QuerySnapshot querySnapshot) {
            querySnapshot.docs.forEach((doc) {
              if (loggedInUserID == doc["userID"]) {
                isCustomerLoggedIn = true;
                print('Customer is signed in!');
              }
            });
          });

          outletCollectionReference.get().then((QuerySnapshot querySnapshot) {
            querySnapshot.docs.forEach((doc) {
              if (loggedInUserID == doc["userID"]) {
                isOutletLoggedIn = true;
                print('Outlet is signed in!');
              }
            });
          });
        }
      },
    );
  }

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

  Future<UserCredential> loginAdmin() async {
    UserCredential userCredential =
        await FirebaseAuth.instance.signInAnonymously();

    print("Admin Logged In");
    return userCredential;
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

  /// Uploads Pictures (Firebase Storage) - COMMON
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

  /// Updates Firestore collection with Pic URL - COMMON
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

  Future<void> approvePromotion(String _promoID) {
    return promotionsCollectionReference
        .doc(_promoID)
        .update({
          "isApproved": true,
        })
        .then((value) => print("Promotion Accepted"))
        .catchError((error) => print("Failed to accept promotion: $error"));
  }

  Future<void> removePromotion(String _promoID) {
    return promotionsCollectionReference
        .doc(_promoID)
        .delete()
        .then((value) => print("Promotion Deleted"))
        .catchError((error) => print("Failed to delete promotion: $error"));
  }

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

  Future<void> commonUserSignOut() async {
    await FirebaseAuth.instance.signOut();
    print("User Signed Out!");
  }

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
}
