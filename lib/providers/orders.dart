import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shop/providers/cart.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    this.id,
    this.amount,
    this.products,
    this.dateTime,
  });
}

class Order with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  final String authToken;
  final String userId;

  Order(this.authToken, this._orders, this.userId);
  Future<void> fetchAndSetOrders() async {
    final url =
        'https://flutter-6dd8e.firebaseio.com/Orders/$userId.json?auth=$authToken';
    final response = await http.get(url);
    final List<OrderItem> loadedOrder = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedOrder.add(
        OrderItem(
          id: orderId,
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          products: (orderData['products'] as List<dynamic>)
              .map(
                (key) => (CartItem(
                  id: orderData['id'],
                  title: orderData['title'],
                  quantity: orderData['quantity'],
                  price: orderData['price'],
                )),
              )
              .toList(),
        ),
      );
    });
    _orders = loadedOrder;
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartproduct, double total) async {
    final url =
        'https://flutter-6dd8e.firebaseio.com/Orders/$userId.json?auth=$authToken';
    final timestamp = DateTime.now();
    final response = await http.post(
      url,
      body: json.encode({
        'amount': total,
        'dateTime': timestamp.toIso8601String(),
        'products': cartproduct
            .map((cart) => {
                  'id': cart.id,
                  'title': cart.title,
                  'quantity': cart.quantity,
                  ' price': cart.price,
                })
            .toList(),
      }),
    );
    _orders.insert(
      0,
      OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        dateTime: timestamp,
        products: cartproduct,
      ),
    );
    notifyListeners();
  }
}
