import 'dart:io';

import 'package:beverly_hills_shopping_app/components/custom_description_box.dart';
import 'package:beverly_hills_shopping_app/components/custom_outline_button.dart';
import 'package:beverly_hills_shopping_app/components/custom_sliver_app_bar_common.dart';
import 'package:beverly_hills_shopping_app/components/custom_text_field.dart';
import 'package:beverly_hills_shopping_app/database/db_helper.dart';
import 'package:beverly_hills_shopping_app/models/product.dart';
import 'package:beverly_hills_shopping_app/utils/common_functions.dart'
    as common;
import 'package:beverly_hills_shopping_app/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class OutletAddProductsScreen extends StatefulWidget {
  const OutletAddProductsScreen({Key key}) : super(key: key);

  @override
  _OutletAddProductsScreenState createState() =>
      _OutletAddProductsScreenState();
}

class _OutletAddProductsScreenState extends State<OutletAddProductsScreen> {
  final ImagePicker _picker = ImagePicker();
  File _imageFile;
  String _pickedImageFilePath = "";
  DBHelper _dbHelper = DBHelper();

  TextEditingController _productTitleController = TextEditingController();
  TextEditingController _productPriceController = TextEditingController();
  TextEditingController _productDescController = TextEditingController();

  String _selectedProductCategory;

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
            title: 'Add Products',
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
                    CustomTextField(
                      controller: _productTitleController,
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
                    CustomTextField(
                      controller: _productPriceController,
                      height: 60,
                      width: width,
                      hintText: 'Product Price',
                      icon: Icons.list_alt,
                      iconSize: 22,
                      textInputType: TextInputType.number,
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
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(top: 10),
                          hintText: 'Please select a category',
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          icon: Padding(
                            padding: const EdgeInsets.only(left: 20, top: 10),
                            child: Icon(
                              Icons.list,
                              size: 22,
                              color: SecondaryColorDark,
                            ),
                          ),
                        ),
                        value: _selectedProductCategory,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedProductCategory = newValue;
                          });
                        },
                        items: productCategories.map((category) {
                          return DropdownMenuItem(
                            child: new Text(category),
                            value: category,
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    CustomDescriptionBox(
                      width: width,
                      height: height,
                      controller: _productDescController,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    CustomOutlineButton(
                      width: width,
                      height: 60,
                      text: "Add Product",
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
    if (_productTitleController.text.isNotEmpty &&
        _productPriceController.text.isNotEmpty &&
        _productDescController.text.isNotEmpty &&
        _selectedProductCategory != null) {
      Product product = Product();
      product.productTitle = _productTitleController.text;
      product.productPrice = _productPriceController.text;
      product.productDesc = _productDescController.text;
      product.productCategory = _selectedProductCategory;
      product.addedBy = loggedInUserID;
      product.addedTime = DateTime.now().toLocal().toString();

      String _productID = await _dbHelper.uploadPic(_imageFile, "product");

      _dbHelper.updateProductDetails(_productID, product).whenComplete(() {
        common.showToast(context, "Product updated");
        Future.delayed(Duration(seconds: 1), () {
          Navigator.pop(context);
        });
      });
    } else {
      common.showToast(context, "Please fill in all the fields");
    }
  }
}
