import 'package:decimal/decimal.dart';
import 'package:flutter/cupertino.dart';

import 'entities/rental_item.dart';

class CartModel extends ChangeNotifier {
  final List<RentalItem> _rentalItems = [];

  List<RentalItem> get rentalItems => _rentalItems;

  Decimal get totalPrice {
    Decimal total = Decimal.fromInt(0);
    for (var rentalItem in _rentalItems) { total += rentalItem.rentCost; }
    return total;
  }

  void add(RentalItem rentalItem) {
    _rentalItems.add(rentalItem);
    notifyListeners();
  }

  void removeAll() {
    _rentalItems.clear();
    notifyListeners();
  }
}