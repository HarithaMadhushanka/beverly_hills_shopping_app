import 'package:beverly_hills_shopping_app/utils/enums.dart';
import 'package:flutter/material.dart';

class PopularPlacesWidget extends StatelessWidget {
  PopularPlacesWidget({
    @required this.imagePath,
    @required this.title,
    @required this.subtitle,
    @required this.price,
  });
  final String imagePath;
  final String title;
  final String subtitle;
  final String price;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: SecondaryColorLight,
      margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
      child: Material(
        elevation: 1,
        borderRadius: BorderRadius.circular(10.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 110,
          decoration: BoxDecoration(
            color: PrimaryColorLight.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(left: 8.0),
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: PrimaryColorLight,
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: NetworkImage(imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: PrimaryColorDark,
                          fontWeight: FontWeight.w500,
                          fontSize: 16.0,
                        ),
                      ),
                      Container(
                        height: 35,
                        child: Text(
                          subtitle,
                          style: TextStyle(
                            color: PrimaryColorDark,
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        price,
                        style: TextStyle(
                          color: SecondaryColorDark,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
