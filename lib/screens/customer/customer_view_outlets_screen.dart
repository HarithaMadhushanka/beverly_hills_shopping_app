import 'package:beverly_hills_shopping_app/components/custom_sliver_app_bar_common.dart';
import 'package:beverly_hills_shopping_app/screens/customer/customer_view_outlets_details_screen.dart';
import 'package:beverly_hills_shopping_app/utils/common_functions.dart'
    as common;
import 'package:beverly_hills_shopping_app/utils/enums.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CustomerViewOutletsScreen extends StatefulWidget {
  const CustomerViewOutletsScreen({Key key, @required this.isComingFromDrawer})
      : super(key: key);
  final bool isComingFromDrawer;

  @override
  _CustomerViewOutletsScreenState createState() =>
      _CustomerViewOutletsScreenState();
}

class _CustomerViewOutletsScreenState extends State<CustomerViewOutletsScreen> {
  int _selectedCategoryIndex = 0;
  String _selectedCategory = "";
  String _searchItem = "";
  TextEditingController _categoryTextEditingController =
      TextEditingController();

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
            title: 'Outlets',
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
                                    itemCount: outletCategories.length,
                                    itemBuilder: (context, index) {
                                      return Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _selectedCategoryIndex = index;
                                                _selectedCategory =
                                                    outletCategories[index];
                                              });
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
                              controller: _categoryTextEditingController,
                              textCapitalization: TextCapitalization.sentences,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(top: 15),
                                  hintText: "Search Outlets...",
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
                                    visible:
                                        _categoryTextEditingController.text !=
                                                ""
                                            ? true
                                            : false,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _categoryTextEditingController.text =
                                              "";
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
                                      _categoryTextEditingController
                                          .text.isEmpty
                                  ? outletCollectionReference.snapshots()
                                  : _selectedCategoryIndex != 0 &&
                                          _categoryTextEditingController
                                              .text.isEmpty
                                      ? outletCollectionReference
                                          .where('category',
                                              isEqualTo: _selectedCategory)
                                          .snapshots()
                                      : _selectedCategoryIndex == 0 &&
                                              _categoryTextEditingController
                                                  .text.isNotEmpty
                                          ? outletCollectionReference
                                              .where('outletName',
                                                  isEqualTo: _searchItem)
                                              .snapshots()
                                          : outletCollectionReference
                                              .where('category',
                                                  isEqualTo: _selectedCategory)
                                              .where('outletName',
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
                                      DocumentSnapshot outlet =
                                          snapshot.data.docs[index];

                                      return Column(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) =>
                                                      CustomerViewOutletsDetailsScreen(
                                                    outlet: outlet,
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
                                                            outlet[
                                                                "profilePicUrl"],
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
                                                            outlet[
                                                                "outletName"],
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
                                                                outlet[
                                                                    "outletDesc"],
                                                                style:
                                                                    TextStyle(
                                                                  color:
                                                                      PrimaryColorDark,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontSize: 14,
                                                                ),
                                                                textAlign:
                                                                    TextAlign
                                                                        .justify,
                                                              ),
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
