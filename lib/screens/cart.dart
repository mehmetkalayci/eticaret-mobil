import 'package:ecommerce_mobile/providers/cart_provider.dart';
import 'package:ecommerce_mobile/providers/menu_provider.dart';
import 'package:ecommerce_mobile/widgets/basket_item.dart';
import 'package:ecommerce_mobile/widgets/my_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    MenuProvider menu = Provider.of<MenuProvider>(context, listen: false);
    CartProvider cart = Provider.of<CartProvider>(context, listen: false);

    return Stack(children: [
      CustomScrollView(slivers: [
        SliverToBoxAdapter(
          child: CustomAppBar(context, Icons.shopping_basket_rounded, "Sepet"),
        ),
        SliverToBoxAdapter(
          child: (cart.cartItems.length > 0)
              ? ListView.builder(
                  shrinkWrap: true,
                  itemCount: cart.cartItems.length,
                  itemBuilder: (context, index) {
                    return Slidable(
                      endActionPane: ActionPane(
                        extentRatio: 0.25,
                        motion: ScrollMotion(),
                        children: [
                          SlidableAction(
                            flex: 1,
                            onPressed: (context) {
                              cart.removeItemCompletely(
                                cart.cartItems[index].productId,
                              );
                            },
                            backgroundColor: Color(0xFFFE4A49),
                            foregroundColor: Colors.white,
                            icon: Icons.delete_sweep_rounded,
                          ),
                        ],
                      ),
                      child: BasketItem(cartItem: cart.cartItems[index]),
                    );
                  },
                )
              : Center(
                  child: Text("Sepetinizde hiç ürün yok!"),
                ),
        ),
        SliverPadding(padding: EdgeInsets.only(bottom: 190)),
      ]),
      Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
          color: Theme.of(context).primaryColor,
          height: 170,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: MaterialButton(
                  onPressed: () {
                    if (cart.getTotalItemCount > 0) {
                      menu.setCurrentPage(7);
                    } else {
                      Fluttertoast.showToast(msg: "Sepetinizde ürün yok!");
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.playlist_add_check_rounded),
                      SizedBox(width: 10),
                      Text(
                        "Sepeti Onayla",
                        style: TextStyle(fontSize: 18),
                      )
                    ],
                  ),
                  color: Colors.white,
                  textColor: Theme.of(context).primaryColor,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  height: 55,
                  padding: EdgeInsets.zero,
                  elevation: 0,
                  disabledElevation: 0,
                  hoverElevation: 0,
                  highlightElevation: 0,
                  focusElevation: 0,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                flex: 1,
                child: MaterialButton(
                  onPressed: () {},
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: 'Toplam\n',
                      style: TextStyle(color: Colors.black54, fontSize: 16),
                      children: <TextSpan>[
                        TextSpan(
                          text: "${cart.totalAmount} ₺",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  color: Colors.white,
                  textColor: Theme.of(context).primaryColor,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  height: 55,
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
        ),
      ),
    ]);
  }
}
