import 'package:flutter/material.dart';

import '../enums.dart';

class CustomOutlineButton extends StatelessWidget {
  const CustomOutlineButton({
    Key key,
    @required this.width,
    @required this.height,
    @required this.text,
    @required this.onTap,
    this.buttonTextSize,
  }) : super(key: key);
  final double width;
  final double height;
  final String text;
  final VoidCallback onTap;
  final double buttonTextSize;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: SecondaryColorLight,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        splashColor: PrimaryColorLight,
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
                fontSize: buttonTextSize != null ? buttonTextSize : 18,
                fontWeight: FontWeight.bold,
                color: PrimaryColorDark,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
