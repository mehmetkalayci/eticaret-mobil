import 'dart:async';
import 'dart:convert';

import 'package:ecommerce_mobile/main.dart';
import 'package:ecommerce_mobile/models/category_model.dart';
import 'package:ecommerce_mobile/models/homepage_model.dart';
import 'package:ecommerce_mobile/models/product_model.dart';
import 'package:ecommerce_mobile/providers/cart_provider.dart';
import 'package:ecommerce_mobile/providers/menu_provider.dart';
import 'package:ecommerce_mobile/screens/product_details.dart';
import 'package:ecommerce_mobile/widgets/my_appbar.dart';
import 'package:ecommerce_mobile/widgets/my_error_widget.dart';
import 'package:ecommerce_mobile/widgets/my_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage(
      {Key? key, required this.mainCategoryId, required this.subCategoryId})
      : super(key: key);

  final int mainCategoryId;
  final int subCategoryId;

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage>
    with TickerProviderStateMixin {
  List<CategoryModel> mainCategoryList = [];
  List<CategoryModel> subCategoryList = [];

  late CategoryModel selectedCategory;

  int mainCategoryIndex = 0;
  int subCategoryIndex = 0;

  Future<List<CategoryModel>>? futureCategories;

  Future<List<CategoryModel>> fetchCategories() async {
    final response =
        await http.get(Uri.parse('http://qsres.com/api/mobileapp/categories'));

    if (response.statusCode == 200) {
      //return CategoryModel.fromJson(jsonDecode(response.body));

      List jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((item) => new CategoryModel.fromJson(item))
          .toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  void setCategory() {
    this.subCategoryList.clear();
    if (this
            .mainCategoryList
            .elementAt(mainCategoryIndex)
            .inverseParentCategory
            .length >
        0) {
      mainCategoryList[mainCategoryIndex]
          .inverseParentCategory
          .forEach((dynamic subCategory) {
        subCategoryList.add(CategoryModel.fromJson(subCategory));
      });

      selectedCategory = subCategoryList[subCategoryIndex];
    } else {
      selectedCategory = mainCategoryList[mainCategoryIndex];
    }
    futureProducts = fetchProducts(selectedCategory.categoryId);
  }

  //#region Product Çek

  Future<List<ProductModel>>? futureProducts;

  Future<List<ProductModel>> fetchProducts(int categoryId) async {
    final response = await http.get(Uri.parse(
        'http://qsres.com/api/mobileapp/categories/$categoryId/products'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);

      return jsonResponse
          .map((item) => new ProductModel.fromJson(item))
          .toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  //#endregion

  TabController? _tabController;
  TabController? _subCategoryTabController;

  @override
  void initState() {
    mainCategoryIndex = widget.mainCategoryId;
    subCategoryIndex = widget.subCategoryId;
  }

  bool firstLoad = true;

  /*********************/
  final double tabHeight = 50;

  @override
  Widget build(BuildContext context) {
    MenuProvider menu = Provider.of<MenuProvider>(context, listen: false);
    CartProvider cart = Provider.of<CartProvider>(context, listen: false);

    return FutureBuilder(
      future: fetchCategories(),
      builder:
          (BuildContext context, AsyncSnapshot<List<CategoryModel>> snapshot) {
        if (snapshot.hasData) {
          // ana kategorileri temizle ve yükle

          mainCategoryList.clear();
          snapshot.data!.forEach((element) {
            if (element.parentCategoryId == null) mainCategoryList.add(element);
          });

          if (this
                  .mainCategoryList
                  .elementAt(mainCategoryIndex)
                  .inverseParentCategory
                  .length >
              0) {
            // önce alt kategorileri temizle ve yükle
            this.subCategoryList.clear();
            mainCategoryList[mainCategoryIndex]
                .inverseParentCategory
                .forEach((dynamic subCategory) {
              subCategoryList.add(CategoryModel.fromJson(subCategory));
            });

            selectedCategory = subCategoryList[subCategoryIndex];
          } else {
            selectedCategory = mainCategoryList[mainCategoryIndex];
          }

          if (firstLoad) {
            futureProducts = fetchProducts(selectedCategory.categoryId);

            //setCategory();

            _tabController =
                TabController(length: mainCategoryList.length, vsync: this);
            _tabController!.animateTo(mainCategoryIndex);

            _subCategoryTabController =
                TabController(length: subCategoryList.length, vsync: this);
            _subCategoryTabController!.animateTo(subCategoryIndex);

            firstLoad = false;
          } else {
            if (subCategoryIndex == 0) {
              _subCategoryTabController =
                  TabController(length: subCategoryList.length, vsync: this);
              _subCategoryTabController!.animateTo(subCategoryIndex);
            }
          }

          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text(
                mainCategoryList[mainCategoryIndex].name +
                    ((subCategoryList.length > 0)
                        ? " » " + subCategoryList[subCategoryIndex].name
                        : ""),
                style: TextStyle(fontSize: 18),
              ),
              surfaceTintColor: Colors.white,
            ),
            body: NestedScrollView(
              physics: ScrollPhysics(),
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    surfaceTintColor: Colors.white,
                    snap: true,
                    floating: true,
                    forceElevated: true,
                    pinned: true,
                    titleSpacing: 0,
                    automaticallyImplyLeading: false,
                    systemOverlayStyle: SystemUiOverlayStyle(
                      statusBarColor: Theme.of(context).scaffoldBackgroundColor,
                      statusBarBrightness: Brightness.dark,
                      statusBarIconBrightness: Brightness.dark,
                      systemStatusBarContrastEnforced: true,
                    ),
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    /*************/
                    title: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        DefaultTabController(
                          length: mainCategoryList.length,
                          child: TabBar(
                            controller: _tabController,
                            physics: BouncingScrollPhysics(),
                            isScrollable: true,
                            labelColor: Colors.black,
                            indicatorColor: Theme.of(context).primaryColor,
                            padding: EdgeInsets.zero,
                            indicatorPadding: EdgeInsets.zero,
                            overlayColor:
                                MaterialStateProperty.all(Colors.transparent),
                            onTap: (index) {
                              mainCategoryIndex = index;
                              subCategoryIndex = 0;
                              setCategory();
                              setState(() {});
                            },
                            tabs: mainCategoryList
                                .map((e) => Tab(text: e.name))
                                .toList(),
                          ),
                        ),
                        Visibility(
                          visible: subCategoryList.length > 0,
                          child: DefaultTabController(
                            length: subCategoryList.length,
                            child: Container(
                              color: Theme.of(context).primaryColor,
                              child: TabBar(
                                controller: _subCategoryTabController,
                                padding: EdgeInsets.zero,
                                indicatorPadding: EdgeInsets.zero,
                                physics: BouncingScrollPhysics(),
                                isScrollable: true,
                                labelColor: Colors.white,
                                unselectedLabelColor: Colors.white70,
                                indicatorColor: Colors.white,
                                onTap: (index) {
                                  subCategoryIndex = index;

                                  menu.setSubCategoryId(subCategoryIndex);
                                  menu.setCategoryId(mainCategoryIndex);
                                  menu.setCurrentPage(5);

                                  setCategory();
                                  setState(() {});
                                },
                                tabs: subCategoryList
                                    .map((e) => Tab(text: e.name))
                                    .toList(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    toolbarHeight:
                        subCategoryList.length > 0 ? tabHeight * 2 : tabHeight,
                  ),
                ];
              },
              body: CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    child: FutureBuilder(
                      future: futureProducts,
                      builder: (BuildContext context,
                          AsyncSnapshot<List<ProductModel>> snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data!.length > 0) {
                            return GridView.builder(
                                shrinkWrap: true,
                                physics: BouncingScrollPhysics(),
                                padding: EdgeInsets.only(bottom: 120),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  childAspectRatio: 0.7,
                                  crossAxisSpacing: 2,
                                  mainAxisSpacing: 2,
                                  crossAxisCount: 2,
                                ),
                                itemCount: snapshot.data!.length,
                                itemBuilder: (BuildContext ctx, index) {
                                  return MaterialButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: () {
                                      menu.setProductId(
                                          snapshot.data![index].productId);
                                      menu.setCategoryId(menu.categoryId);
                                      menu.setCurrentPage(6);

                                      // Navigator.push(
                                      //   context,
                                      //   PageTransition(
                                      //     type: PageTransitionType.fade,
                                      //     child: ProductDetailPage(
                                      //       productId:
                                      //           snapshot.data![index].productId,
                                      //     ),
                                      //   ),
                                      // );
                                    },
                                    splashColor: Colors.grey.shade200,
                                    highlightColor: Colors.white,
                                    elevation: 0,
                                    focusElevation: 0,
                                    highlightElevation: 0,
                                    hoverElevation: 0,
                                    disabledElevation: 0,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 5,
                                        horizontal: 10,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          snapshot.data![index].productImages
                                                      .length <=
                                                  0
                                              ? Image.asset(
                                                  "assets/images/noimage.jpg",
                                                  height: 200,
                                                  width: 200,
                                                )
                                              : Image.network(
                                                  snapshot.data![index]
                                                      .productImages[0].src,
                                                  height: 200,
                                                  width: 200,
                                                ),
                                          Flexible(
                                            child: Text(
                                              snapshot.data![index].productName,
                                              style: TextStyle(fontSize: 16),
                                              /*textAlign: TextAlign.center,*/
                                            ),
                                          ),
                                          Flexible(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  snapshot.data![index]
                                                          .isDiscounted
                                                      ? snapshot.data![index]
                                                              .discountedPrice
                                                              .toString() +
                                                          " ₺"
                                                      : snapshot.data![index]
                                                              .sellingPrice
                                                              .toString() +
                                                          " ₺",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 18),
                                                ),
                                                MaterialButton(
                                                  onPressed: () {
                                                    cart.insertItem(
                                                        snapshot.data![index]
                                                            .productId,
                                                        1);
                                                  },
                                                  child: Icon(Icons.add_rounded,
                                                      size: 35),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            13),
                                                  ),
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  textColor: Colors.white,
                                                  clipBehavior: Clip
                                                      .antiAliasWithSaveLayer,
                                                  height: 50,
                                                  minWidth: 35,
                                                  padding: EdgeInsets.zero,
                                                  elevation: 0,
                                                  disabledElevation: 0,
                                                  hoverElevation: 0,
                                                  highlightElevation: 0,
                                                  focusElevation: 0,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          } else {
                            return Padding(
                              padding: EdgeInsets.all(20),
                              child: Center(
                                child: Text(
                                  selectedCategory.name +
                                      " kategorisinde ürün bulunamadı.",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          }
                        } else if (snapshot.hasError) {
                          return Text(snapshot.error.toString());
                        }
                        return Center(child: CircularProgressIndicator());
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        } else if (snapshot.hasError) {
          print(snapshot.error);
          return MyErrorWidget(context);
        }
        return MyLoadingWidget(context);
      },
    );
  }
}
