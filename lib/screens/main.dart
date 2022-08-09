import 'package:badges/badges.dart';
import 'package:ecommerce_mobile/providers/auth_provider.dart';
import 'package:ecommerce_mobile/providers/cart_provider.dart';
import 'package:ecommerce_mobile/providers/menu_provider.dart';
import 'package:ecommerce_mobile/screens/cart.dart';
import 'package:ecommerce_mobile/screens/home.dart';
import 'package:ecommerce_mobile/screens/payment.dart';
import 'package:ecommerce_mobile/screens/product_details.dart';
import 'package:ecommerce_mobile/screens/product_list.dart';
import 'package:ecommerce_mobile/screens/search.dart';
import 'package:ecommerce_mobile/screens/signin.dart';
import 'package:ecommerce_mobile/screens/signup.dart';
import 'package:ecommerce_mobile/screens/user_auth_check_for_signin.dart';
import 'package:ecommerce_mobile/screens/user_auth_check_for_cart.dart';
import 'package:ecommerce_mobile/widgets/my_drawer_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);


  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  //#region Bottom Menü İşlemleri

  Widget _getPage(context, index) {
    MenuProvider menu = Provider.of<MenuProvider>(context, listen: false);

    Widget activePage = HomePage();
    switch (index) {
      case 0:
        activePage = HomePage();
        break;
      case 1:
        activePage = SearchPage();
        break;
      case 2:
        activePage = UserAuthCheckForCartPage();
        break;
      case 3:
        activePage = UserAuthCheckForSigninPage();
        break;
      case 4:
        activePage = SignupPage();
        break;
      case 5:
        activePage = ProductListPage(mainCategoryId: menu.categoryId, subCategoryId: menu.SubCategoryId);
        break;
      case 6:
        activePage = ProductDetailPage(productId: menu.productId);
        break;
      case 7:
        activePage = PaymentPage();
        break;
    }
    return activePage;
  }

  //#endregion

  @override
  Widget build(BuildContext context) {
    MenuProvider menu = Provider.of<MenuProvider>(context, listen: false);

    // başlangıçta geçerli kullanıcı tokenini var mı, varsa yükle,
    // provider ile diğer formlarla bu bilgiyi paylaş
    Provider.of<AuthProvider>(context, listen: false);
    // başlangıçta kullanıcının sepetini yükle
    Provider.of<CartProvider>(context, listen: false).loadItems();


    return Scaffold(
      drawerEnableOpenDragGesture: false,
      drawer: MyDrawerMenu(context),
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            _getPage(context, menu.currentPage),
            KeyboardVisibilityBuilder(
              builder: (context, isKeyboardVisible) {
                if (!isKeyboardVisible) {
                  return Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: _bottomNavigationBar(),
                  );
                } else {
                  return Container();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottomNavigationBar() {
    Size size = MediaQuery.of(context).size;
    MenuProvider menu = Provider.of<MenuProvider>(context);
    CartProvider cart = Provider.of<CartProvider>(context);

    return Container(
      margin: EdgeInsets.all(20),
      height: size.width * .155,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.15),
            blurRadius: 30,
            offset: Offset(0, 10),
          ),
        ],
        borderRadius: BorderRadius.circular(50),
      ),
      child: ListView.builder(
        itemCount: 4,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: size.width * .024),
        itemBuilder: (context, index) => InkWell(
          onTap: () {
            menu.setCurrentPage(index);
          },
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AnimatedContainer(
                duration: Duration(milliseconds: 1500),
                curve: Curves.fastLinearToSlowEaseIn,
                margin: EdgeInsets.only(
                  bottom: index == menu.currentPage ? 0 : size.width * .029,
                  right: size.width * .0422,
                  left: size.width * .0422,
                ),
                width: size.width * .128,
                height: index == menu.currentPage ? size.width * .014 : 0,
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(10),
                  ),
                ),
              ),
              (index == 2)
                  ? Badge(
                      badgeContent: Text(
                        cart.getTotalItemCount.toString(),
                        style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                      child: Icon(
                        listOfIcons[index],
                        size: size.width * .076,
                        color: index == menu.currentPage
                            ? Theme.of(context).primaryColor
                            : Colors.black38,
                      ),
                    )
                  : Icon(
                      listOfIcons[index],
                      size: size.width * .076,
                      color: index == menu.currentPage
                          ? Theme.of(context).primaryColor
                          : Colors.black38,
                    ),
              SizedBox(height: size.width * .03),
            ],
          ),
        ),
      ),
    );
  }
}

List<IconData> listOfIcons = [
  Icons.home_rounded,
  Icons.search_rounded,
  Icons.shopping_basket_rounded,
  Icons.person_rounded
];
