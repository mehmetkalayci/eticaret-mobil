import 'package:ecommerce_mobile/models/cart_model.dart';
import 'package:ecommerce_mobile/providers/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BasketItem extends StatefulWidget {
  const BasketItem({Key? key, required this.cartItem}) : super(key: key);

  final CartModel cartItem;

  @override
  State<BasketItem> createState() => _BasketItemState();
}

class _BasketItemState extends State<BasketItem> {

  @override
  Widget build(BuildContext context) {
    CartProvider cart = Provider.of<CartProvider>(context, listen: false);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200, width: 1.25),
        ),
      ),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 90,
              height: 90,
              alignment: Alignment.topCenter,
              child: (widget.cartItem.thumbSrc == null ||
                      widget.cartItem.thumbSrc.toString().trim() == '')
                  ? Image.asset('assets/images/noimage.jpg')
                  : Image.network(
                      widget.cartItem.thumbSrc.toString(),
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          Flexible(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 10),
                Flexible(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.cartItem.productName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          onPressed: () {
                            cart.removeItem(widget.cartItem.productId);
                          },
                          icon: Icon(
                            Icons.remove_circle_outline_rounded,
                            color: Colors.black87,
                          ),
                          padding: EdgeInsets.zero,
                          splashRadius: 10,
                        ),
                        Text(widget.cartItem.pcs.toString()),
                        IconButton(
                          onPressed: () {
                            cart.insertItem(widget.cartItem.productId, 1);
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
                  widget.cartItem.isDiscounted
                      ? widget.cartItem.discountedPrice.toString() + " ₺"
                      : widget.cartItem.sellingPrice.toString() + " ₺",
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
