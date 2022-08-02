import 'package:ecommerce_mobile/widgets/my_appbar.dart';
import 'package:flutter/material.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      shrinkWrap: true,
      physics: ScrollPhysics(),
      slivers: <Widget>[
        SliverToBoxAdapter(child: CustomAppBar(context, Icons.payment_rounded, "Ödeme")),
        SliverToBoxAdapter(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[

            ],
          ),
        ),
      ],
    );
  }
}
