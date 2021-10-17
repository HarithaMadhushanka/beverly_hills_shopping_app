import 'package:flutter/material.dart';

import 'enums.dart';

void showToast(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: PrimaryColorLight,
      content: Text(
        msg,
        style: TextStyle(color: PrimaryColorDark),
      ),
    ),
  );
}
