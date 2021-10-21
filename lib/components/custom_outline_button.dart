import 'package:beverly_hills_shopping_app/utils/enums.dart';
import 'package:flutter/material.dart';

class CustomOutlineButton extends StatelessWidget {
  const CustomOutlineButton({
    Key key,
    @required this.width,
    @required this.height,
    @required this.text,
    @required this.onTap,
    this.buttonTextSize,
    this.fontColor,
    this.borderColor,
    this.borderWidth,
  }) : super(key: key);
  final double width;
  final double height;
  final String text;
  final VoidCallback onTap;
  final double buttonTextSize;
  final Color fontColor;
  final Color borderColor;
  final double borderWidth;

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
            border: Border.all(
                color: borderColor != null ? borderColor : PrimaryColorDark,
                width: borderWidth != null ? borderWidth : 1),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: buttonTextSize != null ? buttonTextSize : 18,
                fontWeight: FontWeight.bold,
                color: fontColor != null ? fontColor : PrimaryColorDark,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
