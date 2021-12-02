import 'package:beverly_hills_shopping_app/components/CustomReportContainer.dart';
import 'package:beverly_hills_shopping_app/components/custom_sliver_app_bar_common.dart';
import 'package:beverly_hills_shopping_app/components/custom_solid_button.dart';
import 'package:beverly_hills_shopping_app/database/db_helper.dart';
import 'package:beverly_hills_shopping_app/models/outlet.dart';
import 'package:beverly_hills_shopping_app/models/product.dart';
import 'package:beverly_hills_shopping_app/models/report.dart';
import 'package:beverly_hills_shopping_app/utils/common_functions.dart'
    as common;
import 'package:beverly_hills_shopping_app/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class AdminReportsScreen extends StatefulWidget {
  const AdminReportsScreen({Key key, this.dateRangeList}) : super(key: key);
  final List dateRangeList;

  @override
  _AdminReportsScreenState createState() => _AdminReportsScreenState();
}

class _AdminReportsScreenState extends State<AdminReportsScreen> {
  DBHelper _dbHelper = DBHelper();
  String _selectedDateRange;
  List _dateRangeList = [];
  Report _report = Report();

  List<Color> _colors = [
    Colors.red.withOpacity(0.2),
    Colors.yellow.withOpacity(0.2),
    Colors.green.withOpacity(0.2),
    Colors.orange.withOpacity(0.2),
  ];

  int _mostClickedProductCount = 0;
  int _mostClickedCategoryCount = 0;
  int _mostClickedOutletCount = 0;
  int _bestSellingProductCount = 0;

  String _mostClickedCategory = "";

  Product _highestClickedProductObj = Product();
  Product _bestSellingProductObj = Product();
  Outlet _highestClickedOutletObj = Outlet();

  Map<String, double> data = new Map();
  Map<String, double> data2 = new Map();
  bool _loadChart = false;
  bool _isVisible = false;
  bool _isReady = false;

  List<Color> _colors2 = [
    Colors.teal,
    Colors.blueAccent,
    Colors.amberAccent,
    Colors.redAccent,
    Colors.cyanAccent,
    Colors.greenAccent,
    Colors.deepPurpleAccent,
  ];

  @override
  void initState() {
    _dateRangeList = widget.dateRangeList;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: SecondaryColorLight,
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          /// SLiver App bar
          buildCustomSliverAppBarCommon(
            context: context,
            isBackNeeded: true,
            title: "Reports",
            isTrailingNeeded: false,
          ),
          SliverFillRemaining(
            child: SingleChildScrollView(
              child: Container(
                // height: height * 2,
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: width * 0.9,
                            height: 60,
                            decoration: BoxDecoration(
                              border: Border.all(color: PrimaryColorDark),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: DropdownButtonFormField(
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(top: 10),
                                hintText: 'Date Range',
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                icon: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 20, top: 10),
                                  child: Icon(
                                    Icons.list,
                                    size: 22,
                                    color: SecondaryColorDark,
                                  ),
                                ),
                              ),
                              value: _selectedDateRange,
                              onChanged: (newValue) {
                                setState(() {
                                  _selectedDateRange = newValue;
                                });
                              },
                              items: _dateRangeList.map((category) {
                                return DropdownMenuItem(
                                  child: Text(category),
                                  value: category,
                                );
                              }).toList(),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          CustomSolidButton(
                            width: 80,
                            height: 30,
                            text: "Generate",
                            isDisabled:
                                _selectedDateRange == null ? true : null,
                            buttonTextSize: 12,
                            onTap: () async {
                              _report = await _dbHelper
                                  .getReportData(_selectedDateRange);

                              if (!_isReady) {
                                data.addAll({
                                  'Monday - ${_report.monday}':
                                      double.parse(_report.monday),
                                  'Tuesday - ${_report.tuesday}':
                                      double.parse(_report.tuesday),
                                  'Wednesday - ${_report.wednesday}':
                                      double.parse(_report.wednesday),
                                  'Thursday - ${_report.thursday}':
                                      double.parse(_report.thursday),
                                  'Friday - ${_report.friday}':
                                      double.parse(_report.friday),
                                  'Saturday - ${_report.saturday}':
                                      double.parse(_report.saturday),
                                  'Sunday - ${_report.sunday}':
                                      double.parse(_report.sunday),
                                });
                                data2.addAll({
                                  '9am - 12pm - ${_report.time9_12}':
                                      double.parse(_report.time9_12),
                                  '12pm - 3pm - ${_report.time12_15}':
                                      double.parse(_report.time12_15),
                                  '3pm - 6pm - ${_report.time15_18}':
                                      double.parse(_report.time15_18),
                                  '6pm - 9pm - ${_report.time18_21}':
                                      double.parse(_report.time18_21),
                                  '9pm - 12pm - ${_report.time21_24}':
                                      double.parse(_report.time21_24),
                                });
                              }

                              _isVisible = true;
                              _generateReport(_report);
                            },
                          ),
                          _isReady
                              ? buildReport(width, height)
                              : !_isReady && _isVisible
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 150),
                                      child: Column(
                                        children: [
                                          CircularProgressIndicator(),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 15),
                                            child: Text('Generating Report...'),
                                          )
                                        ],
                                      ),
                                    )
                                  : Container(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container buildReport(double width, double height) {
    return Container(
      padding: EdgeInsets.only(top: 25),
      width: width,
      // height: height * 0.9,
      child: Column(
        children: [
          buildCustomReportComponentPrimary(
            width,
            _colors[2],
            "Best Selling Product of the Week",
            _bestSellingProductObj.productTitle != null
                ? _bestSellingProductObj.productTitle
                : "Product Name",
            _mostClickedProductCount != 0
                ? (_mostClickedProductCount.toString() + " Sales in total")
                : "0 Sales",
            _bestSellingProductObj.productPicUrl != null
                ? _bestSellingProductObj.productPicUrl
                : "",
          ),
          SizedBox(
            height: 15,
          ),
          buildCustomReportComponentPrimary(
            width,
            _colors[3],
            "Highest Searched Product of the Week",
            _highestClickedProductObj.productTitle != null
                ? _highestClickedProductObj.productTitle
                : "Product Name",
            _bestSellingProductCount != 0
                ? (_bestSellingProductCount.toString() + " Searches in total")
                : "0 Searches",
            _highestClickedProductObj.productPicUrl != null
                ? _highestClickedProductObj.productPicUrl
                : "",
          ),
          SizedBox(
            height: 15,
          ),
          buildCustomReportComponentPrimary(
              width,
              _colors[1],
              "Mostly Searched Outlet of the Week",
              _highestClickedOutletObj.outletName != null
                  ? _highestClickedOutletObj.outletName
                  : "Outlet Name",
              _mostClickedOutletCount != 0
                  ? (_mostClickedOutletCount.toString() + " Searches in total")
                  : "0 Searches",
              _highestClickedOutletObj.profilePicUrl != null
                  ? _highestClickedOutletObj.profilePicUrl
                  : ""),
          SizedBox(
            height: 15,
          ),
          buildCustomReportComponentPrimary(
            width,
            _colors[0],
            "Mostly Searched Category of the Week",
            _mostClickedCategory != "" ? _mostClickedCategory : "Category Name",
            _mostClickedCategoryCount != 0
                ? _mostClickedCategoryCount.toString() + " Searches in total"
                : "0 searches",
            '',
          ),
          SizedBox(
            height: 25,
          ),
          _loadChart
              ? Container(
                  width: width * 0.8,
                  child: PieChart(
                    dataMap: data,
                    chartValuesOptions: ChartValuesOptions(
                        decimalPlaces: 0, showChartValuesInPercentage: true),
                    animationDuration: Duration(milliseconds: 1500),
                    chartLegendSpacing: 35.0,
                    chartRadius: MediaQuery.of(context).size.width / 2.9,
                    chartType: ChartType.disc,
                  ),
                )
              : Container(),
          Center(child: Text("People count against the day within this week")),
          SizedBox(
            height: 25,
          ),
          _loadChart
              ? Container(
                  width: width * 0.8,
                  child: PieChart(
                    dataMap: data2,
                    chartValuesOptions: ChartValuesOptions(
                        decimalPlaces: 0, showChartValuesInPercentage: true),
                    animationDuration: Duration(milliseconds: 1500),
                    chartLegendSpacing: 35.0,
                    chartRadius: MediaQuery.of(context).size.width / 2.9,
                    chartType: ChartType.disc,
                  ),
                )
              : Container(),
          Center(
              child: Text(
            "Time Range people have come in the most within this week",
            textAlign: TextAlign.center,
          )),
          SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }

  Future _generateReport(Report _report) async {
    /// Gets the most clicked product
    await common
        .getHighestCountItem(_report, type: 'product')
        .then((value) async {
      _highestClickedProductObj =
          await _dbHelper.getProductData(value[0].toString());
      setState(() {
        _mostClickedProductCount = value[1];
      });
    });

    /// Gets the best selling product
    await common
        .getHighestCountItem(_report, type: 'order')
        .then((value) async {
      _bestSellingProductObj =
          await _dbHelper.getProductData(value[0].toString());

      setState(() {
        _bestSellingProductCount = value[1];
      });
    });

    /// Gets the most clicked outlet
    await common
        .getHighestCountItem(_report, type: 'outlet')
        .then((value) async {
      _highestClickedOutletObj =
          await _dbHelper.getOutletData(value[0].toString());

      setState(() {
        _mostClickedOutletCount = value[1];
      });
    });

    /// Gets the most clicked category
    await common.getHighestCountItem(_report, type: 'category').then((value) {
      setState(() {
        _mostClickedCategory = value[0].toString();
        _mostClickedCategoryCount = value[1];
      });
    });
    setState(() {
      _loadChart = true;
      _isReady = true;
    });
  }
}
