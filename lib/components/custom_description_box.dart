import 'package:beverly_hills_shopping_app/utils/enums.dart';
import 'package:flutter/material.dart';

class CustomDescriptionBox extends StatefulWidget {
  const CustomDescriptionBox(
      {Key key,
      @required this.width,
      @required this.height,
      this.controller,
      this.hintText,
      this.initialValue,
      this.isNotEditable,
      this.color})
      : super(key: key);
  final double width;
  final double height;
  final String hintText;
  final String initialValue;
  final bool isNotEditable;
  final Color color;
  final TextEditingController controller;

  @override
  _CustomDescriptionBoxState createState() => _CustomDescriptionBoxState();
}

class _CustomDescriptionBoxState extends State<CustomDescriptionBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height * 0.2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: PrimaryColorDark,
        ),
        color: widget.color != null ? widget.color : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 10),
            child: Icon(
              Icons.list_outlined,
              size: 22,
              color: SecondaryColorDark,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 12, top: 2),
              child: TextFormField(
                enabled: widget.isNotEditable == null ? true : false,
                initialValue:
                    widget.initialValue != null ? widget.initialValue : "",
                controller:
                    widget.controller != null ? widget.controller : null,
                maxLines: 6,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(top: 10),
                  hintText:
                      widget.hintText == null ? "Description" : widget.hintText,
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
