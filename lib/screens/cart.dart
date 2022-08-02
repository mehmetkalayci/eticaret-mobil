import 'package:ecommerce_mobile/providers/cart_provider.dart';
import 'package:ecommerce_mobile/widgets/my_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    CartProvider cart = Provider.of<CartProvider>(context);

    cart.getPostData();

    if(!cart.loading) {
      return Center(child: CircularProgressIndicator());
    }else{
      return Column(
        children: [
          CustomAppBar(context, Icons.shopping_basket_rounded, "title"),
          SingleChildScrollView(
            physics:ScrollPhysics(),
            child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: cart.itemCount,
              itemBuilder: (context, index) {


                return ListTile(
                  // leading: Container(
                  //   height: 70,
                  //   width: 70,
                  //   decoration: BoxDecoration(
                  //     image: DecorationImage(
                  //       image: AssetImage("assets/${giftIndex + 1}.jpg"),
                  //       fit: BoxFit.fitWidth,
                  //     ),
                  //     borderRadius: BorderRadius.circular(12),
                  //   ),
                  // ),
                  title: Text(cart.items[index].productName),
                  trailing: MaterialButton(
                    child: Text('Clear'),
                    elevation: 1.0,
                    splashColor: Colors.blueGrey,
                    onPressed: () {},
                  ),
                );
              },
            ),
          ),
        ],
      );
    }

  }
}
