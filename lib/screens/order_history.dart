import 'dart:convert';
import 'dart:developer';
import 'package:intl/intl.dart';

import 'package:ecommerce_mobile/models/order_detail_model.dart';
import 'package:ecommerce_mobile/models/order_history_model.dart';
import 'package:ecommerce_mobile/models/order_model.dart';
import 'package:ecommerce_mobile/providers/auth_provider.dart';
import 'package:ecommerce_mobile/providers/menu_provider.dart';
import 'package:ecommerce_mobile/widgets/basket_item.dart';
import 'package:ecommerce_mobile/widgets/my_appbar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class OrderHistoryPage extends StatelessWidget {
  OrderHistoryPage({Key? key}) : super(key: key);

  Future<List<OrderHistoryModel>?> getOrderHistory(String token) async {
    final response = await http.get(
      Uri.parse("http://api.qsres.com/mobileapp/orders"),
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Bearer ${token}',
      },
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);

      return jsonResponse
          .map((item) => new OrderHistoryModel.fromJson(item))
          .toList();
    } else {
      Fluttertoast.showToast(
          msg: "Sipariş geçmişi alınırken hata oluştu!",
          toastLength: Toast.LENGTH_LONG);
      return null;
    }
  }

  Future<OrderModel?> getOrderDetails(String token, String orderId) async {
    final response = await http.get(
      Uri.parse("http://api.qsres.com/mobileapp/orders/${orderId}"),
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Bearer ${token}',
      },
    );

    print(response.body);

    if (response.statusCode == 200) {
      return OrderModel.fromJson(json.decode(response.body));
    } else {
      Fluttertoast.showToast(
          msg: "Sipariş detayı alınırken hata oluştu!",
          toastLength: Toast.LENGTH_LONG);
      return null;
    }
  }

  late Future<OrderModel?> futureOrderHistory;

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context, listen: false);

    return SingleChildScrollView(
        child: Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CustomAppBar(context, Icons.shopping_bag_rounded, "Sipariş Geçmişim"),
        FutureBuilder(
          future: getOrderHistory(auth.token),
          builder: (BuildContext context,
              AsyncSnapshot<List<OrderHistoryModel>?> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.length > 0) {
                int counter = 1;
                return ListView.builder(
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        futureOrderHistory = getOrderDetails(auth.token,
                            snapshot.data![index].orderId.toString());

                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          enableDrag: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => Container(
                            height: MediaQuery.of(context).size.height * 0.75,
                            decoration: new BoxDecoration(
                              color: Colors.white,
                              borderRadius: new BorderRadius.only(
                                topLeft: const Radius.circular(8.0),
                                topRight: const Radius.circular(8.0),
                              ),
                            ),
                            child: FutureBuilder(
                              future: futureOrderHistory,
                              builder: (BuildContext context,
                                  AsyncSnapshot<OrderModel?> snapshot) {
                                if (snapshot.hasData) {
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 15, 0, 0),
                                        child: Center(
                                          child: Text(
                                            "Sipariş No # ${snapshot.data!.orderId}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        child: SingleChildScrollView(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              ListTile(
                                                title: Text(
                                                  "Sipariş Tarihi",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                subtitle: Text(
                                                  DateFormat(
                                                          'dd MMMM yyyy hh:mm')
                                                      .format(
                                                    snapshot.data!.orderDate,
                                                  ),
                                                ),
                                              ),
                                              Divider(height: 1),
                                              ListTile(
                                                title: Text(
                                                  "Ödeme Yöntemi",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                subtitle: Text(
                                                  snapshot.data!.paymentType,
                                                ),
                                              ),
                                              Divider(height: 1),
                                              ListTile(
                                                title: Text(
                                                  "Adres",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                subtitle: Text(
                                                  snapshot.data!.address,
                                                ),
                                              ),
                                              Divider(height: 1),
                                              Padding(
                                                padding: EdgeInsets.fromLTRB(15,15,15,0),
                                                child: Text(
                                                  "Durum Geçmişi",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              Column(
                                                children: snapshot
                                                    .data!.orderStatuses
                                                    .map(
                                                      (item) => ListTile(
                                                        title:
                                                            Text(item.status),
                                                        subtitle: Text(
                                                          DateFormat(
                                                                  'dd MMMM yyyy hh:mm')
                                                              .format(
                                                            item.operationTime,
                                                          ),
                                                        ),
                                                        visualDensity:
                                                            VisualDensity
                                                                .compact,
                                                      ),
                                                    )
                                                    .toList(),
                                              ),
                                              Divider(height: 1),
                                              Padding(
                                                padding: EdgeInsets.fromLTRB(15,15,15,0),
                                                child: Text(
                                                  "Ürünler",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              ListView.builder(
                                                itemCount: snapshot
                                                    .data!.orderDetails.length,
                                                shrinkWrap: true,
                                                physics:
                                                    BouncingScrollPhysics(),
                                                itemBuilder: (context, index) {
                                                  return ListTile(
                                                    onTap: () {},
                                                    title: Text(snapshot
                                                        .data!
                                                        .orderDetails[index]
                                                        .productName),
                                                    subtitle: Text(
                                                        "${snapshot.data!.orderDetails[index].appliedPrice}₺ x ${snapshot.data!.orderDetails[index].pcs.toString()}"),
                                                  );
                                                },
                                              ),
                                              ListTile(
                                                title: Text(
                                                  "Toplam",
                                                  style: TextStyle(
                                                      fontWeight:
                                                      FontWeight.bold),
                                                ),
                                                subtitle: Text(
                                                  snapshot.data!.totalAmount.toString(),
                                                ),
                                              ),
                                              Divider(height: 1),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                } else if (snapshot.hasError) {
                                  return Center(
                                      child: Text('${snapshot.error}'));
                                }
                                return Center(
                                    child: CircularProgressIndicator());
                              },
                            ),
                          ),
                        );
                      },
                      title:
                          Text("Sipariş No #${snapshot.data![index].orderId}"),
                      subtitle: Text(
                        DateFormat('dd MMMM yyyy').format(
                          DateTime.parse(snapshot.data![index].orderDate),
                        ),
                      ),
                      trailing: Text(
                        "${snapshot.data![index].orderDetails.length.toString()} ürün",
                      ),
                    );
                  },
                );
              } else {
                return Center(
                  child: Text("Daha önceden verilmiş siparişiniz yok!"),
                );
              }
            } else if (snapshot.hasError) {
              return Center(child: Center(child: CircularProgressIndicator()));
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
        Padding(padding: EdgeInsets.only(bottom: 120)),
      ],
    ));
  }
}
