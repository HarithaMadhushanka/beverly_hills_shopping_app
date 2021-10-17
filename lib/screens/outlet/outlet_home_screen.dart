import 'package:flutter/material.dart';

class OutletHomeScreen extends StatefulWidget {
  const OutletHomeScreen({Key key}) : super(key: key);

  @override
  _OutletHomeScreenState createState() => _OutletHomeScreenState();
}

class _OutletHomeScreenState extends State<OutletHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Welcome"),
      ),
    );
  }
}
