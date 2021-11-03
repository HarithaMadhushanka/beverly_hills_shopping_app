import 'dart:io';

import 'package:beverly_hills_shopping_app/components/custom_description_box.dart';
import 'package:beverly_hills_shopping_app/components/custom_outline_button.dart';
import 'package:beverly_hills_shopping_app/components/custom_sliver_app_bar_common.dart';
import 'package:beverly_hills_shopping_app/components/custom_text_field.dart';
import 'package:beverly_hills_shopping_app/database/db_helper.dart';
import 'package:beverly_hills_shopping_app/models/promotion.dart';
import 'package:beverly_hills_shopping_app/utils/common_functions.dart'
    as common;
import 'package:beverly_hills_shopping_app/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class OutletAddPromotionsScreen extends StatefulWidget {
  const OutletAddPromotionsScreen({Key key}) : super(key: key);

  @override
  _OutletAddPromotionsScreenState createState() =>
      _OutletAddPromotionsScreenState();
}

class _OutletAddPromotionsScreenState extends State<OutletAddPromotionsScreen> {
  final ImagePicker _picker = ImagePicker();
  File _imageFile;
  String _pickedImageFilePath = "";
  DBHelper _dbHelper = DBHelper();

  TextEditingController _startingDateController = TextEditingController();
  TextEditingController _endingDateController = TextEditingController();
  TextEditingController _promotionTitleController = TextEditingController();
  TextEditingController _promotionDescController = TextEditingController();

  String selectedDate = "";

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
            title: 'Add Promotions',
            isTrailingNeeded: false,
          ),
          SliverFillRemaining(
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 25),
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
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        width: width,
                        height: height * 0.3,
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: _pickedImageFilePath != ""
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  File(_pickedImageFilePath),
                                  fit: BoxFit.fitHeight,
                                ),
                              )
                            : Image.asset('images/stock_img_1.png'),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    GestureDetector(
                      onTap: () async {
                        selectedDate =
                            await common.selectDate(context, "start");
                        setState(() {
                          if (selectedDate != null && selectedDate != "")
                            _startingDateController.text = selectedDate;
                        });
                      },
                      behavior: HitTestBehavior.opaque,
                      child: CustomTextField(
                        controller: _startingDateController,
                        enabled: false,
                        height: 60,
                        width: width,
                        hintText: 'Start Date',
                        icon: Icons.calendar_today,
                        iconSize: 22,
                        textInputType: TextInputType.text,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (_startingDateController.text.isEmpty) {
                          common.showToast(
                              context, "Please select the start date first");
                        } else {
                          selectedDate =
                              await common.selectDate(context, "end");
                          setState(() {
                            if (selectedDate != null && selectedDate != "")
                              _endingDateController.text = selectedDate;
                          });
                        }
                      },
                      behavior: HitTestBehavior.opaque,
                      child: CustomTextField(
                        controller: _endingDateController,
                        enabled: false,
                        height: 60,
                        width: width,
                        hintText: 'End Date',
                        icon: Icons.calendar_today,
                        iconSize: 22,
                        textInputType: TextInputType.text,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    CustomTextField(
                      controller: _promotionTitleController,
                      height: 60,
                      width: width,
                      hintText: 'Title',
                      icon: Icons.list_alt,
                      iconSize: 22,
                      textInputType: TextInputType.text,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    CustomDescriptionBox(
                      width: width,
                      height: height,
                      controller: _promotionDescController,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    CustomOutlineButton(
                      width: width,
                      height: 60,
                      text: "Add Promotion",
                      buttonTextSize: 16,
                      onTap: () => _onClicked(),
                    ),
                    SizedBox(
                      height: 30,
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

  void _onClicked() async {
    if (_startingDateController.text.isNotEmpty &&
        _endingDateController.text.isNotEmpty &&
        _promotionTitleController.text.isNotEmpty &&
        _promotionDescController.text.isNotEmpty) {
      Promotion promotion = Promotion();
      promotion.promoStartingDate = _startingDateController.text;
      promotion.promoEndingDate = _endingDateController.text;
      promotion.promoTitle = _promotionTitleController.text;
      promotion.promoDesc = _promotionDescController.text;
      promotion.promoAddedTime = DateTime.now().toLocal().toString();

      String _promoID = await _dbHelper.uploadPic(_imageFile, "promotion");

      _dbHelper.updatePromoDetails(_promoID, promotion).whenComplete(() {
        common.showToast(
            context, "Promotion updated and waiting to be approved by Admin");
        Future.delayed(Duration(seconds: 1), () {
          Navigator.pop(context);
        });
      });
    } else {
      common.showToast(context, "Please fill in all the fields");
    }
  }
}
