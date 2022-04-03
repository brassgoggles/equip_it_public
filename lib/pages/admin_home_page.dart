import 'package:equip_it_public/widgets/widgets.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  @override
  Widget build(BuildContext context) {
    Constants.setResponsiveSettings(context);

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Constants.scrollableHome == true ? SingleChildScrollView(
        child: _buildCenterButtons(),
      ) : _buildCenterButtons(),
    );
  }

  _buildCenterButtons(){
    return Align(
      alignment: Alignment.center,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 50),
        child: Wrap(
          spacing: 10,
          runSpacing: 10,
          alignment: WrapAlignment.center,
          children: const [
            HomeMenuButton(
              iconData: Icons.event_note_outlined,
              text: "Roster",
              subText: "(Coming soon)",
            ),
            HomeMenuButton(
              iconData: Icons.badge_outlined,
              text: "Employee",
              routeName: "/employees_list",
            ),
            HomeMenuButton(
              iconData: Icons.construction_outlined,
              text: "Rental Item",
              routeName: "/rental_items_list",
              // subText: "(Coming soon)",
            ),
            HomeMenuButton(
              iconData: Icons.text_snippet_outlined,
              text: "Rental History",
              subText: "(Coming soon)",
            ),
          ],
        ),
      ),
    );
  }
}
