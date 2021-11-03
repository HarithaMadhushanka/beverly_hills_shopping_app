import 'package:beverly_hills_shopping_app/components/custom_sliver_app_bar_common.dart';
import 'package:beverly_hills_shopping_app/utils/enums.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CustomerViewPromotionDetailsScreen extends StatefulWidget {
  const CustomerViewPromotionDetailsScreen({Key key, @required this.promotion})
      : super(key: key);
  final DocumentSnapshot<Object> promotion;

  @override
  _CustomerViewPromotionDetailsScreenState createState() =>
      _CustomerViewPromotionDetailsScreenState();
}

class _CustomerViewPromotionDetailsScreenState
    extends State<CustomerViewPromotionDetailsScreen> {
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
            title: widget.promotion['promoTitle'],
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
                            image:
                                NetworkImage(widget.promotion['promoPicUrl']),
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
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Start date : ",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: PrimaryColorDark,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: widget.promotion['promoStartingDate'],
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: SecondaryColorDark,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "End date : ",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: PrimaryColorDark,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: widget.promotion['promoEndingDate'],
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: SecondaryColorDark,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            widget.promotion['promoDesc'],
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontSize: 14,
                              color: PrimaryColorDark,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Text(
                            "Outlet details",
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontSize: 18,
                              color: PrimaryColorDark,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 3),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Posted by :",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: PrimaryColorDark,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    StreamBuilder(
                                        stream: outletCollectionReference
                                            .doc(widget.promotion['addedBy'])
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
                                            userDocument["outletName"],
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: PrimaryColorDark),
                                          );
                                        }),
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
                                    StreamBuilder(
                                        stream: outletCollectionReference
                                            .doc(widget.promotion['addedBy'])
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
                                            userDocument["email"],
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: PrimaryColorDark),
                                          );
                                        }),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 40,
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
