import 'package:beverly_hills_shopping_app/components/custom_sliver_app_bar_common.dart';
import 'package:beverly_hills_shopping_app/utils/enums.dart';
import 'package:flutter/material.dart';

class OutletViewFeedbacksScreen extends StatefulWidget {
  const OutletViewFeedbacksScreen({Key key}) : super(key: key);

  @override
  _OutletViewFeedbacksScreenState createState() =>
      _OutletViewFeedbacksScreenState();
}

class _OutletViewFeedbacksScreenState extends State<OutletViewFeedbacksScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SecondaryColorLight,
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          /// SLiver App bar
          buildCustomSliverAppBarCommon(
            context: context,
            isBackNeeded: true,
            title: 'Feedbacks',
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
                      height: 30,
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
