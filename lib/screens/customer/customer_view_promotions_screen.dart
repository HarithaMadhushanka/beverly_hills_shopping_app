import 'package:beverly_hills_shopping_app/components/custom_promotion_component.dart';
import 'package:beverly_hills_shopping_app/components/custom_sliver_app_bar_common.dart';
import 'package:beverly_hills_shopping_app/utils/enums.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'customer_view_promotion_details_screen.dart';

class CustomerViewPromotionsScreen extends StatefulWidget {
  const CustomerViewPromotionsScreen({Key key}) : super(key: key);

  @override
  _CustomerViewPromotionsScreenState createState() =>
      _CustomerViewPromotionsScreenState();
}

class _CustomerViewPromotionsScreenState
    extends State<CustomerViewPromotionsScreen> {
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
            title: 'Promotions',
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
                        stream: promotionsCollectionReference
                            .where('isApproved', isEqualTo: true)
                            .orderBy('promoAddedTime', descending: true)
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData) return Text("");
                          return Container(
                            height: height * 0.88,
                            child: ListView.builder(
                              physics: const BouncingScrollPhysics(
                                  parent: AlwaysScrollableScrollPhysics()),
                              scrollDirection: Axis.vertical,
                              itemCount: snapshot.data.docs.length,
                              itemBuilder: (context, index) {
                                DocumentSnapshot promotion =
                                    snapshot.data.docs[index];

                                return Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                CustomerViewPromotionDetailsScreen(
                                              promotion: promotion,
                                            ),
                                          ),
                                        );
                                      },
                                      behavior: HitTestBehavior.opaque,
                                      child: buildPromotionComponent(
                                          width, promotion),
                                    ),
                                    SizedBox(
                                      height: 15,
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
