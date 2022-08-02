import 'dart:async';
import 'dart:convert';

import 'package:ecommerce_mobile/main.dart';
import 'package:ecommerce_mobile/models/category_model.dart';
import 'package:ecommerce_mobile/models/homepage_model.dart';
import 'package:ecommerce_mobile/models/product_model.dart';
import 'package:ecommerce_mobile/screens/product_details.dart';
import 'package:ecommerce_mobile/widgets/my_appbar.dart';
import 'package:ecommerce_mobile/widgets/my_error_widget.dart';
import 'package:ecommerce_mobile/widgets/my_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:http/http.dart' as http;

class ProductListPage extends StatefulWidget {
  const ProductListPage({Key? key, required this.mainCategoryId})
      : super(key: key);

  final int mainCategoryId;

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
    print(selectedCategory.name);
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

  @override
  void initState() {
    mainCategoryIndex = widget.mainCategoryId;
  }

  bool firstLoad = true;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchCategories(),
      builder:
          (BuildContext context, AsyncSnapshot<List<CategoryModel>> snapshot) {
        if (snapshot.hasData) {
          mainCategoryList.clear();
          snapshot.data!.forEach((element) {
            if (element.parentCategoryId == null) mainCategoryList.add(element);
          });

          selectedCategory = mainCategoryList[mainCategoryIndex];

          if (firstLoad) {
            futureProducts = fetchProducts(selectedCategory.categoryId);

            setCategory();

            _tabController =
                TabController(length: mainCategoryList.length, vsync: this);
            _tabController!.animateTo(mainCategoryIndex);
            firstLoad = false;
          }

          return Scaffold(
              body: CustomScrollView(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            slivers: <Widget>[
              SliverAppBar(
                pinned: true,
                floating: true,
                title: Text(selectedCategory.name),
                toolbarHeight: 60,
                collapsedHeight: 150,
                expandedHeight: 150,
                surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
                automaticallyImplyLeading: true,
                elevation: 1,
                titleSpacing: 10,
                systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: Theme.of(context).scaffoldBackgroundColor,
                  statusBarBrightness: Brightness.dark,
                  statusBarIconBrightness: Brightness.dark,
                  systemStatusBarContrastEnforced: true,
                ),
                shape: Border(
                  bottom: BorderSide(width: 1.5, color: Colors.grey.shade200),
                ),
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(),
                  expandedTitleScale: 1,
                  title: SizedBox(
                    height: 110,
                    child: Column(
                      children: [
                        Flexible(
                          child: DefaultTabController(
                            length: mainCategoryList.length,
                            child: TabBar(
                              controller: _tabController,
                              physics: BouncingScrollPhysics(),
                              isScrollable: true,
                              labelColor: Colors.black,
                              onTap: (index) {
                                mainCategoryIndex = index;
                                setCategory();
                                setState(() {});
                              },
                              tabs: mainCategoryList
                                  .map((e) => Tab(text: e.name))
                                  .toList(),
                            ),
                          ),
                        ),
                        Flexible(
                          child: DefaultTabController(
                            length: subCategoryList.length,
                            child: TabBar(
                              padding: EdgeInsets.all(10),
                              physics: BouncingScrollPhysics(),
                              isScrollable: true,
                              labelColor: Colors.black,
                              onTap: (index) {
                                subCategoryIndex = index;
                                setCategory();
                                setState(() {});
                              },
                              tabs: subCategoryList
                                  .map((e) => Tab(text: e.name))
                                  .toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  titlePadding: EdgeInsets.zero,
                ),
              ),

              /*----------------------------------------------*/

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
                            padding: EdgeInsets.zero,
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 200,
                              childAspectRatio: 0.75,
                              crossAxisSpacing: 2.5,
                              mainAxisSpacing: 2.5,
                            ),
                            itemCount: snapshot.data!.length,
                            itemBuilder: (BuildContext ctx, index) {
                              return MaterialButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType.fade,
                                      child: ProductDetailPage(
                                        productId:
                                            snapshot.data![index].productId,
                                      ),
                                    ),
                                  );
                                },
                                color: Colors.white,
                                splashColor: Colors.grey.shade200,
                                highlightColor: Colors.white,
                                elevation: 0,
                                focusElevation: 0,
                                highlightElevation: 0,
                                hoverElevation: 0,
                                disabledElevation: 0,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Flexible(
                                        child: Image.network(
                                          snapshot.data![index].productImages
                                              .first.src,
                                          height: 180,
                                          width: 180,
                                        ),
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
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              snapshot.data![index].isDiscounted
                                                  ? snapshot.data![index]
                                                      .discountedPrice
                                                      .toString()
                                                  : snapshot
                                                      .data![index].sellingPrice
                                                      .toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 18),
                                            ),
                                            MaterialButton(
                                              onPressed: () {},
                                              child: Icon(Icons.add_rounded,
                                                  size: 35),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(13),
                                              ),
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              textColor: Colors.white,
                                              clipBehavior:
                                                  Clip.antiAliasWithSaveLayer,
                                              height: 40,
                                              minWidth: 40,
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
                        return Center(
                            child: Text(
                          selectedCategory.name +
                              " kategorisinde ürün bulunamadı.",
                          textAlign: TextAlign.center,
                        ));
                      }
                    } else if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    }
                    return Center(child: CircularProgressIndicator());
                  },
                ),
              ),
            ],
          ));
        } else if (snapshot.hasError) {
          print(snapshot.error);

          return MyErrorWidget(context);
        }
        return MyLoadingWidget(context);
      },
    );
  }
}
