import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/Widget/app_drawer.dart';
import '../providers/orders.dart';
import '../Widget/order_Item.dart';

class Order_Screen extends StatelessWidget {
  static const routename = "/order";

  // var _isloading = false;
  // void initState() {
  //   setState(() {
  //     _isloading = true;
  //   });
  //   Future.delayed(Duration.zero).then((_) async {
  //     await Provider.of<Order>(context, listen: false).fetchAndSetOrders();
  //   });
  //   setState(() {
  //     _isloading = false;
  //   });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    // final ordersData = Provider.of<Order>(context);
    print("sarwat");
    return Scaffold(
        appBar: AppBar(
          title: Text("Your Orders"),
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
          future:
              Provider.of<Order>(context, listen: false).fetchAndSetOrders(),
          builder: (ctx, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (dataSnapshot.error != null) {
                Center(
                  child: Text("An error occurred!"),
                );
              } else {
                return Consumer<Order>(
                    builder: (cxt, ordersData, child) => ListView.builder(
                          itemBuilder: (ctx, i) =>
                              Orders_Item(ordersData.orders[i]),
                          itemCount: ordersData.orders.length,
                        ));
              }
            }
          },
        ));
  }
}
