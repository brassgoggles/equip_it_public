import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:decimal/decimal.dart';
import 'package:equip_it_public/models/entities/rental_item.dart';
import 'package:equip_it_public/models/views/employee_address_view.dart';
import 'package:equip_it_public/widgets/widgets.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../constants.dart';
import '../data_handler.dart';
import '../models/entities/address.dart';
import '../models/api_response.dart';
import '../models/entities/customer.dart';
import '../models/entities/employee.dart';

import 'package:path/path.dart' as path;


class CustomerPage extends StatefulWidget {
  const CustomerPage({Key? key, required this.title, this.selectedCustomer})
      : super(key: key);

  final String title;
  final Customer? selectedCustomer;

  @override
  State<CustomerPage> createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  final _formKey = GlobalKey<FormState>();

  // TODO: Stash in Constants file.
  final double formWidgetWidth = 300;
  final double formFieldSpacer = 20;

  //#region Ctrl's
  final TextEditingController _firstNameCtrl = TextEditingController();
  final TextEditingController _lastNameCtrl = TextEditingController();
  final TextEditingController _organisationCtrl = TextEditingController();
  final TextEditingController _phoneCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  //#endregion

  Customer _customer = Customer("", "", "", DateTime.now());

  bool isSending = false;
  bool _isUpdate = false;

  Future<bool> _saveCustomerData() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const LoadingSpinnerWidget();
      },
    );

    try {
      ApiResponse apiResponse = ApiResponse();

      apiResponse = _isUpdate
          ? await DataHandler.updateCustomer(_customer)
          : await DataHandler.createCustomer(_customer);

      if (apiResponse.error) {
        // TODO: Remove this print for prod.
        print(
            "********** CustomerPage - createNewCustomer() error:\n"
            "${apiResponse.message}");
        Navigator.pop(context);
        showAlertDialog(context, "Okay", "Error",
            "Something has gone wrong. Please try again later.");
        return false;
      }
    } catch (e) {
      // TODO: Remove print.
      print("********** saveCustomerData exception: $e **********");
    }
    // Remove the loading spinner.
    Navigator.pop(context);

    await showAlertDialog(
        context,
        "Okay",
        "Success",
        _isUpdate
            ? "Successfully updated customer."
            : "Successfully created customer.");

    Navigator.pop(context);
    return true;
  }

  //#region responsive settings
  double _headingFontSize = 30;
  double _formMarginHorizontal = 50;
  double _imageSize = 400;
  double _textAreaWidth = 625;

  bool _smallInfoWrap = false;

  _setResponsiveSettings() {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    if (queryData.size.width < 502) {
      _smallInfoWrap = true;
      _imageSize = 250;
    } else if (queryData.size.width < 780) {
      _textAreaWidth = 300;
    } else {
      _smallInfoWrap = false;
      _imageSize = 400;
      _textAreaWidth = 625;
    }
    if (queryData.size.width < 650) {
      _headingFontSize = 20;
      _formMarginHorizontal = 20;
    } else {
      _headingFontSize = 30;
      _formMarginHorizontal = 50;
    }
  }

  //#endregion

  //#region Initializers
  _initializeCustomerDetails() {
    if (widget.selectedCustomer != null) {
      _isUpdate = true;

      _customer = widget.selectedCustomer!;
      _firstNameCtrl.text = _customer.firstName;
      _lastNameCtrl.text = _customer.lastName;
      _organisationCtrl.text = _customer.organisation;
      _phoneCtrl.text = _customer.phone;
      _emailCtrl.text = _customer.email;
    }
  }

  _initControllerListeners() {
    _firstNameCtrl.addListener(() {
      _customer.firstName = _firstNameCtrl.text;
    });
    _lastNameCtrl.addListener(() {
      _customer.lastName = _lastNameCtrl.text;
    });
    _organisationCtrl.addListener(() {
      _customer.organisation = _organisationCtrl.text;
    });
    _phoneCtrl.addListener(() {
      _customer.phone = _phoneCtrl.text;
    });
    _emailCtrl.addListener(() {
      _customer.email = _emailCtrl.text;
    });
  }

  @override
  void initState() {
    _initializeCustomerDetails();
    _initControllerListeners();
    super.initState();
  }

  //#endregion

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _organisationCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _setResponsiveSettings();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              const Text("Fields marked with an asterisk (*) are required."),
              const SizedBox(
                height: 10,
              ),
              _buildRentalItemDetails(context),
              const SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildRentalItemDetails(BuildContext context) {
    return FormContainerWidget(
      horizontalMargin: _formMarginHorizontal,
      bodyWidget: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            "Customer Details",
            style: TextStyle(color: Colors.white, fontSize: 30),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 20,
            runSpacing: formFieldSpacer,
            runAlignment: WrapAlignment.center,
            alignment: WrapAlignment.center,
            children: [
              EntryFieldWidget(
                controller: _firstNameCtrl,
                name: "*First name...",
                inputFormatters: [LengthLimitingTextInputFormatter(200)],
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return "Please enter first name.";
                  }
                  return null;
                },
              ),
              EntryFieldWidget(
                controller: _lastNameCtrl,
                name: "*Last name...",
                inputFormatters: [LengthLimitingTextInputFormatter(200)],
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return "Please enter last name.";
                  }
                  return null;
                },
              ),
              EntryFieldWidget(
                controller: _organisationCtrl,
                name: "Organisation...",
                inputFormatters: [LengthLimitingTextInputFormatter(200)],
              ),
              EntryFieldWidget(
                controller: _phoneCtrl,
                name: "*Phone...",
                inputFormatters: [LengthLimitingTextInputFormatter(30)],
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return "Please enter phone number.";
                  }
                  return null;
                },
              ),
              EntryFieldWidget(
                controller: _emailCtrl,
                name: "*Email...",
                inputFormatters: [LengthLimitingTextInputFormatter(500)],
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return "Please enter email.";
                  }
                  return null;
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          ButtonWidget(
            onPressed: () {
              if (Constants.prodMode) {
                _saveCustomerData();
              } else {
                _formKey.currentState!.validate() ? _saveCustomerData() : null;
              }
            },
            text: !_isUpdate ? "Create" : "Update",
            width: formWidgetWidth,
          ),
        ],
      ),
    );
  }
}
