import 'package:beverly_hills_shopping_app/components/custom_drawer.dart';
import 'package:beverly_hills_shopping_app/components/custom_sliver_app_bar.dart';
import 'package:beverly_hills_shopping_app/components/product_component.dart';
import 'package:beverly_hills_shopping_app/components/promotions_component.dart';
import 'package:beverly_hills_shopping_app/screens/customer/customer_profile_screen.dart';
import 'package:beverly_hills_shopping_app/screens/customer/customer_view_product_details.dart';
import 'package:beverly_hills_shopping_app/screens/customer/customer_view_products_screen.dart';
import 'package:beverly_hills_shopping_app/utils/enums.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'customer_view_promotion_details_screen.dart';
import 'customer_view_promotions_screen.dart';

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({Key key}) : super(key: key);

  @override
  _CustomerHomeScreenState createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  final GlobalKey<ScaffoldState> _customerHomeScaffoldKey =
      new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return WillPopScope(
      child: Scaffold(
        key: _customerHomeScaffoldKey,
        backgroundColor: SecondaryColorLight,

        /// Build drawer
        drawer: buildDrawer(context, isCustomer: true, isAdmin: false),
        body: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            /// SLiver App bar
            buildSliverAppBar(
              context,
              isCustomer: true,
              onTapDrawer: () {
                _customerHomeScaffoldKey.currentState.openDrawer();
              },
              onTapProfile: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CustomerProfileScreen(),
                  ),
                );
              },
            ),
            SliverFillRemaining(
              child: SingleChildScrollView(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            loggedInUserID != ""
                                ? StreamBuilder(
                                    stream: customerCollectionReference
                                        .doc(loggedInUserID)
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
                                        "Hi" + " " + userDocument["firstName"],
                                        style: TextStyle(
                                          fontSize: 32.0,
                                          fontWeight: FontWeight.bold,
                                          color: PrimaryColorDark,
                                        ),
                                      );
                                    })
                                : Container(),
                            Text(
                              "What are you looking\nfor today?",
                              style: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.w200,
                                color: PrimaryColorDark,
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                          ],
                        ),
                      ),

                      /// Promotions carousal
                      Padding(
                        padding: EdgeInsets.only(left: 25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Promotions",
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    color: PrimaryColorDark,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              CustomerViewPromotionsScreen(),
                                        ),
                                      ),
                                      child: Text(
                                        "View More",
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w400,
                                          color: PrimaryColorDark,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.28,
                              child: StreamBuilder(
                                  stream: promotionsCollectionReference
                                      .where('isApproved', isEqualTo: true)
                                      .orderBy('promoAddedTime',
                                          descending: true)
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) return Text("");
                                    return ListView.builder(
                                      physics: const BouncingScrollPhysics(
                                          parent:
                                              AlwaysScrollableScrollPhysics()),
                                      scrollDirection: Axis.horizontal,
                                      itemCount: snapshot.data.docs.length < 5
                                          ? snapshot.data.docs.length
                                          : 5,
                                      itemBuilder: (context, index) {
                                        DocumentSnapshot promotion =
                                            snapshot.data.docs[index];

                                        return PromotionsComponent(
                                          imagePath: promotion['promoPicUrl'],
                                          onTap: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  CustomerViewPromotionDetailsScreen(
                                                promotion: promotion,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }),
                            ),
                          ],
                        ),
                      ),

                      /// Products list
                      Padding(
                        padding: EdgeInsets.only(left: 25, right: 25, top: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Recent Products",
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    color: PrimaryColorDark,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          CustomerViewProductsScreen(
                                              isComingFromDrawer: true),
                                    ),
                                  ),
                                  child: Text(
                                    "View All",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w400,
                                      color: PrimaryColorDark,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SingleChildScrollView(
                              physics: ScrollPhysics(),
                              child: Container(
                                margin: EdgeInsets.only(bottom: 30),
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.height * 0.865,
                                child: StreamBuilder(
                                    stream: productCollectionReference
                                        .orderBy('addedTime', descending: true)
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData) return Text("");
                                      return ListView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: snapshot.data.docs.length < 5
                                            ? snapshot.data.docs.length
                                            : 5,
                                        itemBuilder: (context, index) {
                                          DocumentSnapshot product =
                                              snapshot.data.docs[index];

                                          return GestureDetector(
                                            onTap: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    CustomerViewProductDetailsScreen(
                                                  product: product,
                                                ),
                                              ),
                                            ),
                                            behavior: HitTestBehavior.opaque,
                                            child: PopularPlacesWidget(
                                              imagePath:
                                                  product['productPicUrl'],
                                              title: product['productTitle'],
                                              subtitle: product['productDesc'],
                                              price: "\$ " +
                                                  product['productPrice'] +
                                                  ".00",
                                            ),
                                          );
                                        },
                                      );
                                    }),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      onWillPop: _onWillPop,
    );
  }

  Future<bool> _onWillPop() async {
    return Future.value(false);
  }
}
