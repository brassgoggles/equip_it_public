import 'package:equip_it_public/pages/shop_page.dart';
import 'package:equip_it_public/widgets/widgets.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../data_handler.dart';
import '../models/entities/customer.dart';
import 'customer_page.dart';

class CustomerListPage extends StatefulWidget {
  const CustomerListPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<CustomerListPage> createState() => _CustomerListPageState();
}

class _CustomerListPageState extends State<CustomerListPage> {
  final TextEditingController _searchCtrl = TextEditingController();

  List<dynamic> _customers = <Customer>[];

  Future<void> _getCustomers() async {
    _customers = await DataHandler.getCustomers(searchName: _searchCtrl.text);
    setState(() {});
  }

  @override
  void initState() {
    _getCustomers();
    super.initState();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _scaffoldKey = GlobalKey<ScaffoldState>();

    Constants.setResponsiveSettings(context);

    return Constants.currentScreenWidth == ScreenWidth.large
        ? _buildLargeDeviceScreen(context, _scaffoldKey)
        : _buildSmallDeviceScreen(context, _scaffoldKey);
  }

  _buildLargeDeviceScreen(
      BuildContext context, GlobalKey<ScaffoldState> scaffoldKey) {
    return Scaffold(
      key: scaffoldKey,
      appBar: EmployeeAppBar(
        title: widget.title,
        scaffoldKey: scaffoldKey,
      ),
      endDrawer: const EmployeeDrawerWidget(),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: 300,
            color: Colors.redAccent,
            padding: const EdgeInsets.all(20),
            child: _buildFilterMenu(),
          ),
          Expanded(
            child: _buildCustomersListView(),
          ),
        ],
      ),
      floatingActionButton: FloatingCreateButtonWidget(
        onPressed: () async {
          await Navigator.pushNamed(context, "/update_customer");
          _getCustomers();
        },
        label: "Create New Customer",
      ),
    );
  }

  _buildSmallDeviceScreen(
      BuildContext context, GlobalKey<ScaffoldState> scaffoldKey) {
    return Scaffold(
      key: scaffoldKey,
      appBar: EmployeeAppBar(
        title: widget.title,
        scaffoldKey: scaffoldKey,
      ),
      endDrawer: const EmployeeDrawerWidget(),
      body: _buildCustomersListView(),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingFilterButtonWidget(filterMenu: _buildFilterMenu()),
          const SizedBox(
            height: 10,
          ),
          FloatingCreateButtonWidget(
            onPressed: () async {
              await Navigator.pushNamed(context, "/update_customer");
              _getCustomers();
            },
            label: "Create New Customer",
          ),
        ],
      ),
    );
  }

  _buildCustomersListView() {
    return Align(
      alignment: Alignment.center,
      child: Container(
        alignment: Alignment.center,
        constraints: const BoxConstraints(maxWidth: 750),
        child: ListView.builder(
          itemCount: _customers.length + 1,
          itemBuilder: (context, index) {
            // Ensures there is blank space at the bottom so the last item
            // is not covered by the floating buttons.
            if (index == _customers.length) {
              return const SizedBox(height: 150);
            }

            final customer = _customers[index];

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
                    SizedBox(
                      width: 100,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            customer.lastName.toUpperCase(),
                            style: const TextStyle(color: Colors.white),
                            textAlign: TextAlign.start,
                          ),
                          Text(
                            customer.firstName,
                            style: const TextStyle(color: Colors.white),
                            textAlign: TextAlign.start,
                          ),
                          Text(
                            customer.phone,
                            style: const TextStyle(color: Colors.white),
                            textAlign: TextAlign.start,
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
                                    builder: (context) => CustomerPage(
                                      selectedCustomer: _customers[index],
                                      title: 'Edit Customer',
                                    ),
                                  ),
                                );
                                _getCustomers();
                              },
                              text: "Edit Customer",
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              icon: const Icon(Icons.edit, color: Colors.white),
                              width: 150,
                            ),
                            ButtonWidget(
                              onPressed: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ShopPage(
                                      selectedCustomer: _customers[index],
                                      title: 'Shop',
                                    ),
                                  ),
                                );
                                _getCustomers();
                              },
                              text: "Select Customer",
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              icon: const Icon(Icons.check_circle_outline,
                                  color: Colors.white),
                              width: 150,
                              color: Colors.green,
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

  _buildFilterMenu() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                child: EntryFieldWidget(
                    controller: _searchCtrl, name: "Name search")),
            Container(
                color: Colors.black,
                width: 50,
                height: 50,
                child: IconButton(
                  color: Colors.white,
                  icon: const Icon(Icons.search_rounded),
                  onPressed: () => _getCustomers(),
                )),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        ButtonWidget(onPressed: () => _getCustomers(), text: "Search"),
      ],
    );
  }
}