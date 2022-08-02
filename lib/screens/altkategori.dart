import 'dart:convert';

import 'package:ecommerce_mobile/models/category_model.dart';
import 'package:ecommerce_mobile/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AltKategoriPage extends StatefulWidget {
  const AltKategoriPage({Key? key}) : super(key: key);

  @override
  State<AltKategoriPage> createState() => _AltKategoriPAgeState();
}

class _AltKategoriPAgeState extends State<AltKategoriPage> {
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

  List<CategoryModel> mainCategoryList = [];
  List<String> subCategoryList = [];

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
    setState(() {});
  }

  //
  // @override
  // void initState() {
  //   this.fetchCategories();
  //   setSubCats(0);
  // }

  Future<List<ProductModel>> fetchProducts(categoryId) async {
    final response = await http.get(Uri.parse('http://qsres.com/api/mobileapp/categories/$categoryId/products'));

    if (response.statusCode == 200) {
      //return CategoryModel.fromJson(jsonDecode(response.body));

      List jsonResponse = json.decode(response.body);
      print(jsonResponse);
      return jsonResponse.map((item) => new ProductModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          FutureBuilder(
            future: fetchCategories(),
            builder: (BuildContext context,
                AsyncSnapshot<List<CategoryModel>> snapshot) {

              print(snapshot);

              if (snapshot.hasData) {
                mainCategoryList = snapshot.data!
                    .where((element) => element.parentCategoryId == null)
                    .toList();

                return DefaultTabController(
                  length: snapshot.data!.length,
                  child: TabBar(
                    isScrollable: true,
                    labelColor: Colors.black,
                    tabs: snapshot.data!.map((e) => Tab(text: e.name)).toList(),
                    onTap: (index) {
                      print(snapshot.data![index].name);
                      setSubCats(index);

                      if (this.mainCategoryList.elementAt(index).inverseParentCategory.isNotEmpty) {
                        this.subCategoryList.addAll(this.mainCategoryList[index].inverseParentCategory.map((e) => e['name']));
                        print(this.mainCategoryList[index].inverseParentCategory[0]['name']);
                        fetchProducts(mainCategoryList[index].categoryId);
                        //fetchProducts(this.mainCategoryList[index].inverseParentCategory[0]['categoryId']);
                      }
                    }
                  ),
                );
              } else if (snapshot.hasError) {
                return Container(child: Text('Kategoriler Yüklenemedi'));
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
          Visibility(
            visible: subCategoryList.isNotEmpty && subCategoryList.length > 0,
            child: DefaultTabController(
              initialIndex: 0,
              length: subCategoryList.length,
              child: TabBar(
                isScrollable: true,
                labelColor: Colors.black,
                tabs: subCategoryList.map((e) => Tab(text: e)).toList(),
                onTap: (index) {
                  print(subCategoryList[index]);
                  fetchProducts(subCategoryList[index][0]);
                },
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
