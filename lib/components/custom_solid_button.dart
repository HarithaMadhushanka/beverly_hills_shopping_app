import 'package:flutter/material.dart';

import '../enums.dart';

class CustomSolidButton extends StatelessWidget {
  const CustomSolidButton({
    Key key,
    @required this.width,
    @required this.height,
    @required this.text,
    @required this.onTap,
  }) : super(key: key);
  final double width;
  final double height;
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: PrimaryColorDark,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        splashColor: SecondaryColorDark,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: PrimaryColorDark),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: PrimaryColorLight,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
