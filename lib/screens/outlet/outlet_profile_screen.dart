import 'dart:io';

import 'package:beverly_hills_shopping_app/components/custom_description_box.dart';
import 'package:beverly_hills_shopping_app/components/custom_outline_button.dart';
import 'package:beverly_hills_shopping_app/components/custom_sliver_app_bar_common.dart';
import 'package:beverly_hills_shopping_app/components/custom_text_field.dart';
import 'package:beverly_hills_shopping_app/database/db_helper.dart';
import 'package:beverly_hills_shopping_app/models/outlet.dart';
import 'package:beverly_hills_shopping_app/screens/welcome/welcome.dart';
import 'package:beverly_hills_shopping_app/utils/common_functions.dart'
    as common;
import 'package:beverly_hills_shopping_app/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

class OutletProfileScreen extends StatefulWidget {
  const OutletProfileScreen({Key key}) : super(key: key);

  @override
  _OutletProfileScreenState createState() => _OutletProfileScreenState();
}

class _OutletProfileScreenState extends State<OutletProfileScreen> {
  TextEditingController _outletNameController = TextEditingController();
  TextEditingController _outletMobileNoController = TextEditingController();
  TextEditingController _outletAddress1Controller = TextEditingController();
  TextEditingController _outletAddress2Controller = TextEditingController();
  TextEditingController _outletAddress3Controller = TextEditingController();
  TextEditingController _outletDescController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  File _imageFile;
  String _pickedImageFilePath = "";
  DBHelper _dbHelper = DBHelper();

  String _selectedCategory;

  @override
  void initState() {
    super.initState();
    common
        .saveUpdatedUserDetailsLocally(userType: "outlet")
        .then((value) async {
      _selectedCategory = value.category;
      _outletNameController.text = value.outletName;
      _outletMobileNoController.text = value.mobileNo;
      _outletAddress1Controller.text = value.addressLine1;
      _outletAddress2Controller.text = value.addressLine2;
      _outletAddress3Controller.text = value.addressLine3;
      _outletDescController.text = value.outletDesc;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: SecondaryColorLight,
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          /// SLiver App bar
          buildCustomSliverAppBarCommon(
              context: context,
              isBackNeeded: true,
              title: 'Profile',
              isTrailingNeeded: true,
              trailingOnTap: () {
                _onUpdateClicked();
              }),
          SliverFillRemaining(
            child: SingleChildScrollView(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    GestureDetector(
                      onTap: () {
                        common
                            .pickImage(picker: _picker, imageFile: _imageFile)
                            .then((value) => common
                                    .cropImage(imageFile: value)
                                    .then((value) {
                                  setState(() {
                                    _pickedImageFilePath = value.path;
                                    _imageFile = value;
                                  });
                                }));
                      },
                      child: Stack(
                        children: [
                          ClipOval(
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(150),
                                  border: Border.all(
                                      color: PrimaryColorLight, width: 1.5)),
                              child: _pickedImageFilePath != "" &&
                                      loggedInUserID != ""
                                  ? Image.file(
                                      File(_pickedImageFilePath),
                                      height: 120,
                                      width: 120,
                                      fit: BoxFit.cover,
                                    )
                                  : _pickedImageFilePath == "" &&
                                          loggedInUserID != ""
                                      ? StreamBuilder(
                                          stream: outletCollectionReference
                                              .doc(loggedInUserID)
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            var userDocument = snapshot.data;
                                            if (!snapshot.hasData) {
                                              return ClipOval(
                                                child: Image.asset(
                                                  'images/user.png',
                                                  height: 120,
                                                  width: 120,
                                                  fit: BoxFit.cover,
                                                ),
                                              );
                                            }
                                            return userDocument[
                                                            "profilePicUrl"] !=
                                                        "" &&
                                                    userDocument[
                                                            "profilePicUrl"] !=
                                                        null
                                                ? ClipOval(
                                                    child: Image.network(
                                                      userDocument[
                                                          "profilePicUrl"],
                                                      height: 120,
                                                      width: 120,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  )
                                                : ClipOval(
                                                    child: Image.asset(
                                                      'images/user.png',
                                                      height: 120,
                                                      width: 120,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  );
                                          })
                                      : Container(),
                            ),
                          ),
                          Positioned(
                              top: 18,
                              right: 18,
                              child: Container(
                                height: 20,
                                width: 20,
                                decoration: BoxDecoration(
                                  color: PrimaryColorLight,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Center(
                                  child: FaIcon(
                                    FontAwesomeIcons.pen,
                                    color: PrimaryColorDark,
                                    size: 12,
                                  ),
                                ),
                              )),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Column(
                        children: [
                          CustomTextField(
                            controller: _outletNameController,
                            height: 60,
                            width: width,
                            hintText: 'First name',
                            icon: Icons.person,
                            textInputType: TextInputType.text,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          CustomTextField(
                            controller: _outletMobileNoController,
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
                            controller: _outletAddress1Controller,
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
                            controller: _outletAddress2Controller,
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
                            controller: _outletAddress3Controller,
                            height: 60,
                            width: width,
                            hintText: "Address line 3",
                            icon: Icons.note,
                            iconSize: 22,
                            textInputType: TextInputType.text,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          CustomDescriptionBox(
                            width: width,
                            height: height,
                            controller: _outletDescController,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            width: width,
                            height: 60,
                            decoration: BoxDecoration(
                              border: Border.all(color: PrimaryColorDark),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: DropdownButtonFormField(
                              value: _selectedCategory,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(top: 10),
                                hintText: _selectedCategory == null
                                    ? 'Please select a category'
                                    : _selectedCategory,
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                icon: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 20, top: 10),
                                  child: Icon(
                                    Icons.list,
                                    size: 22,
                                    color: SecondaryColorDark,
                                  ),
                                ),
                              ),
                              onChanged: (newValue) {
                                setState(() {
                                  _selectedCategory = newValue;
                                });
                              },
                              items: outletCategories.map((category) {
                                return DropdownMenuItem(
                                  child: Text(category),
                                  value: category,
                                );
                              }).toList(),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          CustomOutlineButton(
                            width: width,
                            height: 60,
                            text: 'Logout',
                            onTap: () {
                              _signOut();
                            },
                            fontColor: Colors.red,
                            borderColor: Colors.red,
                            borderWidth: 2,
                          ),
                          SizedBox(
                            height: 25,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _signOut() async {
    isCustomerLoggedIn = false;
    loggedInUserID = "";
    await _dbHelper.commonUserSignOut().then((value) {
      Route route = MaterialPageRoute(
        builder: (c) => WelcomeScreen(),
      );
      Navigator.pushReplacement(context, route);
    });
  }

  void _onUpdateClicked() {
    Outlet _outlet = Outlet();
    _dbHelper.uploadUserProfilePic(loggedInUserID, _imageFile, "outlet");
    _outlet.outletName = _outletNameController.text;
    _outlet.mobileNo = _outletMobileNoController.text;
    _outlet.addressLine1 = _outletAddress1Controller.text;
    _outlet.addressLine2 = _outletAddress2Controller.text;
    _outlet.addressLine3 = _outletAddress3Controller.text;
    _outlet.outletDesc = _outletDescController.text;
    _outlet.category = _selectedCategory;
    _dbHelper
        .updateUserDetails(loggedInUserID, "outlet", outlet: _outlet)
        .whenComplete(() {
      common.showToast(context, "Profile updated successfully");
      Future.delayed(Duration(seconds: 1), () {
        Navigator.pop(context);
      });
    });
  }
}
