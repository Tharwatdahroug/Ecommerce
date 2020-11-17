import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/products.dart';
import 'overview_Item.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavorite;
  ProductsGrid(this.showFavorite);
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = showFavorite?productsData.FavoritesItem:productsData.items;
    return GridView.builder(
      itemCount: products.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: products[i],
        child: ProductItem(
            // products[i].id,
            // products[i].title,
            // products[i].imageUrl,
            ),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        childAspectRatio: 3 / 3,
        mainAxisSpacing: 10,
      ),
    );
  }

}