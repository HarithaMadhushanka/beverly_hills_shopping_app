import 'package:beverly_hills_shopping_app/components/custom_solid_button.dart';
import 'package:beverly_hills_shopping_app/database/db_helper.dart';
import 'package:beverly_hills_shopping_app/screens/customer/customer_dashboard.dart';
import 'package:beverly_hills_shopping_app/screens/customer/customer_registration_screen.dart';
import 'package:beverly_hills_shopping_app/screens/welcome/intro.dart';
import 'package:beverly_hills_shopping_app/utils/common_functions.dart'
    as common;
import 'package:beverly_hills_shopping_app/utils/enums.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class CustomerLoginScreen extends StatefulWidget {
  const CustomerLoginScreen({Key key}) : super(key: key);

  @override
  _CustomerLoginScreenState createState() => _CustomerLoginScreenState();
}

class _CustomerLoginScreenState extends State<CustomerLoginScreen> {
  bool isHidden = true;
  TextEditingController customerLoginEmailController = TextEditingController();
  TextEditingController customerLoginPasswordController =
      TextEditingController();
  DBHelper _dbHelper = DBHelper();

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
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                "Let's sign you in",
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: PrimaryColorDark,
                ),
              ),
            ),
            Text(
              "Welcome back,",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w200,
                color: PrimaryColorDark,
              ),
            ),
            Text(
              "You've been missed!",
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
                  controller: customerLoginEmailController,
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
                        controller: customerLoginPasswordController,
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
        children: [
          SizedBox(
            height: 10,
          ),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
                text: "Don't have an account? ",
                style: TextStyle(
                  color: PrimaryColorDark,
                  fontSize: 16,
                ),
                children: [
                  TextSpan(
                    text: 'Register',
                    style: TextStyle(
                      color: PrimaryColorDark,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CustomerRegistrationScreen(),
                            ),
                          ),
                  )
                ]),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 10, 25, 15),
            child: CustomSolidButton(
              width: width,
              height: 60,
              text: "Sign in",
              onTap: () {
                _confirmAndLoginCustomer();
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Validates empty fields
  void _confirmAndLoginCustomer() {
    customerLoginEmailController.text.isNotEmpty &&
            customerLoginPasswordController.text.isNotEmpty
        ? _loginCustomer()
        : common.showToast(context, "Please fill all the fields");
  }

  /// Logs in the user (Firebase Auth)
  void _loginCustomer() async {
    UserCredential userCredential = await _dbHelper.loginUser(
        customerLoginEmailController.text,
        customerLoginPasswordController.text,
        context);
    common.saveUpdatedUserDetailsLocally(userType: "customer");
    if (userCredential != null) {
      /// Checks if the user has completed the Registration process
      bool isRegCompleted =
          await _dbHelper.getUserRegState(userCredential.user.uid, "customer");

      if (isRegCompleted == null) {
        common.showToast(
            context, "User credentials are incorrect. Please try again.");
      } else {
        /// Navigates the user to the next page according to their Registration State
        Route route = MaterialPageRoute(
          builder: (c) => !isRegCompleted
              ? IntroScreen(
                  userID: userCredential.user.uid,
                  userType: "customer",
                )
              : CustomerDashboard(),
        );
        Navigator.pushReplacement(context, route);
      }
    } else {
      common.showToast(context, "Please try again");
    }
  }
}
