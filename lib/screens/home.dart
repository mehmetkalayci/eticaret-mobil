import 'dart:convert';

import 'package:advstory/advstory.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecommerce_mobile/models/homepage_model.dart';
import 'package:ecommerce_mobile/providers/menu_provider.dart';
import 'package:ecommerce_mobile/screens/product_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _current = 0;
  final CarouselController _controller = CarouselController();

  //#region Fetch Homepage Data

  late Future<HomepageModel> _homepageModelFuture;

  Future<HomepageModel> fetchHomepage() async {
    final response =
    await http.get(Uri.parse('http://qsres.com/api/mobileapp/home'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response, then parse the JSON.
      return HomepageModel.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response, then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  @override
  void initState() {
    super.initState();
    _homepageModelFuture = fetchHomepage();
  }

  //#endregion

  @override
  Widget build(BuildContext context) {

    MenuProvider menu = Provider.of<MenuProvider>(context, listen: false);

    return FutureBuilder(
      future: _homepageModelFuture,
      builder: (BuildContext context, AsyncSnapshot<HomepageModel> snapshot) {
        if (snapshot.hasData) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                automaticallyImplyLeading: false,
                elevation: 0,
                titleSpacing: 10,
                systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: Theme.of(context).scaffoldBackgroundColor,
                  statusBarBrightness: Brightness.dark,
                  statusBarIconBrightness: Brightness.dark,
                  systemStatusBarContrastEnforced: true,
                ),
                pinned: true,
                backgroundColor: Theme.of(context).primaryColor,
                //Theme.of(context).scaffoldBackgroundColor,
                actions: [
                  MaterialButton(
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                    child: Image.asset(
                      "assets/images/icons/menu-burger.png",
                      height: 32,
                      color: Colors.white,
                    ),
                    elevation: 0,
                    disabledElevation: 0,
                    hoverElevation: 0,
                    highlightElevation: 0,
                    focusElevation: 0,
                    splashColor: Colors.white10,
                    highlightColor: Colors.white10,
                    padding: EdgeInsets.zero,
                  ),
                ],
                toolbarHeight: 90,
                title: Row(
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      height: 40,
                    ),
                  ],
                ),
              ),
              SliverPadding(padding: EdgeInsets.all(10)),
              SliverToBoxAdapter(
                child: Container(
                  height: 120,
                  alignment: Alignment.center,
                  child: AdvStory(
                    storyCount: snapshot.data!.stories.length,
                    storyBuilder: (storyIndex) => Story(
                      contentCount: 1,
                      contentBuilder: (contentIndex) {
                        return ImageContent(
                          duration: Duration(milliseconds: 3000),
                          url: snapshot.data!.stories[contentIndex].storyImgSrc,
                        );
                      },
                    ),
                    trayBuilder: (index) {
                      return AdvStoryTray(
                        username: Text(snapshot.data!.stories[index].storyTitle,
                            style: TextStyle(fontSize: 14)),
                        url: snapshot.data!.stories[index].storyCoverImgSrc,
                      );
                    },
                  ),
                ),
              ),

              /**  SLIDER  **/
              SliverToBoxAdapter(
                child: Stack(
                  children: [
                    CarouselSlider(
                      items: snapshot.data!.sliderImgs.map((item) {
                        return CachedNetworkImage(
                          imageUrl: item.sliderImgSrc,
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          placeholder: (context, url) => Center(
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) => Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
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
                          height: 200,
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
                        children: snapshot.data!.sliderImgs
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
              ),
              SliverPadding(padding: EdgeInsets.symmetric(vertical: 10)),
              /**  /SLIDER  **/

              SliverToBoxAdapter(
                child: Center(
                  child: Text(
                    "Kategoriler",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.all(10),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1,
                  ),
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      return MaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        color: Colors.grey.shade200,
                        elevation: 0,
                        disabledElevation: 0,
                        hoverElevation: 0,
                        highlightElevation: 0,
                        focusElevation: 0,
                        onPressed: () {

                          menu.setMenuIndex(5, categoryId: index);


                          // Navigator.push(
                          //   context,
                          //   PageTransition(
                          //     type: PageTransitionType.fade,
                          //     child: ProductListPage(mainCategoryId: index),
                          //   ),
                          // );
                          //



                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Image.network(
                                  snapshot.data!.categories[index].imageSrc,
                                  height: 65),
                            ),
                            SizedBox(height: 5),
                            Flexible(
                              child: Text(
                                snapshot.data!.categories[index].name,
                                textAlign: TextAlign.center,
                              ),
                            )
                          ],
                        ),
                      );
                    },
                    childCount: snapshot.data!.categories.length,
                  ),
                ),
              ),
              const SliverPadding(padding: EdgeInsets.only(bottom: 120))
            ],
          );
        }
        else if (snapshot.hasError) {
          //return MyErrorWidget(context);
        }
        //return MyLoadingWidget(context);
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}