import 'package:ecommerce_mobile/widgets/my_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
          CustomAppBar( context, Icons.discount_rounded, "Bana Özel"),
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
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: "GTSD5J78S"));
                    Fluttertoast.showToast(msg: "GTSD5J78S kodunuz kopyalandı!");
                  },
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
