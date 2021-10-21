import 'package:beverly_hills_shopping_app/components/custom_drawer.dart';
import 'package:beverly_hills_shopping_app/components/custom_sliver_app_bar.dart';
import 'package:beverly_hills_shopping_app/screens/outlet/outlet_profile_screen.dart';
import 'package:beverly_hills_shopping_app/screens/welcome/welcome.dart';
import 'package:beverly_hills_shopping_app/utils/enums.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OutletHomeScreen extends StatefulWidget {
  const OutletHomeScreen({Key key}) : super(key: key);

  @override
  _OutletHomeScreenState createState() => _OutletHomeScreenState();
}

class _OutletHomeScreenState extends State<OutletHomeScreen> {
  final GlobalKey<ScaffoldState> _outletHomeScaffoldKey =
      new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        key: _outletHomeScaffoldKey,
        backgroundColor: SecondaryColorLight,

        /// Build drawer
        drawer: buildDrawer(context, isCustomer: false),
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
                            StreamBuilder(
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
                                }),
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

  Future<void> _signOut() async {
    isOutletLoggedIn = false;
    await FirebaseAuth.instance.signOut().then((value) {
      Route route = MaterialPageRoute(
        builder: (c) => WelcomeScreen(),
      );
      Navigator.pushReplacement(context, route);
    });
  }
}
