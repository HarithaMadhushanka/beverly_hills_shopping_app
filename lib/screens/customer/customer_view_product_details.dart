import 'package:beverly_hills_shopping_app/components/custom_outline_button.dart';
import 'package:beverly_hills_shopping_app/components/custom_sliver_app_bar_common.dart';
import 'package:beverly_hills_shopping_app/screens/customer/customer_navigation_screen.dart';
import 'package:beverly_hills_shopping_app/screens/customer/customer_view_outlets_details_screen.dart';
import 'package:beverly_hills_shopping_app/utils/enums.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var _outlet;

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
                            onTap: () {},
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
}
