import 'dart:io';

import 'package:beverly_hills_shopping_app/components/custom_text_field.dart';
import 'package:beverly_hills_shopping_app/database/db_helper.dart';
import 'package:beverly_hills_shopping_app/models/customer.dart';
import 'package:beverly_hills_shopping_app/models/outlet.dart';
import 'package:beverly_hills_shopping_app/screens/customer/customer_home_screen.dart';
import 'package:beverly_hills_shopping_app/screens/outlet/outlet_home_screen.dart';
import 'package:beverly_hills_shopping_app/utils/common_functions.dart'
    as common;
import 'package:beverly_hills_shopping_app/utils/enums.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:introduction_screen/introduction_screen.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key key, @required this.userID, @required this.userType})
      : super(key: key);
  final String userID;
  final String userType;

  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final introKey = GlobalKey<IntroductionScreenState>();

  /// Customer controllers
  final TextEditingController firstNameCustomerController =
      TextEditingController();
  final TextEditingController lastNameCustomerController =
      TextEditingController();
  final TextEditingController mobileNoCustomerController =
      TextEditingController();
  final TextEditingController address1CustomerController =
      TextEditingController();
  final TextEditingController address2CustomerController =
      TextEditingController();
  final TextEditingController address3CustomerController =
      TextEditingController();

  /// Outlet controllers
  final TextEditingController nameOutletController = TextEditingController();
  final TextEditingController mobileNoOutletController =
      TextEditingController();
  final TextEditingController address1OutletController =
      TextEditingController();
  final TextEditingController address2OutletController =
      TextEditingController();
  final TextEditingController address3OutletController =
      TextEditingController();

  final ImagePicker _picker = ImagePicker();
  File _imageFile;
  String _pickedImageFilePath = "";
  DBHelper _dbHelper = DBHelper();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return WillPopScope(
      child: IntroductionScreen(
        key: introKey,
        globalBackgroundColor: SecondaryColorLight,
        pages: [
          PageViewModel(
            title: "Let's Set a Profile Picture",
            bodyWidget: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: PrimaryColorLight,
                    ),
                    child: Center(
                      child: _pickedImageFilePath != ""
                          ? Image.file(File(_pickedImageFilePath))
                          : Image.asset(
                              'images/user.png',
                              fit: BoxFit.cover,
                              height: 130,
                              width: 130,
                            ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                InkWell(
                  onTap: () {
                    print("tapped");
                    _uploadImageButtonPressed(ImageSource.gallery, context);
                  },
                  splashColor: PrimaryColorLight,
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    width: 120,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: PrimaryColorDark),
                    ),
                    child: Center(
                      child: Text(
                        "Upload Picture",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: PrimaryColorDark,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            footer: Text(
              "Upload a photo from your gallery and set it as your profile picture.\n\nDon't worry!\nIt can be changed at any time in your profile.",
              textAlign: TextAlign.justify,
              style: TextStyle(
                  color: PrimaryColorDark,
                  fontSize: 16,
                  fontWeight: FontWeight.w400),
            ),
            decoration: pageDecoration,
          ),
          widget.userType == "customer"
              ? PageViewModel(
                  title: "Let us get to know about you a little more ..",
                  bodyWidget: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomTextField(
                        controller: firstNameCustomerController,
                        height: 60,
                        width: width,
                        hintText: "First name",
                        icon: Icons.person_add_alt_1,
                        iconSize: 22,
                        textInputType: TextInputType.text,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      CustomTextField(
                        controller: lastNameCustomerController,
                        height: 60,
                        width: width,
                        hintText: "Last name",
                        icon: Icons.person_add_alt_1_outlined,
                        iconSize: 22,
                        textInputType: TextInputType.text,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      CustomTextField(
                        controller: mobileNoCustomerController,
                        height: 60,
                        width: width,
                        hintText: "Mobile number",
                        icon: Icons.phone,
                        iconSize: 22,
                        textInputType: TextInputType.number,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      CustomTextField(
                        controller: address1CustomerController,
                        height: 60,
                        width: width,
                        hintText: "Address line 1",
                        icon: Icons.note,
                        iconSize: 22,
                        textInputType: TextInputType.text,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      CustomTextField(
                        controller: address2CustomerController,
                        height: 60,
                        width: width,
                        hintText: "Address line 2",
                        icon: Icons.note,
                        iconSize: 22,
                        textInputType: TextInputType.text,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      CustomTextField(
                        controller: address3CustomerController,
                        height: 60,
                        width: width,
                        hintText: "Address line 3",
                        icon: Icons.note,
                        iconSize: 22,
                        textInputType: TextInputType.text,
                      ),
                    ],
                  ),
                  decoration: pageDecoration,
                )
              : widget.userType == "outlet"
                  ? PageViewModel(
                      title: "Let us get to know about you a little more ..",
                      bodyWidget: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CustomTextField(
                            controller: nameOutletController,
                            height: 60,
                            width: width,
                            hintText: "Outlet name",
                            icon: Icons.person_add_alt_1,
                            iconSize: 22,
                            textInputType: TextInputType.text,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          CustomTextField(
                            controller: mobileNoOutletController,
                            height: 60,
                            width: width,
                            hintText: "Mobile number",
                            icon: Icons.phone,
                            iconSize: 22,
                            textInputType: TextInputType.number,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          CustomTextField(
                            controller: address1OutletController,
                            height: 60,
                            width: width,
                            hintText: "Address line 1",
                            icon: Icons.note,
                            iconSize: 22,
                            textInputType: TextInputType.text,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          CustomTextField(
                            controller: address2OutletController,
                            height: 60,
                            width: width,
                            hintText: "Address line 2",
                            icon: Icons.note,
                            iconSize: 22,
                            textInputType: TextInputType.text,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          CustomTextField(
                            controller: address3OutletController,
                            height: 60,
                            width: width,
                            hintText: "Address line 3",
                            icon: Icons.note,
                            iconSize: 22,
                            textInputType: TextInputType.text,
                          ),
                        ],
                      ),
                      decoration: pageDecoration,
                    )
                  : Container,
          PageViewModel(
            title: widget.userType == "customer"
                ? "Time to Go Shopping!"
                : "Let's start with listing some new Products",
            bodyWidget: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "images/shopping.png",
                  height: MediaQuery.of(context).size.width,
                ),
              ],
            ),
            decoration: pageDecoration.copyWith(
              titlePadding: EdgeInsets.fromLTRB(16.0, 120.0, 16.0, 16.0),
              descriptionPadding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 16.0),
              titleTextStyle: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.w700,
                color: PrimaryColorDark,
              ),
            ),
            reverse: true,
          ),
        ],
        onDone: () => _onIntroEnd(context),
        showSkipButton: false,
        skipFlex: 0,
        nextFlex: 0,
        next: const Icon(Icons.arrow_forward_ios),
        nextColor: SecondaryColorDark,
        done: InkWell(
          splashColor: PrimaryColorLight,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: 60,
            height: 30,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: PrimaryColorDark),
            ),
            child: Center(
              child: Text(
                "DONE",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: PrimaryColorDark,
                ),
              ),
            ),
          ),
        ),
        doneColor: SecondaryColorDark,
        curve: Curves.fastLinearToSlowEaseIn,
        controlsMargin: const EdgeInsets.all(16),
        controlsPadding: kIsWeb
            ? const EdgeInsets.all(12.0)
            : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
        dotsDecorator: const DotsDecorator(
          size: Size(10.0, 10.0),
          color: PrimaryColorDark,
          activeSize: Size(22.0, 10.0),
          activeColor: SecondaryColorDark,
          activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
          ),
        ),
        dotsContainerDecorator: const ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
        ),
      ),
      onWillPop: () => null,
    );
  }

  /// Picks a Profile pic from gallery
  void _uploadImageButtonPressed(
      ImageSource source, BuildContext context) async {
    try {
      final pickedFile = await _picker.getImage(
        source: source,
        imageQuality: 50,
      );
      setState(() {
        _imageFile = File(pickedFile.path);
        _pickedImageFilePath = _imageFile.path;
      });
      _dbHelper.uploadUserProfilePic(
          widget.userID, _imageFile, widget.userType);
    } catch (e) {
      print(e.toString());
    }
  }

  /// Validates the fields and updates User details
  void _onIntroEnd(context) {
    if (widget.userType == "customer") {
      if (firstNameCustomerController.text.isNotEmpty &&
          lastNameCustomerController.text.isNotEmpty &&
          mobileNoCustomerController.text.isNotEmpty &&
          address1CustomerController.text.isNotEmpty &&
          address2CustomerController.text.isNotEmpty &&
          address3CustomerController.text.isNotEmpty &&
          _imageFile != null) {
        updateUserDetails();
      } else if (firstNameCustomerController.text.isNotEmpty &&
          lastNameCustomerController.text.isNotEmpty &&
          mobileNoCustomerController.text.isNotEmpty &&
          address1CustomerController.text.isNotEmpty &&
          address2CustomerController.text.isNotEmpty &&
          address3CustomerController.text.isNotEmpty &&
          _imageFile == null) {
        introKey.currentState?.animateScroll(0);
        common.showToast(context, "Please upload a profile picture");
      } else if (firstNameCustomerController.text.isEmpty ||
          lastNameCustomerController.text.isEmpty ||
          mobileNoCustomerController.text.isEmpty ||
          address1CustomerController.text.isEmpty ||
          address2CustomerController.text.isEmpty ||
          address3CustomerController.text.isEmpty && _imageFile != null) {
        introKey.currentState?.animateScroll(1);
        common.showToast(context, "Please fill all the fields");
      } else {
        introKey.currentState?.animateScroll(0);
        common.showToast(context,
            "Please upload a profile picture and fill in all the details");
      }
    } else {
      if (nameOutletController.text.isNotEmpty &&
          mobileNoOutletController.text.isNotEmpty &&
          address1OutletController.text.isNotEmpty &&
          address2OutletController.text.isNotEmpty &&
          address3OutletController.text.isNotEmpty &&
          _imageFile != null) {
        updateUserDetails();
      } else if (nameOutletController.text.isNotEmpty &&
          mobileNoOutletController.text.isNotEmpty &&
          address1OutletController.text.isNotEmpty &&
          address2OutletController.text.isNotEmpty &&
          address3OutletController.text.isNotEmpty &&
          _imageFile == null) {
        introKey.currentState?.animateScroll(0);
        common.showToast(context, "Please upload a profile picture");
      } else if (nameOutletController.text.isEmpty ||
          mobileNoOutletController.text.isEmpty ||
          address1OutletController.text.isEmpty ||
          address2OutletController.text.isEmpty ||
          address3OutletController.text.isEmpty && _imageFile != null) {
        introKey.currentState?.animateScroll(1);
        common.showToast(context, "Please fill all the fields");
      } else {
        introKey.currentState?.animateScroll(0);
        common.showToast(context,
            "Please upload a profile picture and fill in all the details");
      }
    }
  }

  Future updateUserDetails() async {
    if (widget.userType == "customer") {
      Customer customer = Customer();
      customer.firstName = firstNameCustomerController.text;
      customer.lastName = lastNameCustomerController.text;
      customer.mobileNo = mobileNoCustomerController.text;
      customer.addressLine1 = address1CustomerController.text;
      customer.addressLine2 = address2CustomerController.text;
      customer.addressLine3 = address3CustomerController.text;
      _dbHelper
          .updateUserDetails(widget.userID, "customer", customer: customer)
          .then((value) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => CustomerHomeScreen(),
          ),
        );
      });
    } else {
      Outlet outlet = Outlet();
      outlet.outletName = nameOutletController.text;
      outlet.mobileNo = mobileNoOutletController.text;
      outlet.addressLine1 = address1OutletController.text;
      outlet.addressLine2 = address2OutletController.text;
      outlet.addressLine3 = address3OutletController.text;
      _dbHelper.updateUserDetails(widget.userID, "outlet", outlet: outlet).then(
            (value) => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => OutletHomeScreen(),
              ),
            ),
          );
    }
  }

  @override
  void dispose() {
    _imageFile = null;
    super.dispose();
  }
}
