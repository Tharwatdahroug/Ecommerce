import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/Widget/app_drawer.dart';
import 'package:shop/Widget/user_product_item.dart';
import 'package:shop/screens/edit_product_screen.dart';
import '../providers/products.dart';
import '../providers/products.dart';

class UserProduct extends StatelessWidget {
  static const routename = '/userscreen';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    // final Productdata = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditeProductScreeen.routename);
            },
          )
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshProducts(context),
                    child: Consumer<Products>(
                      builder: (context, Productdata, child) => Padding(
                        padding: EdgeInsets.all(8),
                        child: ListView.builder(
                          itemBuilder: (_, i) => Column(
                            children: <Widget>[
                              UserItem(
                                Productdata.items[i].id,
                                Productdata.items[i].title,
                                Productdata.items[i].imageUrl,
                              ),
                              Divider(),
                            ],
                          ),
                          itemCount: Productdata.items.length,
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
