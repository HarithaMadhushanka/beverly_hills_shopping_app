import 'package:beverly_hills_shopping_app/screens/admin/admin_pending_promotions_screen.dart';
import 'package:beverly_hills_shopping_app/screens/customer/customer_navigation_screen.dart';
import 'package:beverly_hills_shopping_app/screens/customer/customer_profile_screen.dart';
import 'package:beverly_hills_shopping_app/screens/customer/customer_view_outlets_screen.dart';
import 'package:beverly_hills_shopping_app/screens/customer/customer_view_products_screen.dart';
import 'package:beverly_hills_shopping_app/screens/outlet/outlet_add_products_screen.dart';
import 'package:beverly_hills_shopping_app/screens/outlet/outlet_add_promotions_screen.dart';
import 'package:beverly_hills_shopping_app/screens/outlet/outlet_profile_screen.dart';
import 'package:beverly_hills_shopping_app/screens/outlet/outlet_view_feedbacks_screen.dart';
import 'package:beverly_hills_shopping_app/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Drawer buildDrawer(BuildContext context, {bool isCustomer, bool isAdmin}) {
  return Drawer(
    child: Column(
      children: [
        UserAccountsDrawerHeader(
          accountName: isCustomer && loggedInUserID != "" && isAdmin == false
              ? StreamBuilder(
                  stream: customerCollectionReference
                      .doc(loggedInUserID)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Text("");
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text("");
                    }
                    var userDocument = snapshot.data;
                    return Text(
                      userDocument["firstName"] +
                          " " +
                          userDocument["lastName"],
                      style:
                          TextStyle(fontSize: 18, color: SecondaryColorLight),
                    );
                  })
              : !isCustomer && loggedInUserID != "" && isAdmin == false
                  ? StreamBuilder(
                      stream: outletCollectionReference
                          .doc(loggedInUserID)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Text("");
                        }
                        if (snapshot.hasError) {
                          return Text("");
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Text("");
                        }
                        var userDocument = snapshot.data;
                        return Text(
                          userDocument["outletName"],
                          style: TextStyle(
                              fontSize: 18, color: SecondaryColorLight),
                        );
                      })
                  : Container(),
          accountEmail: loggedInUserID != ""
              ? StreamBuilder(
                  stream: isCustomer
                      ? customerCollectionReference
                          .doc(loggedInUserID)
                          .snapshots()
                      : outletCollectionReference
                          .doc(loggedInUserID)
                          .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Text("");
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text("");
                    }
                    var userDocument = snapshot.data;
                    return Text(
                      userDocument["email"],
                      style:
                          TextStyle(fontSize: 14, color: SecondaryColorLight),
                    );
                  })
              : Container(),
          currentAccountPicture: loggedInUserID != ""
              ? StreamBuilder(
                  stream: isCustomer
                      ? customerCollectionReference
                          .doc(loggedInUserID)
                          .snapshots()
                      : outletCollectionReference
                          .doc(loggedInUserID)
                          .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: PrimaryColorDark, width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            'images/user.png',
                            height: 35,
                            width: 35,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: PrimaryColorDark, width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            'images/user.png',
                            height: 35,
                            width: 35,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      );
                    }
                    var userDocument = snapshot.data;
                    return GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => isCustomer
                              ? CustomerProfileScreen()
                              : OutletProfileScreen(),
                        ),
                      ),
                      behavior: HitTestBehavior.opaque,
                      child: ClipOval(
                        child: Image.network(
                          userDocument["profilePicUrl"],
                          height: 35,
                          width: 35,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    );
                  })
              : Container(),
        ),
        ListTile(
          leading: Padding(
            padding: const EdgeInsets.only(left: 5),
            child: FaIcon(
              FontAwesomeIcons.home,
              size: 25,
              color: PrimaryColorDark,
            ),
          ),
          title: const Text(
            'Home',
            style: TextStyle(
              fontSize: 16,
              color: PrimaryColorDark,
              fontWeight: FontWeight.w400,
            ),
          ),
          onTap: () => Navigator.pop(context),
        ),
        !isAdmin
            ? ListTile(
                leading: Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: FaIcon(
                    isCustomer && !isAdmin
                        ? FontAwesomeIcons.searchLocation
                        : FontAwesomeIcons.percentage,
                    size: 25,
                    color: PrimaryColorDark,
                  ),
                ),
                title: Text(
                  isCustomer && !isAdmin ? 'Navigation' : 'Add Promotions',
                  style: TextStyle(
                    fontSize: 16,
                    color: PrimaryColorDark,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => isCustomer && !isAdmin
                          ? CustomerNavigationScreen()
                          : OutletAddPromotionsScreen(),
                    ),
                  );
                },
              )
            : Container(),
        !isAdmin
            ? ListTile(
                leading: Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: FaIcon(
                    FontAwesomeIcons.shoppingBag,
                    size: 25,
                    color: PrimaryColorDark,
                  ),
                ),
                title: Text(
                  isCustomer && !isAdmin ? 'Products' : 'Add Products',
                  style: TextStyle(
                    fontSize: 16,
                    color: PrimaryColorDark,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => isCustomer && !isAdmin
                          ? CustomerViewProductsScreen()
                          : OutletAddProductsScreen(),
                    ),
                  );
                },
              )
            : Container(),
        !isAdmin
            ? ListTile(
                leading: Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: FaIcon(
                    isCustomer && !isAdmin
                        ? FontAwesomeIcons.building
                        : FontAwesomeIcons.star,
                    size: 25,
                    color: PrimaryColorDark,
                  ),
                ),
                title: Text(
                  isCustomer && !isAdmin ? 'Outlets' : 'Feedbacks',
                  style: TextStyle(
                    fontSize: 16,
                    color: PrimaryColorDark,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => isCustomer && !isAdmin
                          ? CustomerViewOutletsScreen()
                          : OutletViewFeedbacksScreen(),
                    ),
                  );
                },
              )
            : Container(),
        !isCustomer && isAdmin
            ? ListTile(
                leading: Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: FaIcon(
                    FontAwesomeIcons.percentage,
                    size: 25,
                    color: PrimaryColorDark,
                  ),
                ),
                title: Text(
                  'Pending Promotions',
                  style: TextStyle(
                    fontSize: 16,
                    color: PrimaryColorDark,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AdminPendingPromotionsScreen(),
                    ),
                  );
                },
              )
            : Container(),
        !isCustomer && isAdmin
            ? ListTile(
                leading: Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: FaIcon(
                    FontAwesomeIcons.building,
                    size: 25,
                    color: PrimaryColorDark,
                  ),
                ),
                title: Text(
                  'View Outlets',
                  style: TextStyle(
                    fontSize: 16,
                    color: PrimaryColorDark,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AdminPendingPromotionsScreen(),
                    ),
                  );
                },
              )
            : Container(),
      ],
    ),
  );
}
