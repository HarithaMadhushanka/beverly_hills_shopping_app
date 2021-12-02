import 'package:beverly_hills_shopping_app/components/custom_sliver_app_bar_common.dart';
import 'package:beverly_hills_shopping_app/database/db_helper.dart';
import 'package:beverly_hills_shopping_app/utils/common_functions.dart'
    as common;
import 'package:beverly_hills_shopping_app/utils/enums.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OutletViewOrdersScreen extends StatefulWidget {
  const OutletViewOrdersScreen({Key key}) : super(key: key);

  @override
  _OutletViewOrdersScreenState createState() => _OutletViewOrdersScreenState();
}

class _OutletViewOrdersScreenState extends State<OutletViewOrdersScreen> {
  DBHelper _dbHelper = DBHelper();

  @override
  Widget build(BuildContext context) {
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
            title: 'View Orders',
            isTrailingNeeded: false,
          ),
          SliverFillRemaining(
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    StreamBuilder<QuerySnapshot>(
                        stream: orderCollectionReference
                            .where('soldBy', isEqualTo: loggedInUserID)
                            .orderBy('purchaseTime', descending: false)
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData) return Text("");
                          return Container(
                            height: height * 0.85,
                            child: ListView.builder(
                              physics: const BouncingScrollPhysics(
                                  parent: AlwaysScrollableScrollPhysics()),
                              scrollDirection: Axis.vertical,
                              itemCount: snapshot.data.docs.length,
                              itemBuilder: (context, index) {
                                DocumentSnapshot order =
                                    snapshot.data.docs[index];

                                return Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () =>
                                          _popUpWindow(order['orderID']),
                                      behavior: HitTestBehavior.opaque,
                                      child: Container(
                                        height: 120,
                                        decoration: BoxDecoration(
                                          color: PrimaryColorLight,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          border: Border.all(
                                              color: PrimaryColorDark),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              10, 10, 10, 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    right: 10),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  border: Border.all(
                                                      color: PrimaryColorDark),
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: Container(
                                                    height: 90,
                                                    width: 70,
                                                    child: Image.network(
                                                      order["productPicUrl"],
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      height: 2,
                                                    ),
                                                    StreamBuilder(
                                                        stream: order[
                                                                    "purchasedBy"] !=
                                                                null
                                                            ? customerCollectionReference
                                                                .doc(order[
                                                                    "purchasedBy"])
                                                                .snapshots()
                                                            : null,
                                                        builder: (context,
                                                            snapshot) {
                                                          if (!snapshot
                                                              .hasData) {
                                                            return Text("");
                                                          }
                                                          if (snapshot
                                                              .hasError) {
                                                            return Text("");
                                                          }
                                                          if (snapshot
                                                                  .connectionState ==
                                                              ConnectionState
                                                                  .waiting) {
                                                            return Text("");
                                                          }
                                                          var user =
                                                              snapshot.data;
                                                          return Text(
                                                            user["firstName"] +
                                                                " " +
                                                                user[
                                                                    "lastName"],
                                                            style: TextStyle(
                                                              color:
                                                                  PrimaryColorDark,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 18,
                                                            ),
                                                          );
                                                        }),
                                                    Text(
                                                      order["productTitle"],
                                                      style: TextStyle(
                                                        color: PrimaryColorDark,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                    Spacer(),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "Quantity: " +
                                                              order["quantity"],
                                                          style: TextStyle(
                                                            color:
                                                                PrimaryColorDark,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 14,
                                                          ),
                                                          textAlign:
                                                              TextAlign.justify,
                                                        ),
                                                        Text(
                                                          "\$ " +
                                                              (int.parse(order[
                                                                          "productPrice"]) *
                                                                      int.parse(
                                                                          order[
                                                                              "quantity"]))
                                                                  .toString() +
                                                              ".00",
                                                          style: TextStyle(
                                                            color:
                                                                PrimaryColorDark,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 14,
                                                          ),
                                                          textAlign:
                                                              TextAlign.justify,
                                                        ),
                                                      ],
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                  ],
                                );
                              },
                            ),
                          );
                        }),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  _popUpWindow(String orderID) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(
          "Have you shipped this product?",
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
              "Yes",
              style: TextStyle(color: SecondaryColorDark, fontSize: 16),
            ),
            onPressed: () => _completeOrder(orderID),
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

  Future _completeOrder(String _orderID) async {
    _dbHelper.completeOrder(_orderID).then(
          (value) => Future.delayed(Duration(milliseconds: 100), () {
            Navigator.pop(context);
            common.showToast(context, "Order completed!");
          }),
        );
  }
}
