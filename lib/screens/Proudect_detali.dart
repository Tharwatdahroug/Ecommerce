import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';

class productDetails extends StatelessWidget {
  static const routename = '/ product_Details';
  @override
  Widget build(BuildContext context) {
    final routeid = ModalRoute.of(context).settings.arguments as String;
    final loadeproudect = Provider.of<Products>(context, listen: false)
        .items
        .firstWhere((pro) => pro.id == routeid);
    return Scaffold(
      appBar: AppBar(
        title: Text(loadeproudect.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 300,
              width: double.infinity,
              child: Image.network(
                loadeproudect.imageUrl,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "\$${loadeproudect.price}",
              // textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 20,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal:20),
              child: Text(
                "${loadeproudect.description}",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10,
                ),
                softWrap: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
