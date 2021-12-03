import 'package:beverly_hills_shopping_app/components/custom_description_box.dart';
import 'package:beverly_hills_shopping_app/components/custom_outline_button.dart';
import 'package:beverly_hills_shopping_app/components/custom_sliver_app_bar_common.dart';
import 'package:beverly_hills_shopping_app/database/db_helper.dart';
import 'package:beverly_hills_shopping_app/models/feedback.dart' as fdb;
import 'package:beverly_hills_shopping_app/utils/common_functions.dart'
    as common;
import 'package:beverly_hills_shopping_app/utils/enums.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class CustomerGiveFeedbackScreen extends StatefulWidget {
  const CustomerGiveFeedbackScreen({Key key, this.outlet}) : super(key: key);
  final DocumentSnapshot<Object> outlet;

  @override
  _CustomerGiveFeedbackScreenState createState() =>
      _CustomerGiveFeedbackScreenState();
}

class _CustomerGiveFeedbackScreenState
    extends State<CustomerGiveFeedbackScreen> {
  TextEditingController _feedbackTextEditingController =
      TextEditingController();
  DBHelper _dbHelper = DBHelper();
  double _rating = 2.5;
  String customerName = "";

  @override
  void initState() {
    super.initState();

    common.getUserDetails(isCustomer: true).then((value) {
      customerName = value.firstName + " " + value.lastName;
      print(customerName);
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: SecondaryColorLight,
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          /// SLiver App bar
          buildCustomSliverAppBarCommon(
            context: context,
            isBackNeeded: true,
            title: 'Feedback & Rating',
            isTrailingNeeded: false,
          ),
          SliverFillRemaining(
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      "You are going to give feedback to,",
                      style: TextStyle(
                          color: PrimaryColorDark,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.outlet["outletName"] + "...",
                      style: TextStyle(
                          color: PrimaryColorDark,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: RatingBar.builder(
                        itemSize: 40,
                        initialRating: _rating,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.blue,
                        ),
                        onRatingUpdate: (rating) {
                          setState(() {
                            _rating = rating;
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Text(
                      "Tell us more...",
                      style: TextStyle(
                          color: PrimaryColorDark,
                          fontSize: 18,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CustomDescriptionBox(
                      width: width,
                      height: height,
                      controller: _feedbackTextEditingController,
                      hintText: "feedback...",
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CustomOutlineButton(
                      width: width,
                      height: 60,
                      text: "Give Feedback",
                      buttonTextSize: 16,
                      onTap: () => _giveFeedback(),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _giveFeedback() {
    if (_feedbackTextEditingController.text.isNotEmpty) {
      fdb.Feedback _feedback = fdb.Feedback();
      _feedback.rating = _rating;
      _feedback.feedback = _feedbackTextEditingController.text;
      _feedback.outletID = widget.outlet["userID"];
      _feedback.givenBy = customerName;
      _feedback.addedDate = DateTime.now().toLocal().toString();

      _dbHelper
          .giveFeedBack(_feedback)
          .then((value) => common.showToast(
                context,
                "You rated ${widget.outlet['outletName']} successfully!",
                duration: Duration(seconds: 2),
              ))
          .then((value) {
        Future.delayed(Duration(seconds: 1), () {
          Navigator.pop(context);
        });
      });
    } else {
      common.showToast(context, "Please add your feedback...");
    }
  }
}
