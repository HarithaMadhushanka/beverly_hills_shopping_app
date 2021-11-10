import 'package:beverly_hills_shopping_app/utils/enums.dart';
import 'package:flutter/material.dart';

class CustomSolidButton extends StatelessWidget {
  const CustomSolidButton({
    Key key,
    @required this.width,
    @required this.height,
    @required this.text,
    @required this.onTap,
    this.buttonTextSize,
    this.isDisabled,
  }) : super(key: key);
  final double width;
  final double height;
  final double buttonTextSize;
  final String text;
  final VoidCallback onTap;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isDisabled != null
          ? PrimaryColorDark.withOpacity(0.5)
          : PrimaryColorDark,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: isDisabled != null ? null : onTap,
        splashColor: SecondaryColorDark,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
                color: isDisabled != null
                    ? Colors.black.withOpacity(0.1)
                    : PrimaryColorDark),
          ),
          child: Center(
            child: Text(
              text,
              style: isDisabled != null
                  ? TextStyle(
                      fontSize: buttonTextSize != null ? buttonTextSize : 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white.withOpacity(0.8),
                    )
                  : TextStyle(
                      fontSize: buttonTextSize != null ? buttonTextSize : 18,
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
