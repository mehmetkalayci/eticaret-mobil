import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecommerce_mobile/models/product_model.dart';
import 'package:ecommerce_mobile/providers/basket_provider.dart';
import 'package:ecommerce_mobile/widgets/my_appbar.dart';
import 'package:ecommerce_mobile/widgets/my_error_widget.dart';
import 'package:ecommerce_mobile/widgets/my_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

final List<String> imgList = [
  'https://images.unsplash.com/photo-1519311726-5cced7383240?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NXx8Zml0fGVufDB8MnwwfHw%3D&auto=format&fit=crop&w=500&q=60',
  'https://images.unsplash.com/photo-1656505758064-1e45e7409583?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHx0b3BpYy1mZWVkfDZ8X2hiLWRsNFEtNFV8fGVufDB8fHx8&auto=format&fit=crop&w=500&q=60',
  'https://images.unsplash.com/photo-1654584240523-6b8d3f6c33b4?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHx0b3BpYy1mZWVkfDJ8X2hiLWRsNFEtNFV8fGVufDB8fHx8&auto=format&fit=crop&w=500&q=60',
  'https://migros-dali-storage-prod.global.ssl.fastly.net/macrocenter/banner/main_page_slider/28937/30971-pembedomates_700x310-4335c9.jpg',
  'https://migros-dali-storage-prod.global.ssl.fastly.net/macrocenter/banner/main_page_slider/28934/30968-nar_700x310-7a761d.jpg',
];
int _current = 0;
final CarouselController _controller = CarouselController();

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({Key? key, required this.productId})
      : super(key: key);

  final int productId;

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  Future<ProductModel?> fetchProduct() async {
    final response = await http.get(Uri.parse(
        'http://qsres.com/api/mobileapp/products/${widget.productId}'));
    if (response.statusCode == 200) {
      return ProductModel.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  int adet = 1;

  late ProductModel productModel ;

  @override
  Widget build(BuildContext context) {

    BasketProvider basketProvider = Provider.of<BasketProvider>(context);



    return FutureBuilder(
      future: fetchProduct(),
      builder: (BuildContext context, AsyncSnapshot<ProductModel?> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data != null) {
            productModel = snapshot.data!;

            return Scaffold(
              body: CustomScrollView(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                slivers: <Widget>[
                  MyAppBar(snapshot.data!.productName, null, context,
                      automaticallyImplyLeading: true),
                  SliverToBoxAdapter(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            CarouselSlider(
                              items: snapshot.data?.productImages.map((item) {
                                return CachedNetworkImage(
                                  imageUrl: item.src,
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.scaleDown,
                                      ),
                                    ),
                                  ),
                                  placeholder: (context, url) => Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  errorWidget: (context, url, error) => Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.error),
                                        Text("Resim Yüklenemedi!"),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                              carouselController: _controller,
                              options: CarouselOptions(
                                  autoPlay: true,
                                  enlargeCenterPage: true,
                                  viewportFraction: 1.0,
                                  height: 300,
                                  pageSnapping: true,
                                  onPageChanged: (index, reason) {
                                    setState(() {
                                      _current = index;
                                    });
                                  }),
                            ),
                            Positioned(
                              bottom: 10,
                              left: 0,
                              right: 0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: snapshot.data!.productImages
                                    .asMap()
                                    .entries
                                    .map((entry) {
                                  return Container(
                                    width: _current == entry.key ? 11.0 : 10.0,
                                    height: _current == entry.key ? 11.0 : 10.0,
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 4.0),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white.withOpacity(
                                        _current == entry.key ? 0.9 : 0.6,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            )
                          ],
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border(
                              bottom: BorderSide(
                                  width: 1.5, color: Colors.grey.shade200),
                            ),
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                snapshot.data!.productName,
                                style: TextStyle(fontSize: 20),
                                /*textAlign: TextAlign.center,*/
                              ),
                              Text(
                                snapshot.data!.sellingPrice.toString() + " ₺",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                ),
                              ),
                              SizedBox(height: 15),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    children: [
                                      MaterialButton(
                                        onPressed: () {
                                          setState(() {
                                            if(adet>1)
                                              adet--;
                                          });
                                        },
                                        child: Icon(Icons.remove,
                                            color: Colors.black),
                                        color: Colors.grey.shade300,
                                        textColor: Colors.white,
                                        clipBehavior:
                                            Clip.antiAliasWithSaveLayer,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        height: 40,
                                        minWidth: 40,
                                        padding: EdgeInsets.zero,
                                        elevation: 0,
                                        disabledElevation: 0,
                                        hoverElevation: 0,
                                        highlightElevation: 0,
                                        focusElevation: 0,
                                      ),
                                      SizedBox(
                                        child: Text(
                                          this.adet.toString(),
                                          style: TextStyle(fontSize: 18),
                                          textAlign: TextAlign.center,
                                        ),
                                        width: 50,
                                      ),
                                      MaterialButton(
                                        onPressed: () {
                                          setState(() {
                                            adet++;
                                          });
                                        },
                                        child: Icon(Icons.add,
                                            color: Colors.black),
                                        color: Colors.grey.shade300,
                                        textColor: Colors.white,
                                        clipBehavior:
                                            Clip.antiAliasWithSaveLayer,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
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
                                  SizedBox(width: 20),
                                  Flexible(
                                    child: MaterialButton(
                                      onPressed: () {
                                        basketProvider.addProduct(this.productModel);
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.shopping_basket_rounded),
                                          SizedBox(width: 10),
                                          Text(
                                            "Sepete Ekle",
                                            style: TextStyle(fontSize: 18),
                                          )
                                        ],
                                      ),
                                      color: Colors.lightBlue.shade900,
                                      textColor: Colors.white,
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      height: 50,
                                      padding: EdgeInsets.zero,
                                      elevation: 0,
                                      disabledElevation: 0,
                                      hoverElevation: 0,
                                      highlightElevation: 0,
                                      focusElevation: 0,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 15),
                            ],
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: 400,
                          color: Colors.white,
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 15),
                              Text(
                                'ÜRÜN AÇIKLAMASI',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                                /*textAlign: TextAlign.center,*/
                              ),
                              Text(
                                snapshot.data!.details,
                                style: TextStyle(fontSize: 20),
                                /*textAlign: TextAlign.center,*/
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Text("Ürün bulunamadı!");
          }
        } else if (snapshot.hasError) {
          return MyErrorWidget(context);
        }
        return MyLoadingWidget(context);
      },
    );
  }
}
