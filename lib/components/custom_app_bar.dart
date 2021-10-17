import 'package:flutter/material.dart';

import '../enums.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Container(
      height: 80,
      width: width,
      color: SecondaryColorLight,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              'images/back_arrow.png',
              height: 25,
              width: 25,
            ),
            Text("sdfsd"),
            Text("sdfsd"),
          ],
        ),
      ),
    );
  }
}
