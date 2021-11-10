import 'package:beverly_hills_shopping_app/utils/enums.dart';
import 'package:flutter/material.dart';

InkWell buildImageUploader(double width, String title,
    {Function onTap, Widget child}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(10),
    child: Container(
      width: width,
      height: 60,
      decoration: BoxDecoration(
        border: Border.all(color: PrimaryColorDark),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        enabled: false,
        initialValue: title,
        style: TextStyle(color: Colors.black.withOpacity(0.8)),
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(top: 20),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          icon: Padding(
            padding: const EdgeInsets.only(left: 20, top: 5),
            child: Icon(
              Icons.image,
              size: 22,
              color: SecondaryColorDark,
            ),
          ),
          suffixIcon: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              width: 100,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: PrimaryColorDark),
              ),
              child: child,
            ),
          ),
        ),
      ),
    ),
  );
}
