import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

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
import '../models/entities/employee.dart';

import 'package:path/path.dart' as path;

import '../config.dart';

class EmployeePage extends StatefulWidget {
  const EmployeePage(
      {Key? key, required this.title, this.selectedEmployeeAddressView})
      : super(key: key);

  final String title;
  final EmployeeAddressView? selectedEmployeeAddressView;

  @override
  State<EmployeePage> createState() => _EmployeePageState();
}

class _EmployeePageState extends State<EmployeePage> {
  final _formKey = GlobalKey<FormState>();

  //#region employee Ctrl's
  final TextEditingController _firstNameCtrl = TextEditingController();
  final TextEditingController _lastNameCtrl = TextEditingController();
  final TextEditingController _phoneCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  //#endregion

  //#region address Ctrl's
  final TextEditingController _unitNumberCtrl = TextEditingController();
  final TextEditingController _streetNumberCtrl = TextEditingController();
  final TextEditingController _streetNameCtrl = TextEditingController();
  final TextEditingController _suburbCtrl = TextEditingController();
  final TextEditingController _stateCtrl = TextEditingController();
  final TextEditingController _countryCtrl = TextEditingController();
  final TextEditingController _postCodeCtrl = TextEditingController();
  final TextEditingController _additionalInformationCtrl =
      TextEditingController();
  //#endregion

  // Fresh modals - These are initialized if required for "Update".
  Employee _employee = Employee(DateTime.now());
  Address _address = Address();

  final List<String> _positions = ["clerk", "manager", "supervisor", "owner"];
  final List<String> _employmentStatuses = ["employed", "pending", "employment ceased"];

  bool isSending = false;

  Uint8List? _imageFile;
  String _imageFileName = "";
  bool _isUpdate = false;

  _setImage() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null && result.files.isNotEmpty) {
      Uint8List? fileBytes = result.files.first.bytes;

      _imageFileName = generateFileName();

      setState(() {
        _imageFile = fileBytes;
      });
    } else {
      return; // Picker was cancelled by User.
    }
  }

  String generateFileName() {
    var uuid = const Uuid();
    return "${uuid.v1()}.jpg";
  }

  Future<bool> _saveEmployeeData() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const LoadingSpinnerWidget();
      },
    );

    // Check there is a new image to save.
    if (_imageFile != null) {
      // Check for old image and delete if there is.
      if (_employee.profileImageUrl.isNotEmpty) {
        // Only the filename is sent through to ensure users can only delete from
        // the designated "images" folder.
        String oldFileName =
            File(_employee.profileImageUrl).uri.pathSegments.last;
        ApiResponse deleteResponse = await DataHandler.deleteImage(oldFileName);

        if (deleteResponse.error) {
          Navigator.pop(context);
          await showAlertDialog(
              context, "Okay", "Error", "Unable to upload image at this time.");
          return false;
        }
      }

      // New file path.
      _employee.profileImageUrl =
          "${Config.rootPath}storage/images/employee/$_imageFileName";

      var uploadImageResponse = await DataHandler.uploadImage(
          base64Encode(List.from(_imageFile!)), _imageFileName, "employee");

      if (uploadImageResponse.error) {
        Navigator.pop(context);
        // TODO: Replace detailed error alert with generic alert.
        await showAlertDialog(
            context, "Okay", "uploadImage Error", uploadImageResponse.message);
        return false;
      }
    }

    try {
      ApiResponse apiResponse = ApiResponse();

      // Create Address entry first. address_id will be used as foreign key.
      // TODO: Change this to a db transaction (in the API).
      apiResponse = _isUpdate
          ? await DataHandler.updateAddress(_address)
          : await DataHandler.createAddress(_address);

      if (!_isUpdate && apiResponse.args["address_id"] == null) {
        // TODO: Remove this print for prod.
        print(
            "********** NewEmployeePage - createNewEmployee() - createAddress error:\n"
            "${apiResponse.message}");
        Navigator.pop(context);
        showAlertDialog(context, "Okay", "Error",
            "Something has gone wrong. Please try again later.");
        return false;
      }

      if (!_isUpdate) {
        _employee.userLevel = "user";
        _employee.created = DateTime.now();
        _employee.addressId = int.parse(apiResponse.args["address_id"]);
      }
      _employee.lastModified = DateTime.now();

      apiResponse = _isUpdate
          ? await DataHandler.updateEmployee(_employee)
          : await DataHandler.createEmployee(_employee);

      if (apiResponse.error) {
        // TODO: Remove this print for prod.
        print(
            "********** NewEmployeePage - createNewEmployee() - createEmployee error:\n"
            "${apiResponse.message}");
        Navigator.pop(context);
        showAlertDialog(context, "Okay", "Error",
            "Something has gone wrong. Please try again later.");
        return false;
      }
    } catch (e) {
      // TODO: Remove print.
      print("********** saveEmployeeData exception: $e **********");
    }
    // Remove the loading spinner.
    Navigator.pop(context);

    await showAlertDialog(
        context,
        "Okay",
        "Success",
        _isUpdate
            ? "Successfully updated employee."
            : "Successfully created employee.");

    Navigator.pop(context);
    return true;
  }

  Widget _setCoverImage() {
    if (_imageFile != null) {
      return Image.memory(_imageFile!);
    } else if (_employee.profileImageUrl.isNotEmpty) {
      return Image.network(_employee.profileImageUrl);
    } else {
      return const Icon(Icons.add_circle_outline);
    }
  }

  //#region Initializers
  _initializeEmployeeDetails() {
    if (widget.selectedEmployeeAddressView != null) {
      _isUpdate = true;

      _employee = widget.selectedEmployeeAddressView!.employee;
      _firstNameCtrl.text = _employee.firstName;
      _lastNameCtrl.text = _employee.lastName;
      _phoneCtrl.text = _employee.phone;
      _emailCtrl.text = _employee.email;

      _address = widget.selectedEmployeeAddressView!.address;
      _unitNumberCtrl.text = _address.unitNumber!;
      _streetNumberCtrl.text = _address.streetNumber;
      _streetNameCtrl.text = _address.streetName;
      _suburbCtrl.text = _address.suburb;
      _countryCtrl.text = _address.country;
      _postCodeCtrl.text = _address.postCode;
      _additionalInformationCtrl.text = _address.additionalInformation!;
    } else {
      _employee.position = _positions[0];
      _employee.employmentStatus = _employmentStatuses[0];
    }
  }

  _initControllerListeners() {
    _firstNameCtrl.addListener(() {
      _employee.firstName = _firstNameCtrl.text;
    });
    _lastNameCtrl.addListener(() {
      _employee.lastName = _lastNameCtrl.text;
    });
    _phoneCtrl.addListener(() {
      _employee.phone = _phoneCtrl.text;
    });
    _emailCtrl.addListener(() {
      _employee.email = _emailCtrl.text;
    });

    _unitNumberCtrl.addListener(() {
      _address.unitNumber = _unitNumberCtrl.text;
    });
    _streetNumberCtrl.addListener(() {
      _address.streetNumber = _streetNumberCtrl.text;
    });
    _streetNameCtrl.addListener(() {
      _address.streetName = _streetNameCtrl.text;
    });
    _suburbCtrl.addListener(() {
      _address.suburb = _suburbCtrl.text;
    });
    _countryCtrl.addListener(() {
      _address.country = _countryCtrl.text;
    });
    _postCodeCtrl.addListener(() {
      _address.postCode = _postCodeCtrl.text;
    });
    _additionalInformationCtrl.addListener(() {
      _address.additionalInformation = _additionalInformationCtrl.text;
    });
  }

  @override
  void initState() {
    _initializeEmployeeDetails();
    _initControllerListeners();
    super.initState();
  }
  //#endregion

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _unitNumberCtrl.dispose();
    _streetNumberCtrl.dispose();
    _streetNameCtrl.dispose();
    _suburbCtrl.dispose();
    _stateCtrl.dispose();
    _countryCtrl.dispose();
    _postCodeCtrl.dispose();
    _additionalInformationCtrl.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Constants.setResponsiveSettings(context);

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
              _buildEmployeeDetails(context),
              const SizedBox(
                height: 50,
              ),
              _buildAddressDetails(context),
              const SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildEmployeeDetails(BuildContext context) {
    return FormContainerWidget(
      horizontalMargin: Constants.formMarginHorizontal,
      bodyWidget: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            "Employee Details",
            style: TextStyle(color: Colors.white, fontSize: 30),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 20,
            runSpacing: Constants.formFieldSpacer,
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
              _buildGenderRadioButtons(context),
              Column(
                children: [
                  EntryFieldWidget(
                    controller: _phoneCtrl,
                    name: "*Phone number...",
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(30),
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return "Please enter phone number.";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: Constants.formFieldSpacer,
                  ),
                  EntryFieldWidget(
                    controller: _emailCtrl,
                    name: "*Email address...",
                    inputFormatters: [LengthLimitingTextInputFormatter(500)],
                    validator: (text) {
                      //TODO: Check valid email format.
                      if (text == null || text.isEmpty) {
                        return "Please enter email.";
                      }
                      return null;
                    },
                  ),
                ],
              ),
              _buildDateOfBirthSelection(context, Constants.formWidgetWidth),
              // TODO: Make it so that only authorized staff can modify position.
              _buildPositionSelection(context),
            ],
          ),
          const SizedBox(height: 30),
          Text(
            "Profile Image",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: Constants.headingFontSize),
          ),
          const SizedBox(height: 10),
          Container(
            width: 300,
            height: 300,
            color: Constants.equipItPink,
            child: MaterialButton(
              onPressed: () => _setImage(),
              child: Align(
                alignment: Alignment.center,
                child: _setCoverImage(),
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildEmploymentStatusSelection(context),
        ],
      ),
    );
  }

  _buildAddressDetails(BuildContext context) {
    return FormContainerWidget(
      horizontalMargin: 20,
      bodyWidget: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            "Address Details",
            style: TextStyle(color: Colors.white, fontSize: 30),
          ),
          const SizedBox(
            height: 20,
          ),
          Wrap(
            spacing: 20,
            runSpacing: Constants.formFieldSpacer,
            runAlignment: WrapAlignment.center,
            alignment: WrapAlignment.center,
            children: [
              EntryFieldWidget(
                controller: _unitNumberCtrl,
                name: "Unit number...",
                keyboardType: TextInputType.number,
                inputFormatters: [LengthLimitingTextInputFormatter(6)],
              ),
              EntryFieldWidget(
                controller: _streetNumberCtrl,
                name: "*House/building number...",
                keyboardType: TextInputType.number,
                inputFormatters: [LengthLimitingTextInputFormatter(6)],
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return "Please enter house number.";
                  }
                  return null;
                },
              ),
              EntryFieldWidget(
                controller: _streetNameCtrl,
                name: "*Street name...",
                inputFormatters: [LengthLimitingTextInputFormatter(200)],
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return "Please enter street name.";
                  }
                  return null;
                },
              ),
              EntryFieldWidget(
                controller: _suburbCtrl,
                name: "*Suburb...",
                inputFormatters: [LengthLimitingTextInputFormatter(200)],
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return "Please enter suburb.";
                  }
                  return null;
                },
              ),
              // TODO: Replace with drop box.
              EntryFieldWidget(
                controller: _stateCtrl,
                name: "*State...",
                inputFormatters: [LengthLimitingTextInputFormatter(200)],
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return "Please enter state.";
                  }
                  return null;
                },
              ),
              // TODO: Replace with drop box of countries (find an api for that).
              EntryFieldWidget(
                controller: _countryCtrl,
                name: "*Country...",
                inputFormatters: [LengthLimitingTextInputFormatter(200)],
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return "Please enter country.";
                  }
                  return null;
                },
              ),
              // TODO: find an api to validate post code/autofill postcode.
              EntryFieldWidget(
                controller: _postCodeCtrl,
                name: "*Post code...",
                keyboardType: TextInputType.number,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(4),
                  FilteringTextInputFormatter.digitsOnly
                ],
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return "Please enter post code.";
                  }
                  return null;
                },
              ),
              EntryFieldWidget(
                  controller: _additionalInformationCtrl,
                  name: "Additional information..."),
              ButtonWidget(
                onPressed: () {
                  if (Constants.prodMode) {
                    _saveEmployeeData();
                  } else {
                    _formKey.currentState!.validate() ? _saveEmployeeData() : null;
                  }
                },
                text: !_isUpdate ? "Create" : "Update",
                width: Constants.formWidgetWidth,
              ),
            ],
          ),
        ],
      ),
    );
  }

  _buildEmploymentStatusSelection(BuildContext context) {
    return Container(
      height: 100,
      width: Constants.formWidgetWidth,
      padding: const EdgeInsets.all(10),
      constraints: BoxConstraints(
        maxWidth: Constants.formWidgetWidth,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: Colors.white,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          const Text(
            "Employment Status",
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: DropdownButton(
                value: _employee.employmentStatus,
                items: _employmentStatuses.map((value) {
                  return DropdownMenuItem(
                    child: Text(
                      value,
                    ),
                    value: value,
                  );
                }).toList(),
                icon: const Icon(Icons.arrow_drop_down),
                iconSize: 42,
                underline: const SizedBox(),
                onChanged: (value) {
                  setState(() {
                    _employee.employmentStatus = value.toString();
                  });
                }),
          ),
        ],
      ),
    );
  }

  _buildPositionSelection(BuildContext context) {
    return Container(
      height: 100,
      width: Constants.formWidgetWidth,
      padding: const EdgeInsets.all(10),
      constraints: BoxConstraints(
        maxWidth: Constants.formWidgetWidth,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: Colors.white,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          const Text(
            "*Position",
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: DropdownButton(
                value: _employee.position,
                items: _positions.map((value) {
                  return DropdownMenuItem(
                    child: Text(
                      value,
                    ),
                    value: value,
                  );
                }).toList(),
                icon: const Icon(Icons.arrow_drop_down),
                iconSize: 42,
                underline: const SizedBox(),
                onChanged: (value) {
                  setState(() {
                    _employee.position = value.toString().toLowerCase();
                  });
                }),
          ),
        ],
      ),
    );
  }

  Future<void> _showDateOfBirthPicker(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: _employee.birthDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: _employee.birthDate ?? DateTime.now(),
    );

    if (selectedDate != null) {
      setState(() {
        _employee.birthDate = selectedDate;
      });
    }
  }

  _buildDateOfBirthSelection(BuildContext context, double width) {
    return Container(
      height: 100,
      padding: const EdgeInsets.all(10),
      constraints: BoxConstraints(
        maxWidth: Constants.formWidgetWidth,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: Colors.white,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          const Text(
            "*Date of Birth",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                  child: ButtonWidget(
                      onPressed: () => _showDateOfBirthPicker(context),
                      text: "Select...")),
              Expanded(
                child: Text(
                  DateFormat("dd/MM/yyyy")
                      .format(_employee.birthDate ?? DateTime.now()),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _buildGenderRadioButtons(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: Constants.formWidgetWidth,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: Colors.white,
          width: 1,
        ),
      ),
      padding: const EdgeInsets.only(top: 10, bottom: 20),
      child: Column(
        children: [
          const Text(
            "Gender",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                child: RadioButtonWidget(
                    title: "Male",
                    value: "Male",
                    groupValue: _employee.gender,
                    onChanged: (value) {
                      setState(() {
                        _employee.gender = value.toString();
                      });
                    }),
              ),
              Expanded(
                child: RadioButtonWidget(
                    title: "Female",
                    value: "Female",
                    groupValue: _employee.gender,
                    onChanged: (value) {
                      setState(() {
                        _employee.gender = value.toString();
                      });
                    }),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                child: RadioButtonWidget(
                    title: "Other",
                    value: "Other",
                    groupValue: _employee.gender,
                    onChanged: (value) {
                      setState(() {
                        _employee.gender = value.toString();
                      });
                    }),
              ),
              Expanded(
                child: RadioButtonWidget(
                    title: "Prefer not to disclose",
                    value: "Prefer not to disclose",
                    fontSize: 12,
                    groupValue: _employee.gender,
                    onChanged: (value) {
                      setState(() {
                        _employee.gender = value.toString();
                      });
                    }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
