import 'package:beverly_hills_shopping_app/utils/enums.dart';
import 'package:flutter/material.dart';

Container buildCustomReportComponentPrimary(double width, Color color,
    String title, String subtitle1, String subtitle2, String picUrl) {
  return Container(
    width: width,
    height: 130,
    padding: EdgeInsets.only(top: 20, bottom: 25),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(20.0),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 20, right: 15),
          width: 85,
          height: 85,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
            image: DecorationImage(
              image: picUrl != ""
                  ? NetworkImage(picUrl)
                  : AssetImage('images/shopping.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: PrimaryColorDark,
                ),
              ),
              SizedBox(
                height: 2,
              ),
              Text(
                subtitle1,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: SecondaryColorDark,
                ),
              ),
              Spacer(),
              Text(
                subtitle2,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: SecondaryColorDark,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 20,
        ),
      ],
    ),
  );
}
