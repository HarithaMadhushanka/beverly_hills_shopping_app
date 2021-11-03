import 'package:beverly_hills_shopping_app/utils/enums.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Material buildPromotionComponent(
    double width, DocumentSnapshot<Object> promotion) {
  return Material(
    borderRadius: BorderRadius.circular(20),
    elevation: 1,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 160,
        width: width,
        decoration: BoxDecoration(
          color: PrimaryColorLight,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: width,
              padding: EdgeInsets.only(top: 10, left: 10, right: 10),
              color: PrimaryColorLight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  /// Picture
                  Material(
                    borderRadius: BorderRadius.circular(10),
                    elevation: 2,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        width: 70,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: SecondaryColorLight,
                        ),
                        child: Image.network(
                          promotion['promoPicUrl'],
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          promotion['promoTitle'],
                          style: TextStyle(
                            fontSize: 16,
                            color: PrimaryColorDark,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          "Start date: " + promotion['promoStartingDate'],
                          style: TextStyle(
                            fontSize: 12,
                            color: PrimaryColorDark,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "End date: " + promotion['promoEndingDate'],
                          style: TextStyle(
                            fontSize: 12,
                            color: PrimaryColorDark,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                margin:
                    EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                width: width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: SecondaryColorLight,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 5, bottom: 10),
                    child: Text(
                      promotion['promoDesc'],
                      style: TextStyle(
                        fontSize: 14,
                        color: PrimaryColorDark,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
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
