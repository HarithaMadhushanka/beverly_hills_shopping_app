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
    this.isDisabled,
  }) : super(key: key);
  final double width;
  final double height;
  final String text;
  final VoidCallback onTap;
  final double buttonTextSize;
  final Color fontColor;
  final Color borderColor;
  final double borderWidth;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isDisabled != null
          ? SecondaryColorLight.withOpacity(0.5)
          : SecondaryColorLight,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: isDisabled != null ? null : onTap,
        splashColor: PrimaryColorLight,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: isDisabled != null
                ? Border.all(
                    color: borderColor != null ? borderColor : Colors.grey,
                    width: borderWidth != null ? borderWidth : 1)
                : Border.all(
                    color: borderColor != null ? borderColor : PrimaryColorDark,
                    width: borderWidth != null ? borderWidth : 1),
          ),
          child: Center(
            child: Text(
              text,
              style: isDisabled != null
                  ? TextStyle(
                      fontSize: buttonTextSize != null ? buttonTextSize : 18,
                      fontWeight: FontWeight.bold,
                      color: fontColor != null ? fontColor : Colors.grey,
                    )
                  : TextStyle(
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
