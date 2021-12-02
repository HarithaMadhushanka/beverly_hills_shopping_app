import 'package:beverly_hills_shopping_app/components/custom_drawer.dart';
import 'package:beverly_hills_shopping_app/components/custom_home_container.dart';
import 'package:beverly_hills_shopping_app/components/custom_sliver_app_bar.dart';
import 'package:beverly_hills_shopping_app/database/db_helper.dart';
import 'package:beverly_hills_shopping_app/screens/outlet/outlet_add_products_screen.dart';
import 'package:beverly_hills_shopping_app/screens/outlet/outlet_add_promotions_screen.dart';
import 'package:beverly_hills_shopping_app/screens/outlet/outlet_profile_screen.dart';
import 'package:beverly_hills_shopping_app/screens/outlet/outlet_view_feedbacks_screen.dart';
import 'package:beverly_hills_shopping_app/screens/outlet/outlet_view_orders.dart';
import 'package:beverly_hills_shopping_app/utils/common_functions.dart'
    as common;
import 'package:beverly_hills_shopping_app/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class OutletHomeScreen extends StatefulWidget {
  const OutletHomeScreen({Key key}) : super(key: key);

  @override
  _OutletHomeScreenState createState() => _OutletHomeScreenState();
}

class _OutletHomeScreenState extends State<OutletHomeScreen> {
  final GlobalKey<ScaffoldState> _outletHomeScaffoldKey =
      new GlobalKey<ScaffoldState>();
  DBHelper _dbHelper = DBHelper();

  @override
  void initState() {
    _dbHelper.sendStatistics(common.getDay(), common.getCurrentHourIn24(),
        shouldUpdate: false);
    super.initState();
  }

  @override
  void dispose() {
    customerCollectionReference.doc(loggedInUserID).snapshots();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    List<Color> colors = [
      Colors.red.withOpacity(0.2),
      Colors.yellow.withOpacity(0.2),
      Colors.green.withOpacity(0.2),
      Colors.orange.withOpacity(0.2),
    ];

    return WillPopScope(
      child: Scaffold(
        key: _outletHomeScaffoldKey,
        backgroundColor: SecondaryColorLight,

        /// Build drawer
        drawer: buildDrawer(context, isCustomer: false, isAdmin: false),
        body: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            /// SLiver App bar
            buildSliverAppBar(
              context,
              isCustomer: false,
              onTapDrawer: () {
                _outletHomeScaffoldKey.currentState.openDrawer();
              },
              onTapProfile: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => OutletProfileScreen(),
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
                                    stream: outletCollectionReference
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
                                        userDocument["outletName"] + "...",
                                        style: TextStyle(
                                          fontSize: 32.0,
                                          fontWeight: FontWeight.bold,
                                          color: PrimaryColorDark,
                                        ),
                                      );
                                    })
                                : Container(),
                            Text(
                              "What do we do today?",
                              style: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.w200,
                                color: PrimaryColorDark,
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomHomeContainer(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          OutletAddPromotionsScreen(),
                                    ),
                                  ),
                                  isLeft: true,
                                  title: "Add Promotions",
                                  color: colors[0],
                                  iconBgColor: Colors.white.withOpacity(0.8),
                                  icon: FaIcon(
                                    FontAwesomeIcons.percentage,
                                    size: 22,
                                    color: PrimaryColorDark,
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                CustomHomeContainer(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => OutletAddProductsScreen(),
                                    ),
                                  ),
                                  isLeft: false,
                                  title: "Add Products",
                                  color: colors[1],
                                  iconBgColor: Colors.white.withOpacity(0.8),
                                  icon: FaIcon(
                                    FontAwesomeIcons.shoppingBag,
                                    size: 25,
                                    color: PrimaryColorDark,
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                CustomHomeContainer(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => OutletViewOrdersScreen(),
                                    ),
                                  ),
                                  isLeft: true,
                                  title: "View Orders",
                                  color: colors[2],
                                  iconBgColor: Colors.white.withOpacity(0.8),
                                  icon: FaIcon(
                                    FontAwesomeIcons.list,
                                    size: 20,
                                    color: PrimaryColorDark,
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                CustomHomeContainer(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          OutletViewFeedbacksScreen(),
                                    ),
                                  ),
                                  isLeft: false,
                                  title: "Feedbacks",
                                  color: colors[3],
                                  iconBgColor: Colors.white.withOpacity(0.8),
                                  icon: FaIcon(
                                    FontAwesomeIcons.star,
                                    size: 20,
                                    color: PrimaryColorDark,
                                  ),
                                ),
                              ],
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
      ),
      onWillPop: _onWillPop,
    );
  }

  Future<bool> _onWillPop() async {
    return Future.value(false);
  }
}
