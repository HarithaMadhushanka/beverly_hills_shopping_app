import 'package:flutter/material.dart';

import '../enums.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    Key key,
    @required this.controller,
    @required this.height,
    @required this.width,
    @required this.hintText,
    @required this.icon,
    this.iconSize,
  }) : super(key: key);
  final TextEditingController controller;
  final double height;
  final double width;
  final String hintText;
  final IconData icon;
  final double iconSize;

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(
        border: Border.all(color: PrimaryColorDark),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        controller: widget.controller,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(top: 10),
          hintText: widget.hintText,
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          icon: Padding(
            padding: const EdgeInsets.only(left: 20, top: 10),
            child: Icon(
              widget.icon,
              size: widget.iconSize,
              color: SecondaryColorDark,
            ),
          ),
        ),
      ),
    );
  }
}
