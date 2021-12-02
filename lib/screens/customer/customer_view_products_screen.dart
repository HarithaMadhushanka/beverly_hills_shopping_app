import 'package:beverly_hills_shopping_app/components/custom_sliver_app_bar_common.dart';
import 'package:beverly_hills_shopping_app/database/db_helper.dart';
import 'package:beverly_hills_shopping_app/screens/customer/customer_view_product_details.dart';
import 'package:beverly_hills_shopping_app/utils/common_functions.dart'
    as common;
import 'package:beverly_hills_shopping_app/utils/enums.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CustomerViewProductsScreen extends StatefulWidget {
  const CustomerViewProductsScreen({Key key, @required this.isComingFromDrawer})
      : super(key: key);
  final bool isComingFromDrawer;

  @override
  _CustomerViewProductsScreenState createState() =>
      _CustomerViewProductsScreenState();
}

class _CustomerViewProductsScreenState
    extends State<CustomerViewProductsScreen> {
  int _selectedCategoryIndex = 0;
  String _selectedCategory = "";
  String _searchItem = "";
  TextEditingController _searchProductTextEditingController =
      TextEditingController();
  DBHelper _dbHelper = DBHelper();

  @override
  void initState() {
    if (outletCategories[0] != "All") {
      outletCategories.insert(0, "All");
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: SecondaryColorLight,
      body: CustomScrollView(
        physics: NeverScrollableScrollPhysics(),
        slivers: [
          /// SLiver App bar
          buildCustomSliverAppBarCommon(
            context: context,
            isBackNeeded: widget.isComingFromDrawer ? true : false,
            title: 'Products',
            isTrailingNeeded: false,
          ),
          SliverFillRemaining(
            child: SingleChildScrollView(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 25),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Container(
                                  height: 60,
                                  child: ListView.builder(
                                    physics: const BouncingScrollPhysics(
                                        parent:
                                            AlwaysScrollableScrollPhysics()),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: productCategories.length,
                                    itemBuilder: (context, index) {
                                      return Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () async {
                                              String _categoryID = "";
                                              setState(() {
                                                _selectedCategoryIndex = index;
                                                _selectedCategory =
                                                    outletCategories[index];
                                              });

                                              if (_selectedCategory != "All") {
                                                _dbHelper.sendStatistics(
                                                    common.getDay(),
                                                    common.getCurrentHourIn24(),
                                                    type: 'category',
                                                    id: _selectedCategory,
                                                    shouldUpdate: false);
                                              }
                                            },
                                            child: Container(
                                              padding: EdgeInsets.fromLTRB(
                                                  15, 5, 15, 5),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                border: Border.all(
                                                  color:
                                                      _selectedCategoryIndex ==
                                                              index
                                                          ? SecondaryColorDark
                                                          : PrimaryColorDark,
                                                ),
                                                color: _selectedCategoryIndex ==
                                                        index
                                                    ? PrimaryColorLight
                                                    : SecondaryColorLight,
                                              ),
                                              child: Text(
                                                outletCategories[index],
                                                style: TextStyle(
                                                  color: PrimaryColorDark,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 25),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.black),
                            ),
                            child: TextFormField(
                              controller: _searchProductTextEditingController,
                              textCapitalization: TextCapitalization.sentences,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(top: 15),
                                  hintText: "Search Products...",
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  icon: Container(
                                    padding: const EdgeInsets.only(left: 12),
                                    child: IntrinsicHeight(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.search,
                                            size: 22,
                                            color: SecondaryColorDark,
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          VerticalDivider(
                                            width: 5,
                                            color: PrimaryColorDark,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  suffixIcon: Visibility(
                                    visible: _searchProductTextEditingController
                                                .text !=
                                            ""
                                        ? true
                                        : false,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _searchProductTextEditingController
                                              .text = "";
                                        });
                                      },
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8),
                                        child: Icon(
                                          Icons.cancel,
                                          size: 22,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  )),
                              onChanged: (value) {
                                setState(() {
                                  _searchItem = common.capitalize(value);
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          StreamBuilder<QuerySnapshot>(
                              stream: _selectedCategoryIndex == 0 &&
                                      _searchProductTextEditingController
                                          .text.isEmpty
                                  ? productCollectionReference.snapshots()
                                  : _selectedCategoryIndex != 0 &&
                                          _searchProductTextEditingController
                                              .text.isEmpty
                                      ? productCollectionReference
                                          .where('productCategory',
                                              isEqualTo: _selectedCategory)
                                          .snapshots()
                                      : _selectedCategoryIndex == 0 &&
                                              _searchProductTextEditingController
                                                  .text.isNotEmpty
                                          ? productCollectionReference
                                              .where('productTitle',
                                                  isEqualTo: _searchItem)
                                              .snapshots()
                                          : productCollectionReference
                                              .where('productCategory',
                                                  isEqualTo: _selectedCategory)
                                              .where('productTitle',
                                                  isEqualTo: _searchItem)
                                              .snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (!snapshot.hasData) return Text("");
                                return Container(
                                  height: widget.isComingFromDrawer
                                      ? height * 0.66
                                      : height * 0.6,
                                  child: ListView.builder(
                                    physics: const BouncingScrollPhysics(
                                        parent:
                                            AlwaysScrollableScrollPhysics()),
                                    scrollDirection: Axis.vertical,
                                    itemCount: snapshot.data.docs.length,
                                    itemBuilder: (context, index) {
                                      DocumentSnapshot product =
                                          snapshot.data.docs[index];

                                      return Column(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              if (_searchProductTextEditingController.text !=
                                                      "" &&
                                                  _searchProductTextEditingController
                                                          .text !=
                                                      null &&
                                                  snapshot.data.docs.length !=
                                                      null) {}

                                              _dbHelper.sendStatistics(
                                                  common.getDay(),
                                                  common.getCurrentHourIn24(),
                                                  type: 'product',
                                                  id: product["productID"],
                                                  shouldUpdate: false);
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) =>
                                                      CustomerViewProductDetailsScreen(
                                                    product: product,
                                                  ),
                                                ),
                                              );
                                            },
                                            behavior: HitTestBehavior.opaque,
                                            child: Container(
                                              height: 120,
                                              decoration: BoxDecoration(
                                                color: PrimaryColorLight,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                border: Border.all(
                                                    color: PrimaryColorDark),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        10, 10, 10, 10),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              right: 10),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        border: Border.all(
                                                            color:
                                                                PrimaryColorDark),
                                                      ),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        child: Container(
                                                          height: 90,
                                                          width: 70,
                                                          child: Image.network(
                                                            product[
                                                                "productPicUrl"],
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          SizedBox(
                                                            height: 2,
                                                          ),
                                                          Text(
                                                            product[
                                                                "productTitle"],
                                                            style: TextStyle(
                                                              color:
                                                                  PrimaryColorDark,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 18,
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Container(
                                                              child: Text(
                                                                product[
                                                                    "productDesc"],
                                                                style:
                                                                    TextStyle(
                                                                  color:
                                                                      PrimaryColorDark,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontSize: 14,
                                                                ),
                                                                maxLines: 3,
                                                                textAlign:
                                                                    TextAlign
                                                                        .justify,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 3,
                                                          ),
                                                          Container(
                                                            child: Text(
                                                              "\$" +
                                                                  product[
                                                                      'productPrice'] +
                                                                  ".00",
                                                              style: TextStyle(
                                                                color:
                                                                    PrimaryColorDark,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 16,
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                );
                              }),
                        ],
                      ),
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
}
