import 'package:equip_it_public/pages/admin_home_page.dart';
import 'package:equip_it_public/pages/cart_page.dart';
import 'package:equip_it_public/pages/customer_list_page.dart';
import 'package:equip_it_public/pages/customer_page.dart';
import 'package:equip_it_public/pages/employee_list_page.dart';
import 'package:equip_it_public/pages/employee_page.dart';
import 'package:equip_it_public/pages/home_page.dart';
import 'package:equip_it_public/pages/login_page.dart';
import 'package:equip_it_public/pages/rental_item_list_page.dart';
import 'package:equip_it_public/pages/rental_item_page.dart';
import 'package:equip_it_public/pages/shop_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:provider/provider.dart';

import 'models/cart_model.dart';
import 'models/entities/customer.dart';

void configureApp() {
  setUrlStrategy(PathUrlStrategy());
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  configureApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CartModel(),
      child: MaterialApp(
          title: 'Equip It',
          theme: ThemeData(
            primarySwatch: Colors.red,
          ),
          debugShowCheckedModeBanner: false,
          home: const HomePage(title: 'Home'),
          routes: {
            '/login': (context) => const LoginPage(
                  title: 'Login',
                ),
            '/home': (context) => const HomePage(
                  title: 'Equip It',
                ),
            '/customers_list': (context) => const CustomerListPage(
                  title: 'Select Customer',
                ),
            '/shop': (context) => ShopPage(
                  title: 'Shop',
                  selectedCustomer:
                      ModalRoute.of(context)?.settings.arguments as Customer,
                ),
            '/cart': (context) => const CartPage(),
            '/update_customer': (context) => const CustomerPage(
                  title: 'Customer',
                ),
            '/admin_home': (context) => const AdminHomePage(
                  title: 'Equip It - Admin',
                ),
            '/employees_list': (context) => const EmployeeListPage(
                  title: 'Select Employee',
                ),
            '/update_employee': (context) => const EmployeePage(
                  title: 'Employee',
                ),
            '/rental_items_list': (context) => const RentalItemListPage(
                  title: 'Select Item',
                ),
            '/update_rental_item': (context) => const RentalItemPage(
                  title: 'Rental Item',
                ),
          }),
    );
  }
}
