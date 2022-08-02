import 'package:ecommerce_mobile/providers/menu_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget MyBottomMenu(BuildContext context) {
  MenuSelectionProvider menuSelectionService =  Provider.of<MenuSelectionProvider>(context);

  return Positioned(
    bottom: 30,
    left: 30,
    right: 30,
    child: Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
              color: Colors.black38, blurRadius: 0.5, offset: Offset(0, 1),
          )
        ],
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (index) {
          menuSelectionService.setMenuIndex(index);
        },
        currentIndex: menuSelectionService.getMenuIndex,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/icons/home.png',
              height: 23,
            ),
            label: 'Anasayfa',
            activeIcon: Image.asset(
              'assets/images/icons/home.png',
              height: 23,
              color: Theme.of(context).primaryColor,
            ),
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/images/icons/search.png', height: 23),
            activeIcon: Image.asset(
              'assets/images/icons/search.png',
              height: 23,
              color: Theme.of(context).primaryColor,
            ),
            label: 'Ara',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/images/icons/basket.png',
                height: 23),
            activeIcon: Image.asset(
              'assets/images/icons/basket.png',
              height: 23,
              color: Theme.of(context).primaryColor,
            ),
            label: 'Sepetim',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/images/icons/user.png', height: 23),
            activeIcon: Image.asset(
              'assets/images/icons/user.png',
              height: 23,
              color: Theme.of(context).primaryColor,
            ),
            label: 'Hesabım',
          ),
        ],
      ),
    ),
  );


  /*return BottomNavigationBar(
    type: BottomNavigationBarType.fixed,
    showSelectedLabels: false,
    showUnselectedLabels: false,
    onTap: (index) {
      menuSelectionService.setMenuIndex(index);
    },
    currentIndex: menuSelectionService.getMenuIndex,
    items: [
      BottomNavigationBarItem(
        icon: Image.asset('assets/images/icons/home.png', height: 28),
        label: 'Anasayfa',
        activeIcon: Image.asset(
          'assets/images/icons/home.png',
          height: 28,
          color: Theme.of(context).primaryColor,
        ),
      ),
      BottomNavigationBarItem(
        icon: Image.asset('assets/images/icons/search.png', height: 28),
        activeIcon: Image.asset(
          'assets/images/icons/search.png',
          height: 28,
          color: Theme.of(context).primaryColor,
        ),
        label: 'Ara',
      ),
      BottomNavigationBarItem(
        icon: Image.asset('assets/images/icons/basket.png', height: 28),
        activeIcon: Image.asset(
          'assets/images/icons/basket.png',
          height: 28,
          color: Theme.of(context).primaryColor,
        ),
        label: 'Sepetim',
      ),
      BottomNavigationBarItem(
        icon: Image.asset('assets/images/icons/user.png', height: 28),
        activeIcon: Image.asset(
          'assets/images/icons/user.png',
          height: 28,
          color: Theme.of(context).primaryColor,
        ),
        label: 'Hesabım',
      ),
    ],
  );*/
}
