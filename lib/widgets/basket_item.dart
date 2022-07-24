import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BasketItem extends StatelessWidget {
  const BasketItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            child: Image.network(
              "https://migros-dali-storage-prod.global.ssl.fastly.net/macrocenter/product/7037172/07037172-3c38fc-1650x1650.jpg",
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
                      "Standart Fit Günlük Rahat ",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.remove_circle_outline_rounded,
                            color: Colors.black87,
                          ),
                          splashRadius: 10,
                        ),
                        Text(" 1 "),
                        IconButton(
                            onPressed: () {},
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
                  "119,50 TL",
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
