import 'package:flutter/material.dart';

import '../constants.dart';
import '../widgets/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String _readme = "README: \n\n"
      "This project is intended to "
      "showcase some capabilities for a business application and is by far not "
      "a complete working solution for any particular scenario.\n\n"
      "SCENARIO: You are a manager for a business that rents items/equipment "
      "to customers. The items could be anything you like for example tools or "
      "gym equipment.\n\n"
      "The application will so far let you make a sale by selecting a customer "
      "and then adding multiple rental items to their cart (checkout function "
      "yet to be implemented). As a manager, you also have access to the admin "
      "section that allows you to create new / edit employees and rental "
      "equipment.\n\n"
      "Feel free to explore and use the app however you want, please test it "
      "out and have fun (any inappropriate data will be deleted). I encourage "
      "any feedback to info@turtleshellsoftware.com or any other means of "
      "contact you may have.\n\n"
      "DEVELOPMENT INFO: This application has been produced using Flutter as a "
      "front end with my own PHP API's to communicate with a MySql database. "
      "Certain parts of the source code will be available in the future via "
      "GitHub for anyone interested.\n\n"
      "Looking forward to implementing more features and improving UI.\n\n"
      "Cameron Rettke - Turtleshell Software";

  @override
  Widget build(BuildContext context) {
    final _scaffoldKey = GlobalKey<ScaffoldState>();
    Constants.setResponsiveSettings(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: EmployeeAppBar(
        title: widget.title,
        scaffoldKey: _scaffoldKey,
      ),
      endDrawer: const EmployeeDrawerWidget(),
      body: Constants.scrollableHome == true
          ? SingleChildScrollView(
              child: _buildCenterWidgets(),
            )
          : _buildCenterWidgets(),
    );
  }

  _buildCenterWidgets() {
    return Align(
      alignment: Alignment.center,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30),
                constraints: const BoxConstraints(maxWidth: 500),
                child: Text(
                  _readme,
                  textAlign: TextAlign.center,
                )),
            const SizedBox(
              height: 50,
            ),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: const [
                HomeMenuButton(
                  iconData: Icons.badge_outlined,
                  text: "Sale",
                  routeName: "/customers_list",
                ),
                HomeMenuButton(
                  iconData: Icons.text_snippet_outlined,
                  text: "Rental History",
                  subText: "(Coming soon)",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
