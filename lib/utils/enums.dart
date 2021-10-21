import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

const PrimaryColorDark = const Color(0xFF276678);
const SecondaryColorDark = const Color(0xFF1687A7);
const PrimaryColorLight = const Color(0xFFD3E0EA);
const SecondaryColorLight = const Color(0xFFF6F5F5);
const pageDecoration = const PageDecoration(
  titleTextStyle: TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.w700,
    color: PrimaryColorDark,
  ),
  bodyTextStyle: TextStyle(
    fontSize: 19.0,
  ),
  descriptionPadding: EdgeInsets.fromLTRB(15.0, 25.0, 15.0, 16.0),
  titlePadding: EdgeInsets.fromLTRB(16.0, 60.0, 16.0, 16.0),
  pageColor: SecondaryColorLight,
  imagePadding: EdgeInsets.zero,
  footerPadding: EdgeInsets.fromLTRB(20.0, 100.0, 20.0, 0.0),
);

bool isCustomerLoggedIn = false;
bool isOutletLoggedIn = false;
String loggedInUserID = "";

CollectionReference customerCollectionReference =
    FirebaseFirestore.instance.collection('customers');
CollectionReference outletCollectionReference =
    FirebaseFirestore.instance.collection('outlets');
