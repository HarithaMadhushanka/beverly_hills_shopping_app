import 'package:beverly_hills_shopping_app/utils/enums.dart';
import 'package:flutter/material.dart';

class CustomHomeContainer extends StatelessWidget {
  const CustomHomeContainer(
      {Key key,
      @required this.isLeft,
      this.title,
      this.color,
      this.onTap,
      this.iconBgColor,
      this.icon})
      : super(key: key);
  final bool isLeft;
  final String title;
  final Widget icon;
  final Color color;
  final Color iconBgColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Container(
      width: width,
      height: 90,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Visibility(
            visible: !isLeft,
            child: SizedBox(
              width: 60,
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: onTap,
              behavior: HitTestBehavior.opaque,
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 15,
                      ),
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: iconBgColor,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Center(
                        child: icon,
                      ),
                    ),
                    Text(
                      title,
                      style: TextStyle(
                        color: SecondaryColorDark,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Visibility(
            visible: isLeft,
            child: SizedBox(
              width: 60,
            ),
          ),
        ],
      ),
    );
  }
}
