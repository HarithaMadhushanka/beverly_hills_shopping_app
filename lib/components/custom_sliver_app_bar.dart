import 'package:beverly_hills_shopping_app/utils/enums.dart';
import 'package:flutter/material.dart';

SliverAppBar buildSliverAppBar(BuildContext context,
    {Function onTapDrawer, Function onTapProfile, bool isCustomer}) {
  return SliverAppBar(
    floating: false,
    pinned: true,
    backgroundColor: SecondaryColorLight,
    // automaticallyImplyLeading: true,
    leading: Container(),
    bottom: PreferredSize(
      preferredSize: Size.fromHeight(
        MediaQuery.of(context).size.height * 0.03,
      ),
      child: Container(),
    ),
    flexibleSpace: Container(
      padding: EdgeInsets.only(left: 15, top: 25),
      child: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: IconButton(
                onPressed: onTapDrawer,
                icon: Icon(
                  Icons.menu,
                  size: 35,
                  color: PrimaryColorDark,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: loggedInUserID != ""
                  ? StreamBuilder(
                      stream: isCustomer
                          ? customerCollectionReference
                              .doc(loggedInUserID)
                              .snapshots()
                          : outletCollectionReference
                              .doc(loggedInUserID)
                              .snapshots(),
                      builder: (context, snapshot) {
                        var userDocument = snapshot.data;

                        if (snapshot.hasError) {
                          Container(
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: PrimaryColorDark, width: 2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                'images/user.png',
                                height: 35,
                                width: 35,
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          );
                        }
                        if (!snapshot.hasData) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: PrimaryColorDark, width: 2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Image.asset(
                                'images/user.png',
                                height: 35,
                                width: 35,
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          );
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: PrimaryColorDark, width: 2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Image.asset(
                                'images/user.png',
                                height: 35,
                                width: 35,
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          );
                        }
                        return userDocument["profilePicUrl"] != "" &&
                                userDocument["profilePicUrl"] != null
                            ? GestureDetector(
                                onTap: onTapProfile,
                                behavior: HitTestBehavior.opaque,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: PrimaryColorDark, width: 2),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Image.network(
                                      userDocument["profilePicUrl"],
                                      height: 35,
                                      width: 35,
                                      fit: BoxFit.fitWidth,
                                    ),
                                  ),
                                ),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: PrimaryColorDark, width: 2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    'images/user.png',
                                    height: 35,
                                    width: 35,
                                    fit: BoxFit.fitWidth,
                                  ),
                                ),
                              );
                      })
                  : Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: PrimaryColorDark, width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          'images/user.png',
                          height: 35,
                          width: 35,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    ),
  );
}
