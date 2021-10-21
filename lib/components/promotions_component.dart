import 'package:flutter/material.dart';

class PromotionsComponent extends StatelessWidget {
  PromotionsComponent({
    @required this.imagePath,
    @required this.onTap,
  });
  final String imagePath;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(right: 15.0),
        child: Material(
          borderRadius: BorderRadius.circular(20.0),
          elevation: 2,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.35,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              image: DecorationImage(
                image: NetworkImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
