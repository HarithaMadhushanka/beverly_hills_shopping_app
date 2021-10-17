import 'package:beverly_hills_shopping_app/common_functions.dart' as common;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

bool isLoggedIn = false;

class DBHelper {
  FirebaseAuth _auth = FirebaseAuth.instance;

  void checkAuthState() {
    FirebaseAuth.instance.authStateChanges().listen(
      (User user) {
        if (user == null) {
          print('User is currently signed out!');
          isLoggedIn = false;
        } else {
          print('User is signed in!');
          isLoggedIn = true;
        }
      },
    );
  }

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

  Future saveUserInfoToFireStore(
      User firebaseUser, String collectionName) async {
    FirebaseFirestore.instance
        .collection(collectionName)
        .doc(firebaseUser.uid)
        .set({
      "userID": firebaseUser.uid,
    });
  }

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
}
