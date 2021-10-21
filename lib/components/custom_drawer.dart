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

Drawer buildDrawer(BuildContext context, {bool isCustomer}) {
  return Drawer(
    child: Column(
      children: [
        UserAccountsDrawerHeader(
          accountName: isCustomer
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
              : StreamBuilder(
                  stream:
                      outletCollectionReference.doc(loggedInUserID).snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Text("");
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text("");
                    }
                    var userDocument = snapshot.data;
                    return Text(
                      userDocument["outletName"],
                      style:
                          TextStyle(fontSize: 18, color: SecondaryColorLight),
                    );
                  }),
          accountEmail: StreamBuilder(
              stream: isCustomer
                  ? customerCollectionReference.doc(loggedInUserID).snapshots()
                  : outletCollectionReference.doc(loggedInUserID).snapshots(),
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
                  style: TextStyle(fontSize: 14, color: SecondaryColorLight),
                );
              }),
          currentAccountPicture: StreamBuilder(
              stream: isCustomer
                  ? customerCollectionReference.doc(loggedInUserID).snapshots()
                  : outletCollectionReference.doc(loggedInUserID).snapshots(),
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
              }),
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
        ListTile(
          leading: Padding(
            padding: const EdgeInsets.only(left: 5),
            child: FaIcon(
              isCustomer
                  ? FontAwesomeIcons.searchLocation
                  : FontAwesomeIcons.percentage,
              size: 25,
              color: PrimaryColorDark,
            ),
          ),
          title: Text(
            isCustomer ? 'Navigation' : 'Add Promotions',
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
                builder: (_) => isCustomer
                    ? CustomerNavigationScreen()
                    : OutletAddPromotionsScreen(),
              ),
            );
          },
        ),
        ListTile(
          leading: Padding(
            padding: const EdgeInsets.only(left: 5),
            child: FaIcon(
              FontAwesomeIcons.shoppingBag,
              size: 25,
              color: PrimaryColorDark,
            ),
          ),
          title: Text(
            isCustomer ? 'Products' : 'Add Products',
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
                builder: (_) => isCustomer
                    ? CustomerViewProductsScreen()
                    : OutletAddProductsScreen(),
              ),
            );
          },
        ),
        ListTile(
          leading: Padding(
            padding: const EdgeInsets.only(left: 5),
            child: FaIcon(
              isCustomer ? FontAwesomeIcons.building : FontAwesomeIcons.star,
              size: 25,
              color: PrimaryColorDark,
            ),
          ),
          title: Text(
            isCustomer ? 'Outlets' : 'Feedbacks',
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
                builder: (_) => isCustomer
                    ? CustomerViewOutletsScreen()
                    : OutletViewFeedbacksScreen(),
              ),
            );
          },
        ),
      ],
    ),
  );
}
