import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/cart_model.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<CartModel>(builder: (context, value, child) {
        return Column(
          children: [
            ListView.builder(
                itemCount: value.rentalItems.length,
                itemBuilder: (context, index) {
                  return Center(
                    child: Text("id: ${value.rentalItems[index].id}\n"
                        "name: ${value.rentalItems[index].name}"),
                  );
                }),
            Text("Total:\n${value.totalPrice}")
          ],
        );
      }),
    );
  }
}