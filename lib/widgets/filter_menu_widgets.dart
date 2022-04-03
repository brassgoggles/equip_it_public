import 'package:equip_it_public/widgets/widgets.dart';
import 'package:flutter/material.dart';

class EmployeeFilterMenu extends StatefulWidget {
  final Map<String, bool> filters;
  final TextEditingController searchCtrl;
  final Function searchFunction;

  const EmployeeFilterMenu(
      {Key? key,
        required this.filters,
        required this.searchCtrl,
        required this.searchFunction})
      : super(key: key);

  @override
  State<EmployeeFilterMenu> createState() => _EmployeeFilterMenuState();
}

class _EmployeeFilterMenuState extends State<EmployeeFilterMenu> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                child: EntryFieldWidget(
                    controller: widget.searchCtrl, name: "Name search")),
            Container(
                color: Colors.black,
                width: 50,
                height: 50,
                child: IconButton(
                  color: Colors.white,
                  icon: const Icon(Icons.search_rounded),
                  onPressed: () => widget.searchFunction(),
                )),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        CheckboxListTile(
          title: const Text(
            "Employed",
            style: TextStyle(color: Colors.white),
          ),
          controlAffinity: ListTileControlAffinity.leading,
          checkColor: Colors.redAccent,
          activeColor: Colors.white,
          value: widget.filters["employed"],
          onChanged: (bool? value) {
            setState(() {
              widget.filters["employed"] = value!;
            });
          },
        ),
        CheckboxListTile(
          title: const Text(
            "Employment Ceased",
            style: TextStyle(color: Colors.white),
          ),
          controlAffinity: ListTileControlAffinity.leading,
          checkColor: Colors.redAccent,
          activeColor: Colors.white,
          value: widget.filters["employment_ceased"],
          onChanged: (bool? value) {
            setState(() {
              widget.filters["employment_ceased"] = value!;
            });
          },
        ),
        ButtonWidget(onPressed: () => widget.searchFunction(), text: "Search"),
      ],
    );
  }
}

class RentalItemFilterMenu extends StatefulWidget {
  final Map<String, bool> filters;
  final TextEditingController searchCtrl;
  final Function searchFunction;

  const RentalItemFilterMenu(
      {Key? key,
        required this.filters,
        required this.searchCtrl,
        required this.searchFunction})
      : super(key: key);

  @override
  State<RentalItemFilterMenu> createState() => _RentalItemFilterMenuState();
}

class _RentalItemFilterMenuState extends State<RentalItemFilterMenu> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                child: EntryFieldWidget(
                    controller: widget.searchCtrl, name: "Name search")),
            Container(
                color: Colors.black,
                width: 50,
                height: 50,
                child: IconButton(
                  color: Colors.white,
                  icon: const Icon(Icons.search_rounded),
                  onPressed: () => widget.searchFunction(),
                )),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        CheckboxListTile(
          title: const Text(
            "Active",
            style: TextStyle(color: Colors.white),
          ),
          controlAffinity: ListTileControlAffinity.leading,
          checkColor: Colors.redAccent,
          activeColor: Colors.white,
          value: widget.filters["active"],
          onChanged: (bool? value) {
            setState(() {
              widget.filters["active"] = value!;
            });
          },
        ),
        CheckboxListTile(
          title: const Text(
            "Retired",
            style: TextStyle(color: Colors.white),
          ),
          controlAffinity: ListTileControlAffinity.leading,
          checkColor: Colors.redAccent,
          activeColor: Colors.white,
          value: widget.filters["retired"],
          onChanged: (bool? value) {
            setState(() {
              widget.filters["retired"] = value!;
            });
          },
        ),
        ButtonWidget(onPressed: () => widget.searchFunction(), text: "Search"),
      ],
    );
  }
}
