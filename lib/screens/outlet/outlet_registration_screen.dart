import 'package:beverly_hills_shopping_app/common_functions.dart' as common;
import 'package:beverly_hills_shopping_app/components/custom_solid_button.dart';
import 'package:beverly_hills_shopping_app/database/db_helper.dart';
import 'package:beverly_hills_shopping_app/screens/outlet/outlet_login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../enums.dart';

class OutletRegistrationScreen extends StatefulWidget {
  const OutletRegistrationScreen({Key key}) : super(key: key);

  @override
  _OutletRegistrationScreenState createState() =>
      _OutletRegistrationScreenState();
}

class _OutletRegistrationScreenState extends State<OutletRegistrationScreen> {
  bool isHidden = true;
  TextEditingController outletRegistrationEmailController =
      TextEditingController();
  TextEditingController outletRegistrationPasswordController =
      TextEditingController();

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
                "Time to sign up",
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: PrimaryColorDark,
                ),
              ),
            ),
            Text(
              "You have come,",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w200,
                color: PrimaryColorDark,
              ),
            ),
            Text(
              "To the right place!",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w200,
                color: PrimaryColorDark,
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
                  controller: outletRegistrationEmailController,
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
                        controller: outletRegistrationPasswordController,
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
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
                text: "Already have an account? ",
                style: TextStyle(
                  color: PrimaryColorDark,
                  fontSize: 16,
                ),
                children: [
                  TextSpan(
                    text: 'Sign in',
                    style: TextStyle(
                      color: PrimaryColorDark,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => Navigator.pop(context),
                  )
                ]),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 15),
            child: CustomSolidButton(
              width: width,
              height: 60,
              text: "Sign up",
              onTap: () {
                _confirmAndSubmit();
              },
            ),
          ),
        ],
      ),
    );
  }

  void _confirmAndSubmit() {
    outletRegistrationEmailController.text.isNotEmpty &&
            outletRegistrationPasswordController.text.isNotEmpty
        ? _updateDatabase()
        : common.showToast(context, "Please fill all the fields");
  }

  void _updateDatabase() async {
    UserCredential userCredential = await DBHelper().registerUser(
      outletRegistrationEmailController.text,
      outletRegistrationPasswordController.text,
      context,
    );
    print(userCredential);

    if (userCredential != null) {
      DBHelper()
          .saveUserInfoToFireStore(userCredential.user, "outlets")
          .then((value) {
        Navigator.pop(context);
        Route route = MaterialPageRoute(builder: (c) => OutletLoginScreen());
        Navigator.pushReplacement(context, route);
      });
    } else {
      outletRegistrationEmailController.text = "";
      outletRegistrationPasswordController.text = "";
      common.showToast(context, "Please try again");
    }
  }
}
