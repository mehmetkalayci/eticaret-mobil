import 'package:ecommerce_mobile/widgets/basket_item.dart';
import 'package:ecommerce_mobile/widgets/my_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class BasketListPage extends StatefulWidget {
  const BasketListPage({Key? key}) : super(key: key);

  @override
  State<BasketListPage> createState() => _BasketListPageState();
}

class _BasketListPageState extends State<BasketListPage> {
  @override
  Widget build(BuildContext context) {
    return Stack(fit: StackFit.expand, children: [
      CustomScrollView(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        slivers: <Widget>[
          MyAppBar("Sepet", Icon(Icons.shopping_basket_rounded), context),
          SliverAnimatedList(
            initialItemCount: 10,
            itemBuilder: (context, index, animation) => SizeTransition(
              sizeFactor: animation,
              child: Slidable(
                endActionPane: const ActionPane(
                  extentRatio: 0.25,
                  motion: ScrollMotion(),
                  children: [
                    SlidableAction(
                      flex: 1,
                      onPressed: null,
                      backgroundColor: Color(0xFFFE4A49),
                      foregroundColor: Colors.white,
                      icon: Icons.delete_sweep_rounded,
                    ),
                  ],
                ),
                child: BasketItem(),
              ),
            ),
          ),
          SliverPadding(padding: EdgeInsets.only(bottom: 200))
        ],
      ),
      Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          color: Theme.of(context).primaryColor,
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: MaterialButton(
                  onPressed: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_bag_rounded),
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
                      children: const <TextSpan>[
                        TextSpan(
                          text: '2295,5 ₺',
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
