import 'package:beverly_hills_shopping_app/components/custom_outline_button.dart';
import 'package:beverly_hills_shopping_app/components/custom_sliver_app_bar_common.dart';
import 'package:beverly_hills_shopping_app/screens/customer/customer_give_feedback_screen.dart';
import 'package:beverly_hills_shopping_app/utils/enums.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CustomerViewOutletsDetailsScreen extends StatefulWidget {
  const CustomerViewOutletsDetailsScreen({Key key, @required this.outlet})
      : super(key: key);
  final DocumentSnapshot<Object> outlet;

  @override
  _CustomerViewOutletsDetailsScreenState createState() =>
      _CustomerViewOutletsDetailsScreenState();
}

class _CustomerViewOutletsDetailsScreenState
    extends State<CustomerViewOutletsDetailsScreen> {
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
            title: widget.outlet['outletName'],
            isTrailingNeeded: false,
          ),
          SliverFillRemaining(
            child: SingleChildScrollView(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Material(
                      elevation: 2,
                      child: Container(
                        width: width,
                        height: height * 0.35,
                        decoration: BoxDecoration(
                          color: SecondaryColorLight,
                          image: DecorationImage(
                            image: NetworkImage(widget.outlet['profilePicUrl']),
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 25),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            widget.outlet['outletName'],
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontSize: 24,
                              color: PrimaryColorDark,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            widget.outlet['outletDesc'],
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontSize: 14,
                              color: PrimaryColorDark,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            "Contact details",
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontSize: 18,
                              color: PrimaryColorDark,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Contact no :",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: PrimaryColorDark,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      widget.outlet['mobileNo'],
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: PrimaryColorDark,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "Address :",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: PrimaryColorDark,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      widget.outlet['addressLine1'] + ",",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: PrimaryColorDark,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Text(
                                      widget.outlet['addressLine2'] + ",",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: PrimaryColorDark,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Text(
                                      widget.outlet['addressLine3'] + ".",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: PrimaryColorDark,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Email :",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: PrimaryColorDark,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      widget.outlet['email'],
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: PrimaryColorDark,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          CustomOutlineButton(
                            width: width,
                            height: 60,
                            text: "Give Feedback",
                            buttonTextSize: 16,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CustomerGiveFeedbackScreen(
                                  outlet: widget.outlet,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
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
    );
  }
}
