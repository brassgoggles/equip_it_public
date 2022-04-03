import 'package:equip_it_public/models/views/employee_address_view.dart';
import 'package:equip_it_public/pages/rental_item_page.dart';
import 'package:equip_it_public/widgets/filter_menu_widgets.dart';
import 'package:equip_it_public/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../data_handler.dart';
import '../models/cart_model.dart';
import '../models/entities/customer.dart';
import '../models/entities/employee.dart';
import '../models/entities/rental_item.dart';
import 'employee_page.dart';

class ShopPage extends StatefulWidget {
  const ShopPage(
      {Key? key, required this.title, required this.selectedCustomer})
      : super(key: key);

  final String title;
  final Customer selectedCustomer;

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  final TextEditingController _searchCtrl = TextEditingController();

  List<dynamic> _rentalItems = <RentalItem>[];

  final Map<String, bool> _filters = {"active": true, "retired": false};

  Future<void> _getRentalItems() async {
    _rentalItems =
        await DataHandler.getRentalItemsByName(searchName: _searchCtrl.text);

    _filterRentalItems();
    setState(() {});
  }

  _filterRentalItems() {
    List<dynamic> filteredRentalItems = <RentalItem>[];

    if (_filters["retired"] == true) {
      filteredRentalItems
          .addAll(_rentalItems.where((i) => i.retired == true).toList());
    }

    if (_filters["active"] == true) {
      filteredRentalItems
          .addAll(_rentalItems.where((i) => i.retired == false).toList());
    }

    filteredRentalItems
        .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    _rentalItems = filteredRentalItems;
  }

  @override
  void initState() {
    // Make sure there is a clear list every time a customer is selected.
    SchedulerBinding.instance?.addPostFrameCallback((_) {
      CartModel cartModel = Provider.of<CartModel>(context, listen: false);
      cartModel.removeAll();
    });

    _getRentalItems();
    super.initState();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Constants.setResponsiveSettings(context);

    return Constants.currentScreenWidth == ScreenWidth.large
        ? _buildLargeDeviceScreen(context)
        : _buildSmallDeviceScreen(context);
  }

  _buildLargeDeviceScreen(BuildContext context) {
    return Scaffold(
      appBar: const AdminAppBar(title: "Rental Items"),
      endDrawer: const AdminDrawerWidget(),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: 300,
            color: Colors.redAccent,
            padding: const EdgeInsets.all(20),
            child: RentalItemFilterMenu(
              searchFunction: () => _getRentalItems(),
              filters: _filters,
              searchCtrl: _searchCtrl,
            ),
          ),
          Expanded(
            child: _buildRentalItemsListView(),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildFloatingCartButton(context),
          const SizedBox(
            height: 10,
          ),
          FloatingCreateButtonWidget(
            onPressed: () async {
              await Navigator.pushNamed(context, "/update_rental_item");
              _getRentalItems();
            },
            label: "Create New Rental Item",
          ),
        ],
      ),
    );
  }

  _buildSmallDeviceScreen(BuildContext context) {
    return Scaffold(
      appBar: const AdminAppBar(title: "Rental Items"),
      endDrawer: const AdminDrawerWidget(),
      body: _buildRentalItemsListView(),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildFloatingCartButton(context),
          const SizedBox(
            height: 10,
          ),
          FloatingFilterButtonWidget(
            filterMenu: RentalItemFilterMenu(
              searchFunction: () => _getRentalItems(),
              filters: _filters,
              searchCtrl: _searchCtrl,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          FloatingCreateButtonWidget(
            onPressed: () async {
              await Navigator.pushNamed(context, "/update_rental_item");
              _getRentalItems();
            },
            label: "Create New Rental Item",
          ),
        ],
      ),
    );
  }

  _buildRentalItemsListView() {
    CartModel cartModel = Provider.of<CartModel>(context);
    return Align(
      alignment: Alignment.center,
      child: Container(
        alignment: Alignment.center,
        constraints: const BoxConstraints(maxWidth: 750),
        child: ListView.builder(
          itemCount: _rentalItems.length + 1,
          itemBuilder: (context, index) {
            // Ensures there is blank space at the bottom so the last item
            // is not covered by the floating buttons.
            if (index == _rentalItems.length) {
              return const SizedBox(height: 200);
            }

            final rentalItem = _rentalItems[index];

            return Container(
              margin: const EdgeInsets.all(10),
              child: MaterialButton(
                onPressed: () {}, // TODO: Create a view all details page
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: Colors.redAccent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        runAlignment: WrapAlignment.center,
                        alignment: WrapAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.all(15),
                            constraints: const BoxConstraints(maxHeight: 80),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10)),
                            child: Image(
                              image: rentalItem.imageUrl != ""
                                  ? NetworkImage(rentalItem.imageUrl)
                                  : const AssetImage(
                                      'assets/images/tools_250x244.jpg',
                                    ) as ImageProvider,
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "ID: ${rentalItem.id}",
                                  style: const TextStyle(color: Colors.white),
                                  textAlign: TextAlign.start,
                                ),
                                Text(
                                  rentalItem.name,
                                  style: const TextStyle(color: Colors.white),
                                  textAlign: TextAlign.start,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        child: Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          runAlignment: WrapAlignment.center,
                          alignment: WrapAlignment.end,
                          children: [
                            ButtonWidget(
                              onPressed: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RentalItemPage(
                                      selectedRentalItem: _rentalItems[index],
                                      title: 'Edit Rental Item',
                                    ),
                                  ),
                                );
                                _getRentalItems();
                              },
                              text: "Edit Rental Item",
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              icon: const Icon(Icons.edit, color: Colors.white),
                              width: 150,
                            ),
                            ButtonWidget(
                              onPressed: () async {
                                if (cartModel.rentalItems
                                    .contains(_rentalItems[index])) {
                                  cartModel.rentalItems
                                      .remove(_rentalItems[index]);
                                } else {
                                  cartModel.rentalItems
                                      .add(_rentalItems[index]);
                                }
                                setState(() {});
                              },
                              text: "Select Item",
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              icon: cartModel.rentalItems
                                      .contains(_rentalItems[index])
                                  ? const Icon(Icons.highlight_off_outlined,
                                      color: Colors.white)
                                  : const Icon(Icons.check_circle_outline,
                                      color: Colors.white),
                              width: 150,
                              color: cartModel.rentalItems
                                      .contains(_rentalItems[index])
                                  ? Colors.orange
                                  : Colors.green,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  _buildCartOverlay() {
    return Consumer<CartModel>(builder: (context, value, child) {
      return Container(
        height: double.maxFinite,
        width: double.maxFinite,
        constraints: const BoxConstraints(maxWidth: 500),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListView.builder(
                shrinkWrap: true,
                itemCount: value.rentalItems.length,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(15),
                        constraints: const BoxConstraints(maxHeight: 80),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10)),
                        child: Image(
                          image: value.rentalItems[index].imageUrl != ""
                              ? NetworkImage(value.rentalItems[index].imageUrl)
                              : const AssetImage(
                                  'assets/images/tools_250x244.jpg',
                                ) as ImageProvider,
                        ),
                      ),
                      SizedBox(
                        width: 100,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "ID: ${value.rentalItems[index].id}",
                              style: const TextStyle(color: Colors.white),
                              textAlign: TextAlign.start,
                            ),
                            Text(
                              value.rentalItems[index].name,
                              style: const TextStyle(color: Colors.white),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }),
            Text(
              "Total:\n\$${value.totalPrice}",
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      );
    });
  }

  _buildFloatingCartButton(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () async {
        await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: Colors.redAccent,
              title: const Text(
                "Cart",
                style: TextStyle(color: Colors.white),
              ),
              content: _buildCartOverlay(),
              actions: [
                TextButton(
                  child: const Text(
                    "Close",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
      heroTag: "btn_cart",
      tooltip: 'Go to cart',
      label: const Text("Cart"),
      icon: const Icon(Icons.shopping_cart),
      backgroundColor: Constants.equipItPink,
    );
  }
}
