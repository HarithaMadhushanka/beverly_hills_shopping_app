import 'package:beverly_hills_shopping_app/components/custom_solid_button.dart';
import 'package:beverly_hills_shopping_app/database/db_helper.dart';
import 'package:beverly_hills_shopping_app/utils/common_functions.dart'
    as common;
import 'package:beverly_hills_shopping_app/utils/enums.dart';
import 'package:flutter/material.dart';

import 'admin_home_screen.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({Key key}) : super(key: key);

  @override
  _AdminLoginScreenState createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  bool isHidden = true;
  TextEditingController adminLoginEmailController = TextEditingController();
  TextEditingController adminLoginPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: SecondaryColorLight,
      appBar: AppBar(
        backgroundColor: SecondaryColorLight,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: Image.asset(
              'images/back_arrow.png',
              scale: 1.2,
              color: PrimaryColorDark,
            ),
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                "Hello Admin!",
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: PrimaryColorDark,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 50),
              child: Container(
                height: 60,
                width: width,
                decoration: BoxDecoration(
                  border: Border.all(color: PrimaryColorDark),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextFormField(
                  controller: adminLoginEmailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(top: 10),
                    hintText: "Email",
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    icon: Padding(
                      padding: const EdgeInsets.only(left: 20, top: 10),
                      child: Icon(
                        Icons.email,
                        color: SecondaryColorDark,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Container(
                height: 60,
                width: width,
                decoration: BoxDecoration(
                  border: Border.all(color: PrimaryColorDark),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20, top: 0),
                      child: Icon(
                        Icons.lock,
                        color: SecondaryColorDark,
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: adminLoginPasswordController,
                        obscureText: isHidden,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 20),
                          hintText: "Password",
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10, top: 5),
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            isHidden = !isHidden;
                          });
                        },
                        icon: Icon(
                          isHidden ? Icons.visibility_off : Icons.visibility,
                          color: SecondaryColorDark,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 15),
            child: CustomSolidButton(
              width: width,
              height: 60,
              text: "Sign in",
              onTap: () {
                _confirmAndLoginAdmin();
              },
            ),
          ),
        ],
      ),
    );
  }

  void _confirmAndLoginAdmin() {
    adminLoginEmailController.text.isNotEmpty &&
            adminLoginPasswordController.text.isNotEmpty
        ? _loginAdmin()
        : common.showToast(context, "Please fill all the fields");
  }

  void _loginAdmin() async {
    List<String> adminCredentials = [];

    adminCredentials = await DBHelper().getAdminCredentials();
    print(adminCredentials);
    if (adminCredentials[0] == adminLoginEmailController.text &&
        adminCredentials[1] == adminLoginPasswordController.text) {
      Route route = MaterialPageRoute(builder: (c) => AdminHomeScreen());
      Navigator.pushReplacement(context, route);
    } else {
      common.showToast(context, "Please try again");
    }
  }
}
