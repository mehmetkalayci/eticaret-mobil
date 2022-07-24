import 'dart:convert';

import 'package:ecommerce_mobile/models/homepage_model.dart';
import 'package:ecommerce_mobile/screens/product_details.dart';
import 'package:ecommerce_mobile/widgets/my_appbar.dart';
import 'package:ecommerce_mobile/widgets/my_error_widget.dart';
import 'package:ecommerce_mobile/widgets/my_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:page_transition/page_transition.dart';
import 'package:http/http.dart' as http;

class ProductListPage extends StatefulWidget {
  const ProductListPage({Key? key}) : super(key: key);

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage>
    with TickerProviderStateMixin {
  late List<CategoryModel> mainCategoryList;
  List<String> subCategoryList = [];

  late TabController _categoryTabController;
  late TabController _subCategoryTabController;

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

  @override
  void dispose() {
    super.dispose();
    _categoryTabController.dispose();
    _subCategoryTabController.dispose();
  }

  void setSubCats(index) {
    this.subCategoryList.clear();
    if (this
        .mainCategoryList
        .elementAt(index)
        .inverseParentCategory
        .isNotEmpty) {
      this.subCategoryList.addAll(this
          .mainCategoryList[index]
          .inverseParentCategory
          .map((e) => e['name']));
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchCategories(),
      builder:
          (BuildContext context, AsyncSnapshot<List<CategoryModel>> snapshot) {
        if (snapshot.hasData) {
          mainCategoryList = snapshot.data!
              .where((element) => element.parentCategoryId == null)
              .toList();

          _categoryTabController =
              TabController(length: mainCategoryList.length, vsync: this);
          _subCategoryTabController =
              TabController(vsync: this, length: this.subCategoryList.length);

          return Scaffold(
              body: CustomScrollView(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            slivers: <Widget>[
              MyAppBar("Kategori Adı Gelecek", null, context,
                  automaticallyImplyLeading: true),
              SliverToBoxAdapter(
                child: TabBar(
                  physics: BouncingScrollPhysics(),
                  labelColor: Colors.black,
                  isScrollable: true,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorWeight: 2.5,
                  indicatorColor: Theme.of(context).primaryColor,
                  labelStyle: TextStyle(fontSize: 16, fontFamily: "Poppins"),
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                  controller: _categoryTabController,
                  tabs: mainCategoryList
                      .map((element) => Text(element.name))
                      .toList(),
                  onTap: (index) {
                    setState(() {
                      setSubCats(index);
                    });
                  },
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  indicatorPadding: EdgeInsets.only(bottom: -5),
                ),
              ),
              SliverToBoxAdapter(
                child: Visibility(
                  visible: this.subCategoryList.length > 0,
                  child: Container(
                    color: Theme.of(context).primaryColor,
                    child: TabBar(
                      physics: BouncingScrollPhysics(),
                      labelColor: Colors.white,
                      isScrollable: true,
                      indicatorSize: TabBarIndicatorSize.label,
                      indicatorWeight: 2.5,
                      indicatorColor: Colors.white,
                      labelStyle:
                          TextStyle(fontSize: 16, fontFamily: "Poppins"),
                      overlayColor:
                          MaterialStateProperty.all(Colors.transparent),
                      controller: _subCategoryTabController,
                      tabs: subCategoryList
                          .map((element) => Text(element))
                          .toList(),
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                      indicatorPadding: EdgeInsets.only(bottom: -5),
                    ),
                  ),
                ),
              ),

              /*----------------------------------------------*/

              SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 2,
                  childAspectRatio: 0.8,
                ),
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return MaterialButton(
                      onPressed: () {
                        // todo: ürün id atanacak
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.fade,
                            child: ProductDetailPage(productId: 1),
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
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Flexible(
                              child: Image.network(
                                'https://cdn.cimri.io/image/1200x1200/neroxmakasfiyatlar_431537795.jpg',
                                height: 180,
                                width: 180,
                              ),
                            ),
                            Flexible(
                              child: Text(
                                'Powertec Saç TR-901 Fön Makinesi',
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
                                    '190,00 ₺',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18),
                                  ),
                                  MaterialButton(
                                    onPressed: () {},
                                    child: Icon(Icons.add_rounded, size: 35),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(13),
                                    ),
                                    color: Theme.of(context).primaryColor,
                                    textColor: Colors.white,
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
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
                  },
                  childCount: 51,
                ),
              ),
            ],
          ));
        } else if (snapshot.hasError) {
          return MyErrorWidget(context);
        }
        return MyLoadingWidget(context);
      },
    );
  }
}
