import 'package:equip_it_public/models/views/employee_address_view.dart';
import 'package:equip_it_public/pages/rental_item_page.dart';
import 'package:equip_it_public/widgets/widgets.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../data_handler.dart';
import '../models/entities/employee.dart';
import '../models/entities/rental_item.dart';
import '../widgets/filter_menu_widgets.dart';
import 'employee_page.dart';

class RentalItemListPage extends StatefulWidget {
  const RentalItemListPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<RentalItemListPage> createState() => _RentalItemListPageState();
}

class _RentalItemListPageState extends State<RentalItemListPage> {
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
      floatingActionButton: FloatingCreateButtonWidget(
        onPressed: () async {
          await Navigator.pushNamed(context, "/update_rental_item");
          _getRentalItems();
        },
        label: "Create New Rental Item",
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
          FloatingFilterButtonWidget(
              filterMenu: RentalItemFilterMenu(
            searchFunction: () => _getRentalItems(),
            filters: _filters,
            searchCtrl: _searchCtrl,
          )),
          const SizedBox(
            height: 10,
          ),
          // _buildFloatingCreateButton(),
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
              return const SizedBox(height: 150);
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
                    Row(
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
                        SizedBox(
                          width: 100,
                          child: Column(
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
                    Container(
                      margin: const EdgeInsets.all(15),
                      child: ButtonWidget(
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
}