import 'package:beverly_hills_shopping_app/utils/common_functions.dart';
import 'package:beverly_hills_shopping_app/utils/enums.dart';
import 'package:flutter/material.dart';

SliverAppBar buildCustomSliverAppBarCommon({
  BuildContext context,
  bool isBackNeeded,
  String title,
  bool isTrailingNeeded,
  Widget trailingWidget,
  Function trailingOnTap,
}) {
  return SliverAppBar(
    elevation: 10,
    backgroundColor: SecondaryColorLight,
    pinned: true,
    automaticallyImplyLeading: false,
    bottom: PreferredSize(
      preferredSize: Size.fromHeight(
        MediaQuery.of(context).size.height * 0.009,
      ),
      child: Container(),
    ),
    flexibleSpace: Material(
      elevation: 2,
      borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),
        ),
        padding: EdgeInsets.only(left: 20, right: 20, top: 28),
        child: Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              isBackNeeded
                  ? GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Row(
                        children: [
                          Image.asset(
                            'images/back_arrow.png',
                            scale: 1.7,
                            color: PrimaryColorDark,
                            fit: BoxFit.fitWidth,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 6),
                            child: Text(
                              "Back",
                              style: TextStyle(
                                color: PrimaryColorDark,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : SizedBox(
                      width: MediaQuery.of(context).size.width * 0.15,
                    ),
              Text(
                truncateWithEllipsis(20, title),
                style: TextStyle(
                  color: PrimaryColorDark,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              isTrailingNeeded
                  ? GestureDetector(
                      onTap: trailingOnTap,
                      child: Text(
                        "Update",
                        style: TextStyle(
                          color: PrimaryColorDark,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  : SizedBox(
                      width: MediaQuery.of(context).size.width * 0.15,
                    ),
            ],
          ),
        ),
      ),
    ),
  );
}
