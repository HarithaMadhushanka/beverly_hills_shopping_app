import 'dart:async';
import 'dart:io';

import 'package:beverly_hills_shopping_app/models/customer.dart';
import 'package:beverly_hills_shopping_app/models/outlet.dart';
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
}
