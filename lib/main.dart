import 'dart:async';

import 'package:beverly_hills_shopping_app/screens/customer/customer_dashboard.dart';
import 'package:beverly_hills_shopping_app/screens/outlet/outlet_home_screen.dart';
import 'package:beverly_hills_shopping_app/screens/welcome/welcome.dart';
import 'package:beverly_hills_shopping_app/utils/enums.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  checkAuthState();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'SF',
        primaryColor: PrimaryColorDark,
      ),
      home: isCustomerLoggedIn
          ? CustomerDashboard()
          : isOutletLoggedIn
              ? OutletHomeScreen()
              : WelcomeScreen(), // Navigates to the Dashboard if the user is already logged in
    );
  }
}

/// Checks if the user is already logged in
Future<void> checkAuthState() async {
  FirebaseAuth.instance.authStateChanges().listen(
    (User user) {
      if (user == null) {
        loggedInUserID = "";
        print('User is currently signed out!');
        isCustomerLoggedIn = false;
        runApp(MyApp());
      } else if (user != null && user.isAnonymous == false) {
        /// Assigns the logged in user's user id
        loggedInUserID = user.uid;

        /// Checks customer Auth state
        customerCollectionReference.get().then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            if (loggedInUserID == (doc.data() as dynamic)['userID']) {
              isCustomerLoggedIn = true;
              print('Customer is signed in!');
              runApp(MyApp());
            }
          });
        });

        /// Checks outlet Auth state
        outletCollectionReference.get().then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            if (loggedInUserID == (doc.data() as dynamic)['userID']) {
              isOutletLoggedIn = true;
              print('Outlet is signed in!');
              runApp(MyApp());
            }
          });
        });
      } else {
        loggedInUserID = "";
      }
    },
  );
}
