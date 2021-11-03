import 'package:beverly_hills_shopping_app/components/custom_drawer.dart';
import 'package:beverly_hills_shopping_app/components/custom_home_container.dart';
import 'package:beverly_hills_shopping_app/components/custom_sliver_app_bar.dart';
import 'package:beverly_hills_shopping_app/screens/admin/admin_pending_promotions_screen.dart';
import 'package:beverly_hills_shopping_app/screens/outlet/outlet_profile_screen.dart';
import 'package:beverly_hills_shopping_app/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({Key key}) : super(key: key);

  @override
  _AdminHomeScreenState createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  final GlobalKey<ScaffoldState> _adminHomeScaffoldKey =
      new GlobalKey<ScaffoldState>();

  List<Color> colors = [
    Colors.red.withOpacity(0.2),
    Colors.yellow.withOpacity(0.2),
    Colors.green.withOpacity(0.2),
    Colors.orange.withOpacity(0.2),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        key: _adminHomeScaffoldKey,
        backgroundColor: SecondaryColorLight,

        /// Build drawer
        drawer: buildDrawer(context, isCustomer: false, isAdmin: true),
        body: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            /// SLiver App bar
            buildSliverAppBar(
              context,
              isCustomer: false,
              onTapDrawer: () {
                _adminHomeScaffoldKey.currentState.openDrawer();
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
                            SizedBox(
                              height: 30,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Hello Admin!",
                                  style: TextStyle(
                                    fontSize: 32.0,
                                    fontWeight: FontWeight.bold,
                                    color: PrimaryColorDark,
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                CustomHomeContainer(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          AdminPendingPromotionsScreen(),
                                    ),
                                  ),
                                  isLeft: true,
                                  title: "Pending Promotions",
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
                                      builder: (_) =>
                                          AdminPendingPromotionsScreen(),
                                    ),
                                  ),
                                  isLeft: false,
                                  title: "View Outlets",
                                  color: colors[3],
                                  iconBgColor: Colors.white.withOpacity(0.8),
                                  icon: FaIcon(
                                    FontAwesomeIcons.building,
                                    size: 22,
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
