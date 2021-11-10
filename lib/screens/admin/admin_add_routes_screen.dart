import 'dart:io';

import 'package:beverly_hills_shopping_app/components/custom_image_uploader.dart';
import 'package:beverly_hills_shopping_app/components/custom_sliver_app_bar_common.dart';
import 'package:beverly_hills_shopping_app/components/custom_solid_button.dart';
import 'package:beverly_hills_shopping_app/database/db_helper.dart';
import 'package:beverly_hills_shopping_app/utils/common_functions.dart'
    as common;
import 'package:beverly_hills_shopping_app/utils/enums.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AdminAddRoutesScreen extends StatefulWidget {
  const AdminAddRoutesScreen({Key key}) : super(key: key);

  @override
  _AdminAddRoutesScreenState createState() => _AdminAddRoutesScreenState();
}

class _AdminAddRoutesScreenState extends State<AdminAddRoutesScreen> {
  String _selectedOutletID = "";
  bool isImg1Uploaded = false;
  bool isImg2Uploaded = false;

  final ImagePicker _picker = ImagePicker();
  File _imageFile1;
  File _imageFile2;

  DBHelper _dbHelper = DBHelper();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: SecondaryColorLight,
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          /// SLiver App bar
          buildCustomSliverAppBarCommon(
            context: context,
            isBackNeeded: true,
            title: 'Add Routes',
            isTrailingNeeded: false,
          ),
          SliverFillRemaining(
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    StreamBuilder(
                        stream: outletCollectionReference
                            .where("isRouteAdded", isEqualTo: false)
                            .snapshots(),
                        builder: (context, snapshot) {
                          List<String> _outletList = [];
                          if (snapshot.hasData) {
                            for (int i = 0;
                                i < snapshot.data.docs.length;
                                i++) {
                              DocumentSnapshot snap = snapshot.data.docs[i];
                              _outletList.add(snap['outletName']);
                            }
                            return Container(
                              width: width,
                              height: 60,
                              decoration: BoxDecoration(
                                border: Border.all(color: PrimaryColorDark),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: DropdownButtonFormField(
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(top: 10),
                                  hintText: 'Please Select an Outlet',
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  icon: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, top: 10),
                                    child: Icon(
                                      Icons.list,
                                      size: 22,
                                      color: SecondaryColorDark,
                                    ),
                                  ),
                                ),
                                onChanged: (newValue) async {
                                  _selectedOutletID =
                                      await _dbHelper.getOutletID(newValue);
                                  setState(() {});
                                  print(_selectedOutletID);
                                },
                                items: _outletList.map((outlet) {
                                  return DropdownMenuItem(
                                    child: Text(outlet),
                                    value: outlet,
                                  );
                                }).toList(),
                              ),
                            );
                          }
                          return Container(
                            height: 0.0,
                            width: 0.0,
                          );
                        }),
                    SizedBox(
                      height: 40,
                    ),
                    Text(
                      "Upload the route Images",
                      style: TextStyle(
                        color: PrimaryColorDark,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    buildImageUploader(
                      width,
                      "Entrance to the Shop",
                      onTap: () {
                        common
                            .pickImage(picker: _picker, imageFile: _imageFile1)
                            .then((value) => common
                                    .cropImage(imageFile: value)
                                    .then((value) {
                                  setState(() {
                                    _imageFile1 = value;
                                    isImg1Uploaded = true;
                                  });
                                }));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          isImg1Uploaded
                              ? Icon(
                                  Icons.check,
                                  size: 22,
                                  color: Colors.green,
                                )
                              : Icon(
                                  Icons.cancel,
                                  size: 22,
                                  color: Colors.red,
                                ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            isImg1Uploaded ? "Uploaded" : "Upload",
                            style: TextStyle(color: PrimaryColorDark),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    buildImageUploader(
                      width,
                      "Shop to the Exit",
                      onTap: () {
                        common
                            .pickImage(picker: _picker, imageFile: _imageFile2)
                            .then((value) => common
                                    .cropImage(imageFile: value)
                                    .then((value) {
                                  setState(() {
                                    _imageFile2 = value;
                                    isImg2Uploaded = true;
                                  });
                                }));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          isImg2Uploaded
                              ? Icon(
                                  Icons.check,
                                  size: 22,
                                  color: Colors.green,
                                )
                              : Icon(
                                  Icons.cancel,
                                  size: 22,
                                  color: Colors.red,
                                ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            isImg2Uploaded ? "Uploaded" : "Upload",
                            style: TextStyle(color: PrimaryColorDark),
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
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(25),
        child: CustomSolidButton(
          width: width,
          height: 60,
          buttonTextSize: 16,
          text: "Upload Routes",
          onTap: () {
            _dbHelper
                .uploadPic(
              _imageFile1,
              "navigationRoute",
              outletID: _selectedOutletID,
              imgName: "entranceToShop",
            )
                .then((value) {
              _dbHelper
                  .uploadPic(
                _imageFile2,
                "navigationRoute",
                outletID: _selectedOutletID,
                imgName: "shopToExit",
              )
                  .then(
                (value) {
                  common.showToast(context, "Routes uploaded successfully");
                  Navigator.pop(context);
                },
              );
            });
          },
        ),
      ),
    );
  }
}
