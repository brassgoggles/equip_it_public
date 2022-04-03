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
import '../models/entities/employee.dart';

import 'package:path/path.dart' as path;

import '../config.dart';

class RentalItemPage extends StatefulWidget {
  const RentalItemPage({Key? key, required this.title, this.selectedRentalItem})
      : super(key: key);

  final String title;
  final RentalItem? selectedRentalItem;

  @override
  State<RentalItemPage> createState() => _RentalItemPageState();
}

class _RentalItemPageState extends State<RentalItemPage> {
  final _formKey = GlobalKey<FormState>();

  //#region employee Ctrl's
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _rentCostCtrl = TextEditingController();
  final TextEditingController _purchaseCostCtrl = TextEditingController();
  final TextEditingController _qualityCtrl = TextEditingController();
  final TextEditingController _notesCtrl = TextEditingController();

  //#endregion

  // Fresh modals - These are initialized if required for "Update".
  RentalItem _rentalItem = RentalItem("", DateTime.now());

  final List<String> _activeStatuses = ["active", "retired"];

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

  Future<bool> saveRentalItemData() async {
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
      if (_rentalItem.imageUrl.isNotEmpty) {
        // Only the filename is sent through to ensure users can only delete from
        // the designated "images" folder.
        String oldFileName = File(_rentalItem.imageUrl).uri.pathSegments.last;
        ApiResponse deleteResponse = await DataHandler.deleteImage(oldFileName);

        if (deleteResponse.error) {
          Navigator.pop(context);
          await showAlertDialog(
              context, "Okay", "Error", "Unable to upload image at this time.");
          return false;
        }
      }

      // New file path.
      _rentalItem.imageUrl =
          "${Config.rootPath}storage/images/rental_item/$_imageFileName";

      var uploadImageResponse = await DataHandler.uploadImage(
          base64Encode(List.from(_imageFile!)), _imageFileName, "rental_item");

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

      if (!_isUpdate) {
        _rentalItem.retired = false;
        _rentalItem.created = DateTime.now();
      }
      _rentalItem.lastModified = DateTime.now();

      apiResponse = _isUpdate
          ? await DataHandler.updateRentalItem(_rentalItem)
          : await DataHandler.createRentalItem(_rentalItem);

      if (apiResponse.error) {
        // TODO: Remove this print for prod.
        print(
            "********** RentalItemPage - createNewRentalItem() - createRentalItem error:\n"
            "${apiResponse.message}");
        Navigator.pop(context);
        showAlertDialog(context, "Okay", "Error",
            "Something has gone wrong. Please try again later.");
        return false;
      }
    } catch (e) {
      // TODO: Remove print.
      print("********** saveRentalItemData exception: $e **********");
    }
    // Remove the loading spinner.
    Navigator.pop(context);

    await showAlertDialog(
        context,
        "Okay",
        "Success",
        _isUpdate
            ? "Successfully updated rental item."
            : "Successfully created rental item.");

    Navigator.pop(context);
    return true;
  }

  Widget _setCoverImage() {
    if (_imageFile != null) {
      return Image.memory(_imageFile!);
    } else if (_rentalItem.imageUrl.isNotEmpty) {
      return Image.network(_rentalItem.imageUrl);
    } else {
      return const Icon(Icons.add_circle_outline);
    }
  }

  //#region Initializers
  _initializeRentalItemDetails() {
    if (widget.selectedRentalItem != null) {
      _isUpdate = true;

      _rentalItem = widget.selectedRentalItem!;
      _nameCtrl.text = _rentalItem.name;
      _rentCostCtrl.text = _rentalItem.rentCost.toString();
      _purchaseCostCtrl.text = _rentalItem.purchaseCost.toString();
      _qualityCtrl.text = _rentalItem.quality;
    } else {
      _rentCostCtrl.text = "0";
      _purchaseCostCtrl.text = "0";
    }
  }

  _initControllerListeners() {
    _nameCtrl.addListener(() {
      _rentalItem.name = _nameCtrl.text;
    });
    _rentCostCtrl.addListener(() {
      if (_rentCostCtrl.text.isNotEmpty) {
        _rentalItem.rentCost = Decimal.parse(_rentCostCtrl.text);
      } else {
        _rentalItem.rentCost = Decimal.parse("0");
      }
    });
    _purchaseCostCtrl.addListener(() {
      if (_purchaseCostCtrl.text.isNotEmpty) {
        _rentalItem.purchaseCost = Decimal.parse(_purchaseCostCtrl.text);
      } else {
        _rentalItem.rentCost = Decimal.parse("0");
      }
    });
    _qualityCtrl.addListener(() {
      _rentalItem.quality = _qualityCtrl.text;
    });
  }

  @override
  void initState() {
    _initializeRentalItemDetails();
    _initControllerListeners();
    super.initState();
  }

  //#endregion

  @override
  void dispose() {
    _nameCtrl.dispose();
    _rentCostCtrl.dispose();
    _purchaseCostCtrl.dispose();
    _qualityCtrl.dispose();

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
      horizontalMargin: Constants.formMarginHorizontal,
      bodyWidget: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            "Item Details",
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
                controller: _nameCtrl,
                name: "*Name...",
                inputFormatters: [LengthLimitingTextInputFormatter(200)],
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return "Please enter name.";
                  }
                  return null;
                },
              ),
              EntryFieldWidget(
                controller: _qualityCtrl,
                name: "Quality...",
                inputFormatters: [LengthLimitingTextInputFormatter(50)],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  EntryFieldWidget(
                    controller: _rentCostCtrl,
                    name: "Rent cost...",
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(
                    height: Constants.formFieldSpacer,
                  ),
                  EntryFieldWidget(
                    controller: _purchaseCostCtrl,
                    name: "Purchase cost...",
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
              _buildActiveStatusSelection(context),
              EntryFieldWidget(
                controller: _notesCtrl,
                name: "Notes...",
                maxWidth: Constants.textAreaWidth,
                keyboardType: TextInputType.multiline,
                minLines: 5,
                maxLines: null,
              ),
            ],
          ),
          const SizedBox(height: 30),
          Text(
            "Item Image",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white, fontSize: Constants.headingFontSize),
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
          ButtonWidget(
            onPressed: () {
              if (Constants.prodMode) {
                saveRentalItemData();
              } else {
                _formKey.currentState!.validate() ? saveRentalItemData() : null;
              }
            },
            text: !_isUpdate ? "Create" : "Update",
            width: Constants.formWidgetWidth,
          ),
        ],
      ),
    );
  }

  _buildActiveStatusSelection(BuildContext context) {
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
            "Active Status",
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
                value: _rentalItem.retired == true ? "retired" : "active",
                items: _activeStatuses.map((value) {
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
                    value.toString().toLowerCase() == "retired"
                        ? (_rentalItem.retired = true)
                        : (_rentalItem.retired = false);
                  });
                }),
          ),
        ],
      ),
    );
  }
}
