import 'package:equip_it_public/models/views/employee_address_view.dart';
import 'package:equip_it_public/widgets/widgets.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../data_handler.dart';
import '../models/entities/employee.dart';
import '../widgets/filter_menu_widgets.dart';
import 'employee_page.dart';

class EmployeeListPage extends StatefulWidget {
  const EmployeeListPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<EmployeeListPage> createState() => _EmployeeListPageState();
}

class _EmployeeListPageState extends State<EmployeeListPage> {
  final TextEditingController _searchCtrl = TextEditingController();

  List<dynamic> _employees = <Employee>[];

  final Map<String, bool> _filters = {
    "employed": true,
    "employment_ceased": false
  };

  Future<void> _getEmployees() async {
    _employees =
        await DataHandler.getEmployeeAddressViews(searchName: _searchCtrl.text);

    _filterEmployees();
    setState(() {});
  }

  _filterEmployees() {
    List<dynamic> filteredEmployees = <EmployeeAddressView>[];

    if (_filters["employment_ceased"] == true) {
      filteredEmployees.addAll(_employees
          .where((i) => i.employee.employmentStatus == "employment ceased")
          .toList());
    }

    if (_filters["employed"] == true) {
      filteredEmployees.addAll(_employees
          .where((i) => i.employee.employmentStatus == "employed")
          .toList());
    }

    filteredEmployees.sort((a, b) =>
        (a.employee.lastName.toLowerCase() + a.employee.firstName.toLowerCase())
            .compareTo((b.employee.lastName.toLowerCase() +
                b.employee.firstName.toLowerCase())));
    _employees = filteredEmployees;
  }

  @override
  void initState() {
    _getEmployees();
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
      appBar: AdminAppBar(title: widget.title),
      endDrawer: const AdminDrawerWidget(),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: 300,
            color: Colors.redAccent,
            padding: const EdgeInsets.all(20),
            child: EmployeeFilterMenu(
              filters: _filters,
              searchCtrl: _searchCtrl,
              searchFunction: () async => _getEmployees(),
            ),
          ),
          Expanded(
            child: _buildEmployeesListView(),
          ),
        ],
      ),
      floatingActionButton: FloatingCreateButtonWidget(
        onPressed: () async {
          await Navigator.pushNamed(context, "/update_employee");
          _getEmployees();
        },
        label: "Create New Employee",
      ),
    );
  }

  _buildSmallDeviceScreen(BuildContext context) {
    return Scaffold(
      appBar: AdminAppBar(title: widget.title),
      endDrawer: const AdminDrawerWidget(),
      body: _buildEmployeesListView(),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingFilterButtonWidget(
              filterMenu: EmployeeFilterMenu(
            filters: _filters,
            searchCtrl: _searchCtrl,
            searchFunction: () async => _getEmployees(),
          )),
          const SizedBox(
            height: 10,
          ),
          FloatingCreateButtonWidget(
            onPressed: () async {
              await Navigator.pushNamed(context, "/update_employee");
              _getEmployees();
            },
            label: "Create New Employee",
          ),
        ],
      ),
    );
  }

  _buildEmployeesListView() {
    return Align(
      alignment: Alignment.center,
      child: Container(
        alignment: Alignment.center,
        constraints: const BoxConstraints(maxWidth: 750),
        child: ListView.builder(
          itemCount: _employees.length + 1,
          itemBuilder: (context, index) {
            // Ensures there is blank space at the bottom so the last item
            // is not covered by the floating buttons.
            if (index == _employees.length) {
              return const SizedBox(height: 100);
            }

            final employee = _employees[index];

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
                      flex: 2,
                      child: Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(15),
                            constraints: const BoxConstraints(maxHeight: 80),
                            child: CircleAvatar(
                              radius: 30,
                              backgroundImage:
                                  employee.employee.profileImageUrl != ""
                                      ? NetworkImage(
                                          employee.employee.profileImageUrl)
                                      : const AssetImage(
                                          'assets/images/default_profile_image_250x250.jpg',
                                        ) as ImageProvider,
                            ),
                          ),
                          SizedBox(
                            width: 100,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  employee.employee.lastName.toUpperCase(),
                                  style: const TextStyle(color: Colors.white),
                                  textAlign: TextAlign.start,
                                ),
                                Text(
                                  employee.employee.firstName,
                                  style: const TextStyle(color: Colors.white),
                                  textAlign: TextAlign.start,
                                ),
                                Text(
                                  employee.employee.phone,
                                  style: const TextStyle(color: Colors.white),
                                  textAlign: TextAlign.start,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 150),
                        margin: const EdgeInsets.all(15),
                        child: ButtonWidget(
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EmployeePage(
                                  selectedEmployeeAddressView:
                                      _employees[index],
                                  title: 'Edit Employee',
                                ),
                              ),
                            );
                            _getEmployees();
                          },
                          text:
                              Constants.currentScreenWidth == ScreenWidth.small
                                  ? "Edit"
                                  : "Edit Employee",

                          icon: const Icon(Icons.edit, color: Colors.white),
                          // width: 150,
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
}