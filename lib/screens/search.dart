import 'dart:convert';

import 'package:ecommerce_mobile/models/search_result_model.dart';
import 'package:ecommerce_mobile/providers/menu_provider.dart';
import 'package:ecommerce_mobile/screens/product_details.dart';
import 'package:ecommerce_mobile/widgets/my_error_widget.dart';
import 'package:ecommerce_mobile/widgets/my_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {


  //#region Fetch Search Result

  String query = '';


  Future<List<SearchResultModel>> fetchSearchResult(String query) async {
    if (query.trim() != "") {
      final response = await http.get(Uri.parse('http://qsres.com/api/mobileapp/search?q=$query'));
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response, then parse the JSON.
        List jsonResponse = json.decode(response.body);
        return jsonResponse
            .map((item) => new SearchResultModel.fromJson(item))
            .toList();
      }
    }
    return [];
  }



  //#endregion

  @override
  Widget build(BuildContext context) {

    MenuProvider menu = Provider.of<MenuProvider>(context, listen: false);

    return FutureBuilder(
        future: fetchSearchResult(query),
        builder: (BuildContext context, AsyncSnapshot<List<SearchResultModel>> snapshot) {
          if (snapshot.hasData) {
            return CustomScrollView(
              physics: ScrollPhysics(),
              slivers: <Widget>[
                SliverAppBar(
                  surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
                  automaticallyImplyLeading: false,
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
                  pinned: true,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  toolbarHeight: 90,
                  title: Row(
                    children: [
                      SizedBox(width: 10),
                      Icon(Icons.search_rounded),
                      SizedBox(width: 10),
                      Flexible(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "Ürün Ara",
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Colors.black87),
                          ),
                          cursorWidth: 1,
                          cursorColor: Colors.black,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                          ),
                          onChanged: (val) {
                            setState(() => query = val);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SliverToBoxAdapter(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:
                          snapshot.data != null && snapshot.data!.length > 0
                              ? snapshot.data!.map((element) {

                                  return ListTile(
                                    onTap: () {

                                      menu.setMenuIndex(6, productId: element.productId);


                                      // Navigator.push(
                                      //   context,
                                      //   PageTransition(
                                      //     type: PageTransitionType.fade,
                                      //     child: ProductDetailPage(productId: element.productId),
                                      //   ),
                                      // );
                                    },
                                    title: Text(element.productName),
                                    subtitle: Text(element.name),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 20),
                                  );
                                }).toList()
                              : [
                                  Padding(
                                    padding: EdgeInsets.all(30),
                                    child: Text(
                                      "Herhangi bir sonuç bulunamadı.\nArama yaptığınız ikelimeyi değiştirip yeniden deneyin.",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  )
                                ]),
                ),
                SliverPadding(padding: EdgeInsets.only(bottom: 120))
              ],
            );
          } else if (snapshot.hasError) {
            return MyErrorWidget(context);
          }
          return MyLoadingWidget(context);
        });
  }
}
