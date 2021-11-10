import 'package:beverly_hills_shopping_app/components/custom_outline_button.dart';
import 'package:beverly_hills_shopping_app/components/custom_sliver_app_bar_common.dart';
import 'package:beverly_hills_shopping_app/components/custom_solid_button.dart';
import 'package:beverly_hills_shopping_app/database/db_helper.dart';
import 'package:beverly_hills_shopping_app/utils/common_functions.dart'
    as common;
import 'package:beverly_hills_shopping_app/utils/enums.dart';
import 'package:flutter/material.dart';

class CustomerNavigationScreen extends StatefulWidget {
  const CustomerNavigationScreen({Key key, @required this.isComingFromDrawer})
      : super(key: key);
  final bool isComingFromDrawer;

  @override
  _CustomerNavigationScreenState createState() =>
      _CustomerNavigationScreenState();
}

class _CustomerNavigationScreenState extends State<CustomerNavigationScreen> {
  DBHelper _dbHelper = DBHelper();

  List<String> _navigationStartList;
  List<String> _navigationEndList;

  String _selectedStartingPoint;
  String _selectedEndingPoint;

  bool isEditable1 = true;
  bool isEditable2 = false;
  bool isShopToExit = false;
  bool isImageVisible = false;

  String _outletID = "";

  @override
  void initState() {
    common.getOutletData();
    setState(() {
      _navigationStartList = navigationStartList;
      _navigationEndList = navigationEndList;
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_navigationStartList[0] != "Start")
      _navigationStartList.insert(0, "Start");
    if (_navigationEndList[0] != "End") _navigationEndList.insert(0, "End");
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: SecondaryColorLight,
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          /// SLiver App bar
          buildCustomSliverAppBarCommon(
            context: context,
            isBackNeeded: widget.isComingFromDrawer ? true : false,
            title: 'Navigation',
            isTrailingNeeded: false,
          ),
          SliverFillRemaining(
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: width,
                      height: 60,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: isEditable1 == false
                                ? Colors.grey
                                : PrimaryColorDark),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: DropdownButtonFormField(
                        value: _selectedStartingPoint == null
                            ? null
                            : _selectedStartingPoint,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(top: 10),
                          hintText: 'Starting Point',
                          hintStyle: TextStyle(
                              color: isEditable1 == false
                                  ? Colors.grey
                                  : PrimaryColorDark),
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          icon: Padding(
                            padding: const EdgeInsets.only(left: 20, top: 10),
                            child: Icon(
                              Icons.list,
                              size: 22,
                              color: isEditable1 == false
                                  ? Colors.grey
                                  : SecondaryColorDark,
                            ),
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            _selectedStartingPoint = null;
                          });
                        },
                        onChanged: isEditable1 == false
                            ? null
                            : (newValue) async {
                                setState(() {
                                  _selectedStartingPoint = newValue;
                                  isEditable2 = true;
                                });

                                if (_selectedStartingPoint == "Start") {
                                  common.getOutletData();
                                  setState(() {
                                    _navigationEndList = navigationEndList;
                                    _navigationEndList.remove("End");
                                  });
                                } else {
                                  setState(() {
                                    _navigationEndList.clear();
                                    _navigationEndList.insert(0, "End");
                                  });
                                }

                                // _selectedOutletID =
                                // await _dbHelper.getOutletID(newValue);
                                // setState(() {});
                                // print(_selectedOutletID);
                              },
                        items: _navigationStartList.map((outlet) {
                          return DropdownMenuItem(
                            child: Text(outlet),
                            value: outlet,
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      width: width,
                      height: 60,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: isEditable2 == false
                                ? Colors.grey
                                : PrimaryColorDark),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: DropdownButtonFormField(
                        value: _selectedEndingPoint == null
                            ? null
                            : _selectedEndingPoint,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(top: 10),
                          hintText: 'End Point',
                          hintStyle: TextStyle(
                              color: isEditable2 == false
                                  ? Colors.grey
                                  : PrimaryColorDark),
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          icon: Padding(
                            padding: const EdgeInsets.only(left: 20, top: 10),
                            child: Icon(
                              Icons.list,
                              size: 22,
                              color: isEditable2 == false
                                  ? Colors.grey
                                  : SecondaryColorDark,
                            ),
                          ),
                        ),
                        onChanged: isEditable2 == false
                            ? null
                            : (newValue) async {
                                setState(() {
                                  _selectedEndingPoint = newValue;
                                  disableFields();
                                });

                                // _selectedOutletID =
                                // await _dbHelper.getOutletID(newValue);
                                // setState(() {});
                                // print(_selectedOutletID);
                              },
                        items: _navigationEndList.map((outlet) {
                          return DropdownMenuItem(
                            child: Text(outlet),
                            value: outlet,
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomOutlineButton(
                          width: 120,
                          isDisabled: _selectedStartingPoint != null &&
                                  _selectedEndingPoint != null
                              ? null
                              : true,
                          height: 35,
                          text: "Reset",
                          buttonTextSize: 14,
                          onTap: () {
                            common.getOutletData();

                            setState(() {
                              _navigationStartList.clear();
                              _navigationEndList.clear();
                              _selectedStartingPoint = null;
                              _selectedEndingPoint = null;
                              _navigationStartList = navigationStartList;
                              _navigationEndList = navigationEndList;
                              if (_navigationStartList[0] != "Start")
                                _navigationStartList.insert(0, "Start");
                              if (_navigationEndList[0] != "End")
                                _navigationEndList.insert(0, "End");
                              isEditable1 = true;
                              isEditable2 = false;
                              isImageVisible = false;
                            });
                          },
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        CustomSolidButton(
                          width: 120,
                          height: 35,
                          isDisabled: _selectedStartingPoint != null &&
                                  _selectedEndingPoint != null
                              ? null
                              : true,
                          text: "Generate Route",
                          buttonTextSize: 14,
                          onTap: () {
                            _generateRoute();
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Visibility(
                      visible: isImageVisible,
                      child: buildStreamBuilder(width),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void disableFields() {
    setState(() {
      isEditable1 = false;
      isEditable2 = false;
    });
  }

  void _generateRoute() async {
    if (_selectedStartingPoint == "Start") {
      _outletID =
          await _dbHelper.getOutletID(_selectedEndingPoint, isCommon: true);
      setState(() {
        isShopToExit = false;
        isImageVisible = true;
      });
      print(_outletID);

      /// Get the entranceToShop value
    } else {
      _outletID =
          await _dbHelper.getOutletID(_selectedStartingPoint, isCommon: true);
      setState(() {
        isShopToExit = true;
        isImageVisible = true;
      });
      print(_outletID);

      /// Get the shopToExit value
    }
  }

  StreamBuilder<dynamic> buildStreamBuilder(double width) {
    return StreamBuilder(
        stream: _outletID != ""
            ? outletCollectionReference.doc(_outletID).snapshots()
            : null,
        builder: (context, snapshot) {
          var userDocument = snapshot.data;
          if (snapshot.hasError) {
            return Container(
              width: width,
              height: 300,
            );
          }
          if (snapshot.hasData) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                userDocument[!isShopToExit ? "entranceToShop" : "shopToExit"],
                height: 300,
                width: width,
                fit: BoxFit.fitHeight,
              ),
            );
          }
          return Container(
            width: width,
            height: 300,
          );
        });
  }
}
