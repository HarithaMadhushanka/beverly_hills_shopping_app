import 'package:beverly_hills_shopping_app/screens/customer/customer_home_screen.dart';
import 'package:beverly_hills_shopping_app/screens/customer/customer_navigation_screen.dart';
import 'package:beverly_hills_shopping_app/screens/customer/customer_view_outlets_screen.dart';
import 'package:beverly_hills_shopping_app/screens/customer/customer_view_products_screen.dart';
import 'package:beverly_hills_shopping_app/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomerDashboard extends StatefulWidget {
  const CustomerDashboard({Key key}) : super(key: key);

  @override
  _CustomerDashboardState createState() => _CustomerDashboardState();
}

class _CustomerDashboardState extends State<CustomerDashboard> {
  int _currentIndex = 0;

  final List _children = [
    CustomerHomeScreen(),
    CustomerNavigationScreen(),
    CustomerViewProductsScreen(),
    CustomerViewOutletsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        backgroundColor: SecondaryColorLight,
        body: _children[_currentIndex],
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(10), topLeft: Radius.circular(10)),
            boxShadow: [
              BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 5),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            child: BottomNavigationBar(
              backgroundColor: SecondaryColorLight,
              onTap: onTabTapped,
              currentIndex: _currentIndex,
              items: [
                BottomNavigationBarItem(
                  icon: FaIcon(
                    FontAwesomeIcons.home,
                    size: 25,
                    color: PrimaryColorDark,
                  ),
                  activeIcon: FaIcon(
                    FontAwesomeIcons.home,
                    size: 25,
                    color: SecondaryColorDark,
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: FaIcon(
                    FontAwesomeIcons.searchLocation,
                    size: 25,
                    color: PrimaryColorDark,
                  ),
                  activeIcon: FaIcon(
                    FontAwesomeIcons.searchLocation,
                    size: 25,
                    color: SecondaryColorDark,
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: FaIcon(
                    FontAwesomeIcons.shoppingBag,
                    size: 25,
                    color: PrimaryColorDark,
                  ),
                  activeIcon: FaIcon(
                    FontAwesomeIcons.shoppingBag,
                    size: 25,
                    color: SecondaryColorDark,
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: FaIcon(
                    FontAwesomeIcons.building,
                    size: 25,
                    color: PrimaryColorDark,
                  ),
                  activeIcon: FaIcon(
                    FontAwesomeIcons.building,
                    size: 25,
                    color: SecondaryColorDark,
                  ),
                  label: '',
                )
              ],
            ),
          ),
        ),
      ),
      onWillPop: _onWillPop,
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Future<bool> _onWillPop() async {
    return Future.value(false);
  }
}
