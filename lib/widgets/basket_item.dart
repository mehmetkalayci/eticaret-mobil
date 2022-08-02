import 'package:ecommerce_mobile/models/cart_model.dart';
import 'package:ecommerce_mobile/providers/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class BasketItem extends StatelessWidget {
  const BasketItem({Key? key, required this.cartItem}) : super(key: key);

  final CartModel cartItem;

  @override
  Widget build(BuildContext context) {
    CartProvider cart = Provider.of<CartProvider>(context, listen: false);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200, width: 1.5),
        ),
      ),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            alignment: Alignment.topCenter,
            child: (cartItem.thumbSrc == null || cartItem.thumbSrc.trim() == '')
                ? Image.asset('assets/images/noimage.jpg')
                : Image.network(
                    cartItem.thumbSrc,
                    fit: BoxFit.cover,
                    height: 90,
                    width: 90,
                  ),
          ),
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 10),
                Flexible(
                    child: Column(
                  children: [
                    Text(
                      cartItem.productName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            cart.removeItem(cartItem.productId);
                          },
                          icon: Icon(
                            Icons.remove_circle_outline_rounded,
                            color: Colors.black87,
                          ),
                          splashRadius: 10,
                        ),
                        Text(cartItem.pcs.toString()),
                        IconButton(
                          onPressed: () {
                            cart.insertItem(cartItem.productId);
                          },
                          icon: Icon(
                            Icons.add_circle_outline_rounded,
                            color: Colors.black87,
                          ),
                          splashRadius: 10,
                        )
                      ],
                    ),
                  ],
                )),
                SizedBox(width: 5),
                Text(
                  cartItem.isDiscounted
                      ? cartItem.discountedPrice.toString()
                      : cartItem.sellingPrice.toString(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
