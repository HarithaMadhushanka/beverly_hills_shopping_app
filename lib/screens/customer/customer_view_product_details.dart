import 'package:beverly_hills_shopping_app/components/custom_outline_button.dart';
import 'package:beverly_hills_shopping_app/components/custom_sliver_app_bar_common.dart';
import 'package:beverly_hills_shopping_app/database/db_helper.dart';
import 'package:beverly_hills_shopping_app/models/order.dart';
import 'package:beverly_hills_shopping_app/models/product.dart';
import 'package:beverly_hills_shopping_app/screens/customer/customer_navigation_screen.dart';
import 'package:beverly_hills_shopping_app/screens/customer/customer_view_outlets_details_screen.dart';
import 'package:beverly_hills_shopping_app/utils/common_functions.dart'
    as common;
import 'package:beverly_hills_shopping_app/utils/enums.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomerViewProductDetailsScreen extends StatefulWidget {
  const CustomerViewProductDetailsScreen({Key key, this.product})
      : super(key: key);
  final DocumentSnapshot<Object> product;

  @override
  _CustomerViewProductDetailsScreenState createState() =>
      _CustomerViewProductDetailsScreenState();
}

class _CustomerViewProductDetailsScreenState
    extends State<CustomerViewProductDetailsScreen> {
  var _outlet;
  Product _product = Product();
  DBHelper _dbHelper = DBHelper();

  TextEditingController _quantityTextEditingController =
      TextEditingController();

  @override
  void initState() {
    _product.productTitle = widget.product['productTitle'];
    _product.productPrice = widget.product['productPrice'];
    _product.addedBy = widget.product['addedBy'];
    _product.productPicUrl = widget.product['productPicUrl'];
    _product.productID = widget.product['productID'];
    super.initState();
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
            title: widget.product['productTitle'],
            isTrailingNeeded: false,
          ),
          SliverFillRemaining(
            child: SingleChildScrollView(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Material(
                      elevation: 2,
                      child: Container(
                        width: width,
                        height: height * 0.35,
                        decoration: BoxDecoration(
                          color: SecondaryColorLight,
                          image: DecorationImage(
                            image:
                                NetworkImage(widget.product['productPicUrl']),
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 25),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            widget.product['productTitle'],
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontSize: 24,
                              color: PrimaryColorDark,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "\$" + widget.product['productPrice'] + ".00",
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontSize: 20,
                              color: SecondaryColorDark,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            widget.product['productDesc'],
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontSize: 14,
                              color: PrimaryColorDark,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          CustomOutlineButton(
                            width: width,
                            height: 60,
                            text: "Buy Now",
                            buttonTextSize: 16,
                            onTap: () => _popUpWindow(
                                outletID: _outlet['userID'], product: _product),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Outlet details",
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontSize: 18,
                              color: PrimaryColorDark,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 3),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Sold by :",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: PrimaryColorDark,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    StreamBuilder(
                                        stream: outletCollectionReference
                                            .doc(widget.product['addedBy'])
                                            .snapshots(),
                                        builder: (context, snapshot) {
                                          if (!snapshot.hasData) {
                                            return Text("");
                                          }
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return Text("");
                                          }
                                          _outlet = snapshot.data;
                                          return Text(
                                            _outlet["outletName"],
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: PrimaryColorDark),
                                          );
                                        }),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Email :",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: PrimaryColorDark,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    StreamBuilder(
                                        stream: outletCollectionReference
                                            .doc(widget.product['addedBy'])
                                            .snapshots(),
                                        builder: (context, snapshot) {
                                          if (!snapshot.hasData) {
                                            return Text("");
                                          }
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return Text("");
                                          }
                                          var userDocument = snapshot.data;
                                          return Text(
                                            userDocument["email"],
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: PrimaryColorDark),
                                          );
                                        }),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    CustomerViewOutletsDetailsScreen(
                                        outlet: _outlet),
                              ),
                            ),
                            behavior: HitTestBehavior.opaque,
                            child: Row(
                              children: [
                                Text(
                                  "View Outlet",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: PrimaryColorDark,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 5),
                                  child: Icon(
                                    Icons.arrow_forward,
                                    size: 18,
                                    color: PrimaryColorDark,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CustomerNavigationScreen(
                                  isComingFromDrawer: true,
                                ),
                              ),
                            ),
                            behavior: HitTestBehavior.opaque,
                            child: Row(
                              children: [
                                Text(
                                  "Get directions to the Outlet",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: PrimaryColorDark,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 5),
                                  child: Icon(
                                    Icons.arrow_forward,
                                    size: 18,
                                    color: PrimaryColorDark,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
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

  _popUpWindow({String outletID, Product product}) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(
          "Do you want to buy this product?",
          style: TextStyle(
            color: PrimaryColorDark,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: <Widget>[
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text(
              "Buy",
              style: TextStyle(color: SecondaryColorDark, fontSize: 16),
            ),
            onPressed: () =>
                _popUpWindow2(outletID: outletID, product: product),
          ),
          CupertinoDialogAction(
            child: Text(
              "Cancel",
              style: TextStyle(color: SecondaryColorDark, fontSize: 16),
            ),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );
  }

  _popUpWindow2({String outletID, Product product}) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        content: Card(
          color: Colors.transparent,
          elevation: 2,
          child: Column(
            children: <Widget>[
              TextField(
                controller: _quantityTextEditingController,
                decoration: InputDecoration(
                  labelText: "Quantity",
                  filled: true,
                  fillColor: SecondaryColorLight,
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text(
              "Order",
              style: TextStyle(color: SecondaryColorDark, fontSize: 16),
            ),
            onPressed: () => _buyProduct(
                outletID: outletID,
                product: product,
                purchasedBy: loggedInUserID),
          ),
          CupertinoDialogAction(
            child: Text(
              "Cancel",
              style: TextStyle(color: SecondaryColorDark, fontSize: 16),
            ),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );
  }

  Future<void> _buyProduct(
      {String outletID, Product product, String purchasedBy}) async {
    _dbHelper.sendStatistics(common.getDay(), common.getCurrentHourIn24(),
        type: 'order', id: widget.product['productID'], shouldUpdate: false);

    if (_quantityTextEditingController.text.isNotEmpty) {
      Order _order = Order();
      _order.productTitle = product.productTitle;
      _order.productID = product.productID;
      _order.productPrice = product.productPrice;
      _order.productPicUrl = product.productPicUrl;
      _order.soldBy = product.addedBy;
      _order.purchasedBy = purchasedBy;
      _order.quantity = _quantityTextEditingController.text.trim();
      _order.purchaseTime = DateTime.now().toLocal().toString();
      ;
      _dbHelper.addOrder(_order).then(
            (value) => Future.delayed(Duration(milliseconds: 500), () {
              common.showToast(context, "Product purchased successfully");
              Navigator.pop(context);
              Navigator.pop(context);
            }),
          );
    } else {
      common.showToast(context, "Please enter the quantity to proceed");
    }
  }
}
