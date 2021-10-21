import 'package:beverly_hills_shopping_app/components/custom_outline_button.dart';
import 'package:beverly_hills_shopping_app/components/custom_solid_button.dart';
import 'package:beverly_hills_shopping_app/screens/admin/admin_login_screen.dart';
import 'package:beverly_hills_shopping_app/screens/customer/customer_login_screen.dart';
import 'package:beverly_hills_shopping_app/utils/enums.dart';
import 'package:flutter/material.dart';

import '../outlet/outlet_login_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: PrimaryColorLight,
      body: SingleChildScrollView(
        child: Container(
          height: height,
          margin: EdgeInsets.only(left: 20, right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AdminLoginScreen(),
                      ),
                    );
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Text(
                    "Admin >>",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: PrimaryColorDark,
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 30),
                height: 85,
                width: width,
                child: Image.asset(
                  'images/logo_new.png',
                  height: 90,
                ),
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 20),
                  width: width * 0.8,
                  child: Image.asset('images/welcome_bg_new.png'),
                ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        "Welcome",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: PrimaryColorDark,
                        ),
                      ),
                      Text(
                        "To Beverly Hills Shopping Mall App",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w100,
                            color: PrimaryColorDark),
                      ),
                    ],
                  ),
                ),
              ),
              CustomSolidButton(
                width: width,
                height: 60,
                text: "Customer",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CustomerLoginScreen(),
                    ),
                  );
                },
              ),
              SizedBox(
                height: 10,
              ),
              CustomOutlineButton(
                width: width,
                height: 60,
                text: "Outlet",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => OutletLoginScreen(),
                    ),
                  );
                },
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
