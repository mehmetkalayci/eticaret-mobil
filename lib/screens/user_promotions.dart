import 'package:ecommerce_mobile/widgets/my_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class UserPromotionPage extends StatefulWidget {
  const UserPromotionPage({Key? key}) : super(key: key);

  @override
  State<UserPromotionPage> createState() => _UserPromotionPageState();
}

class _UserPromotionPageState extends State<UserPromotionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        slivers: <Widget>[
          MyAppBar("Bana Özel", Icon(Icons.discount_rounded), context),
          SliverAnimatedList(
            initialItemCount: 5,
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
                child: ListTile(
                  onTap: () {},
                  title: Text(
                    "Merhaba, size özel %20 indirim kupon kodunuz: GTSD5J78S",
                    style: TextStyle(
                      color: (index % 2 == 0) ? Colors.grey : Colors.black,
                    ),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
