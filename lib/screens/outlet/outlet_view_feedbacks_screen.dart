import 'package:beverly_hills_shopping_app/components/custom_description_box.dart';
import 'package:beverly_hills_shopping_app/components/custom_sliver_app_bar_common.dart';
import 'package:beverly_hills_shopping_app/models/feedback.dart' as fdb;
import 'package:beverly_hills_shopping_app/utils/enums.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class OutletViewFeedbacksScreen extends StatefulWidget {
  const OutletViewFeedbacksScreen({Key key}) : super(key: key);

  @override
  _OutletViewFeedbacksScreenState createState() =>
      _OutletViewFeedbacksScreenState();
}

class _OutletViewFeedbacksScreenState extends State<OutletViewFeedbacksScreen> {
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
            title: 'Feedbacks & Ratings',
            isTrailingNeeded: false,
          ),
          SliverFillRemaining(
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    StreamBuilder<QuerySnapshot>(
                        stream: feedbacksCollectionReference
                            .where('outletID', isEqualTo: loggedInUserID)
                            .orderBy('addedDate', descending: true)
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData) return Text("");
                          return Container(
                            height: height * 0.86,
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: snapshot.data.docs.length,
                              itemBuilder: (context, index) {
                                DocumentSnapshot feedback =
                                    snapshot.data.docs[index];
                                fdb.Feedback _feedback = fdb.Feedback();
                                _feedback.givenBy = feedback["givenBy"];
                                _feedback.rating = feedback["rating"];
                                _feedback.feedback = feedback["feedback"];

                                return Column(
                                  children: [
                                    Container(
                                      padding:
                                          EdgeInsets.fromLTRB(10, 10, 10, 5),
                                      width: width,
                                      height: height * 0.23,
                                      decoration: BoxDecoration(
                                        border:
                                            Border.all(color: PrimaryColorDark),
                                        borderRadius: BorderRadius.circular(20),
                                        color: PrimaryColorLight,
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(_feedback.rating
                                                    .toString()),
                                                RatingBar.builder(
                                                  itemSize: 12,
                                                  initialRating:
                                                      _feedback.rating,
                                                  minRating: 1,
                                                  direction: Axis.horizontal,
                                                  allowHalfRating: true,
                                                  itemCount: 5,
                                                  itemPadding:
                                                      EdgeInsets.symmetric(
                                                          horizontal: 1.0),
                                                  itemBuilder: (context, _) =>
                                                      Icon(
                                                    Icons.star,
                                                    color: Colors.blue,
                                                  ),
                                                  onRatingUpdate: (rating) {
                                                    setState(() {
                                                      // _rating = rating;
                                                    });
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 5),
                                                  child: Text(
                                                    _feedback.givenBy,
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: PrimaryColorDark,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                CustomDescriptionBox(
                                                  width: width,
                                                  height: height * 0.8,
                                                  initialValue:
                                                      _feedback.feedback,
                                                  hintText: "feedback...",
                                                  isNotEditable: true,
                                                  color: SecondaryColorLight,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                );
                              },
                            ),
                          );
                        }),
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
