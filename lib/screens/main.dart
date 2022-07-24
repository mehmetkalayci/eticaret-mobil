import 'package:ecommerce_mobile/providers/menu_selection_provider.dart';
import 'package:ecommerce_mobile/screens/basket_list.dart';
import 'package:ecommerce_mobile/screens/home.dart';
import 'package:ecommerce_mobile/screens/product_list.dart';
import 'package:ecommerce_mobile/screens/user_profile.dart';
import 'package:ecommerce_mobile/screens/search.dart';
import 'package:ecommerce_mobile/widgets/my_bottom_menu.dart';
import 'package:ecommerce_mobile/widgets/my_drawer_menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  //#region Bottom Menü İşlemleri

  Widget _getPage(int index) {
    Widget activePage = MainPage();
    switch (index) {
      case 0:
        activePage = HomePage();
        break;
      case 1:
        activePage = SearchPage();
        break;
      case 2:
        activePage = BasketListPage();
        break;
      case 3:
        activePage = UserProfilePage();
        break;
      case 4:
        activePage = ProductListPage();
        break;
    }
    return activePage;
  }

  //#endregion

  @override
  Widget build(BuildContext context) {
    MenuSelectionProvider menuSelectionService = Provider.of<MenuSelectionProvider>(context);

    return SafeArea(
      child: Scaffold(
        drawerEnableOpenDragGesture: false,
        drawer: MyDrawerMenu(context),
        body: _getPage(menuSelectionService.getMenuIndex),
        bottomNavigationBar: MyBottomMenu(context),
      ),
    );
  }
}
