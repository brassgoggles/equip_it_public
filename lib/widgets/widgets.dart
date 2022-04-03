import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants.dart';

class EmployeeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const EmployeeAppBar(
      {Key? key, required this.title, required this.scaffoldKey})
      : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(50);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          );
        },
      ),
      actions: [
        Constants.user.userLevel == "admin" &&
                Constants.currentScreenWidth != ScreenWidth.small
            ? Container(
                width: 150,
                padding:
                    const EdgeInsets.symmetric(vertical: 7.5, horizontal: 5),
                child: ButtonWidget(
                  onPressed: () async =>
                      await Navigator.pushNamed(context, '/admin_home'),
                  text: 'ADMIN',
                ))
            : Container(),
        IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              scaffoldKey.currentState?.openEndDrawer();
            }),
      ],
    );
  }
}

class EmployeeDrawerWidget extends StatelessWidget {
  const EmployeeDrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            height: 200,
            width: double.infinity,
            color: Colors.red,
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                margin: const EdgeInsets.all(20),
                child: const Text(
                  "Equip It",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                  ),
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            controller: ScrollController(),
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      _buildMenuButton(context, "/home", "Home", Icons.home),
                      Constants.user.userLevel == "admin"
                          ? Container(
                              width: 150,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 7.5, horizontal: 5),
                              child: ButtonWidget(
                                onPressed: () async =>
                                    await Navigator.pushNamed(
                                        context, '/admin_home'),
                                text: 'ADMIN',
                              ))
                          : Container(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildMenuButton(
      BuildContext context, String routeName, String label, IconData icon) {
    return MaterialButton(
      onPressed: () async {
        await Navigator.pushNamedAndRemoveUntil(
            context, "/home", (Route<dynamic> route) => false);
        if (routeName != "/home") {
          await Navigator.pushNamed(context, routeName);
        }
      },
      child: Row(
        children: [
          Container(margin: const EdgeInsets.all(15), child: Icon(icon)),
          Text(
            label,
            style: const TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}

class AdminAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const AdminAppBar({Key? key, required this.title}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(50);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}

class AdminDrawerWidget extends StatelessWidget {
  const AdminDrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            height: 200,
            width: double.infinity,
            color: Colors.red,
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                margin: const EdgeInsets.all(20),
                child: const Text(
                  "Equip It",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                  ),
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            controller: ScrollController(),
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      _buildMenuButton(context, "/home", "Home", Icons.home),
                      _buildMenuButton(context, "/rental_items_list", "Roster",
                          Icons.event_note_outlined),
                      _buildMenuButton(context, "/employees_list", "Employee",
                          Icons.badge_outlined),
                      _buildMenuButton(context, "/rental_items_list",
                          "Rental Item", Icons.construction_outlined),
                      _buildMenuButton(context, "/rental_items_list",
                          "Rental History", Icons.text_snippet_outlined),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildMenuButton(
      BuildContext context, String routeName, String label, IconData icon) {
    return MaterialButton(
      onPressed: () {
        Navigator.pushNamedAndRemoveUntil(
            context, "/home", (Route<dynamic> route) => false);
        if (routeName != "/home") {
          Navigator.pushNamed(context, routeName);
        }
      },
      child: Row(
        children: [
          Container(margin: const EdgeInsets.all(15), child: Icon(icon)),
          Text(
            label,
            style: const TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}

class LoadingSpinnerWidget extends StatelessWidget {
  const LoadingSpinnerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 50),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            CircularProgressIndicator(),
            SizedBox(
              height: 30,
            ),
            Text("Loading"),
          ],
        ),
      ),
    );
  }
}

Future<dynamic>? showAlertDialog(
    BuildContext context, String okayText, String title, String message) async {
  // set up the button
  Widget okayButton = TextButton(
    child: Text(okayText),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(title),
    content: Container(
        constraints: const BoxConstraints(
          maxWidth: 500,
        ),
        child: SingleChildScrollView(child: Text(message))),
    actions: [
      okayButton,
    ],
  );

  // show the dialog
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
  return null;
}

class ButtonWidget extends StatelessWidget {
  final Function onPressed;
  final String text;
  final double width;
  final double height;
  final Icon? icon;
  final MainAxisAlignment mainAxisAlignment;
  final Color color;

  const ButtonWidget(
      {Key? key,
      required this.onPressed,
      required this.text,
      this.width = 300,
      this.height = 50,
      this.icon,
      this.mainAxisAlignment = MainAxisAlignment.center,
      this.color = Colors.black})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: color,
      ),
      constraints: BoxConstraints(
        maxWidth: width,
      ),
      child: MaterialButton(
        minWidth: 300,
        height: 50,
        onPressed: () {
          onPressed();
        },
        child: Row(
          mainAxisAlignment: mainAxisAlignment,
          children: [
            icon ?? const SizedBox(width: 0, height: 0),
            Flexible(
              child: Container(
                // margin: EdgeInsets.only(left: Constants.currentScreenWidth == ScreenWidth.small ? 0 : 15),
                margin: EdgeInsets.only(
                    left: icon != null &&
                            Constants.currentScreenWidth == ScreenWidth.small
                        ? 15
                        : 0),
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EntryFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String name;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final double marginTop;
  final double marginBottom;
  final int minLines;
  final int? maxLines;
  final double maxWidth;

  const EntryFieldWidget(
      {Key? key,
      required this.controller,
      required this.name,
      this.validator,
      this.inputFormatters,
      this.keyboardType,
      this.minLines = 1,
      this.maxLines = 1,
      this.maxWidth = 300,
      this.marginTop = 0,
      this.marginBottom = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: marginTop, bottom: marginBottom),
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: name,
          labelStyle: const TextStyle(
            color: Colors.white,
          ),
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white)),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white)),
          fillColor: Colors.white,
          errorStyle: const TextStyle(color: Colors.amber),
        ),
        validator: validator,
        inputFormatters: inputFormatters,
        keyboardType: keyboardType,
        minLines: minLines,
        maxLines: maxLines,
        style: const TextStyle(color: Colors.white),
        cursorColor: Colors.white,
      ),
    );
  }
}

class RadioButtonWidget<T> extends StatelessWidget {
  final T value;
  final T groupValue;
  final String title;
  final ValueChanged<T?> onChanged;

  final double fontSize;

  const RadioButtonWidget({
    Key? key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.title,
    this.fontSize = 16,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            _customRadioButton,
          ],
        ),
      ),
    );
  }

  Widget get _customRadioButton {
    final isSelected = value == groupValue;
    return Expanded(
      child: Container(
          constraints: const BoxConstraints(
            minHeight: 50,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : null,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: Colors.white,
              width: 2,
            ),
          ),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isSelected ? Colors.red : Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: fontSize,
              ),
            ),
          )),
    );
  }
}

class FormContainerWidget extends StatelessWidget {
  const FormContainerWidget(
      {Key? key,
      required this.bodyWidget,
      this.verticalMargin = 0,
      this.horizontalMargin = 0})
      : super(key: key);

  final Widget bodyWidget;
  final double verticalMargin;
  final double horizontalMargin;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 900),
        margin: EdgeInsets.symmetric(
            vertical: verticalMargin, horizontal: horizontalMargin),
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(5),
        ),
        child: bodyWidget,
      ),
    );
  }
}

class HomeMenuButton extends StatelessWidget {
  final double minHeight;
  final double minWidth;
  final IconData iconData;
  final String text;
  final String? subText;
  final String routeName;

  const HomeMenuButton(
      {Key? key,
      this.minHeight = 150,
      this.minWidth = 300,
      required this.iconData,
      required this.text,
      this.subText,
      this.routeName = ""})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.redAccent,
      ),
      constraints: BoxConstraints(minHeight: minHeight, minWidth: minWidth),
      child: MaterialButton(
        onPressed: () => Navigator.pushNamed(context, routeName),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Icon(
                iconData,
                color: Colors.white,
                size: 50,
              ),
              const SizedBox(height: 20),
              Text(
                text,
                style: const TextStyle(color: Colors.white, fontSize: 30),
              ),
              Text(subText ?? ""),
            ],
          ),
        ),
      ),
    );
  }
}

class FloatingFilterButtonWidget extends StatelessWidget {
  final Widget filterMenu;

  const FloatingFilterButtonWidget({Key? key, required this.filterMenu})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () async {
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(
              builder: (BuildContext context,
                  void Function(void Function()) setState) {
                return AlertDialog(
                  backgroundColor: Colors.redAccent,
                  title: const Text("Search / Filter"),
                  content: filterMenu,
                  actions: [
                    TextButton(
                      child: const Text("Close"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          },
        );
      },
      heroTag: "btn_filter",
      tooltip: 'Search/Filter Employee',
      label: const Text("Search / Filter"),
      icon: const Icon(Icons.search_rounded),
      backgroundColor: Constants.equipItPink,
    );
  }
}

class FloatingCreateButtonWidget extends StatelessWidget {
  final Function onPressed;
  final String label;

  const FloatingCreateButtonWidget(
      {Key? key, required this.onPressed, required this.label})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => onPressed(),
      heroTag: "btn_create",
      tooltip: 'Create New Employee',
      label: Text(label),
      icon: const Icon(Icons.add_outlined),
      backgroundColor: Constants.equipItPink,
    );
  }
}
