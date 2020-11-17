import 'package:flutter/cupertino.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get ItemCount {
    return _items.length;
  }

  double get TotalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addItem(
    String prodectId,
    double price,
    String title,
  ) {
    if (_items.containsKey(prodectId)) {
      _items.update(
        prodectId,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          title: existingCartItem.title,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        prodectId,
        () => CartItem(
          title: title,
          id: DateTime.now().toString(),
          price: price,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }

  void removeSingleItem(String prodectId) {
    if (!_items.containsKey(prodectId)) {
      return;
    }
    if (_items[prodectId].quantity > 1) {
      _items.update(
          prodectId,
          (existingCartItem) => CartItem(
                id: existingCartItem.id,
                title: existingCartItem.title,
                price: existingCartItem.price,
                quantity: existingCartItem.quantity - 1,
              ));
    } else {
      _items.remove(prodectId);
    }
    notifyListeners();
  }

  void removeItem(String prodectId) {
    _items.remove(prodectId);
    notifyListeners();
  }

  void Clear() {
    _items = {};
    notifyListeners();
  }
}
