import 'dart:convert';

import 'package:ecommerce_mobile/widgets/my_error_widget.dart';
import 'package:ecommerce_mobile/widgets/my_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/homepage_model.dart';

class Xpage extends StatefulWidget {
  const Xpage({Key? key}) : super(key: key);

  @override
  State<Xpage> createState() => _XpageState();
}

class _XpageState extends State<Xpage> with TickerProviderStateMixin {
  List<Widget> list = [];
  List subCategories = [];
  late TabController? _categoryTabController;

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
  void initState() {
    _categoryTabController = null;
  }

  @override
  void dispose() {
    _categoryTabController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              child: TabBar(
                isScrollable: true,
                padding: EdgeInsets.all(20),
                physics: BouncingScrollPhysics(),
                tabs: this.list,
                controller: _categoryTabController,
              ),
            ),
            Container(
              height: 80,
              color: Colors.blueGrey,
              child: ListView(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                children: this
                    .subCategories
                    .map(
                      (e) => MaterialButton(
                          onPressed: () {}, child: Text(e.toString())),
                    )
                    .toList(),
              ),
            ),
            Container(
              height: 300,
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}
