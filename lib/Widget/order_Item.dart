import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shop/providers/orders.dart'as ord;
import 'package:intl/intl.dart';

class Orders_Item extends StatefulWidget {
  final ord.OrderItem order;

  Orders_Item(this.order);

  @override
  _Order_ItemState createState() => _Order_ItemState();
}

class _Order_ItemState extends State<Orders_Item> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('\$${widget.order.amount}'),
            subtitle: Text(
              DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime),
            ),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          if (_expanded)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              height: min(widget.order.products.length * 20.0 + 10, 100),
              child:Text("${widget.order.products}")
              //  ListView(
              //   children: widget.order.products
              //       .map(
              //         (prod) => Row(
              //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //               children: <Widget>[
              //                 Text(
              //                   prod.title,
              //                   style: TextStyle(
              //                     fontSize: 18,
              //                     fontWeight: FontWeight.bold,
              //                   ),
              //                 ),
              //                 Text(
              //                   '${prod.quantity}x \$${prod.price}',
              //                   style: TextStyle(
              //                     fontSize: 18,
              //                     color: Colors.grey,
              //                   ),
              //                 )
              //               ],
              //             ),
              //       )
              //       .toList(),
              // ),
            )
        ],
      ),
    );
  }
}
