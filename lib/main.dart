import 'package:flutter/material.dart';
import 'package:shop/providers/auth.dart';
import 'package:shop/providers/cart.dart';
import 'package:shop/providers/orders.dart';
import 'package:shop/screens/Proudect_detali.dart';
import 'package:shop/screens/auth_screen.dart.dart';
import 'package:shop/screens/cart_screen.dart';
import 'package:shop/screens/edit_product_screen.dart';
import 'package:shop/screens/overview_screen.dart';
import 'package:provider/provider.dart';
import 'package:shop/screens/user_product_screen.dart';
import './providers/products.dart';
import './screens/order_screen.dart';
import './screens/splash_screen.dart';

void main() {
  runApp(MyApp());
}

var id;
var user;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        // ChangeNotifierProxyProvider<Auth,Products>(
        // create: (_)=>Products(),
        //  update: (_,auth,previousProducts) =>Products(auth.token),
        // ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (ctx) => Products(id, user, []),
          update: (ctx, auth, prevShop) =>
              Products(auth.token, auth.userId, prevShop.items),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        // ChangeNotifierProvider.value(
        //   value: Order(),
        // ),
        ChangeNotifierProxyProvider<Auth, Order>(
          create: (ctx) => Order(id, [], user),
          update: (ctx, auth, prevOrder) =>
              Order(auth.token, prevOrder.orders, auth.userId),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'MyShop',
          theme: ThemeData(
            primaryColor: Colors.purple,
            accentColor: Colors.deepOrange,
          ),
          home: auth.isAuth
              ? overviewScreen()
              : FutureBuilder(
                  future: auth.tryAutologin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          // AuthScreen(),
          routes: {
            productDetails.routename: (ctx) => productDetails(),
            CartScreen.routname: (ctx) => CartScreen(),
            Order_Screen.routename: (ctx) => Order_Screen(),
            UserProduct.routename: (ctx) => UserProduct(),
            EditeProductScreeen.routename: (ctx) => EditeProductScreeen(),
          },
        ),
      ),
    );
  }
}
// "auth != null"
