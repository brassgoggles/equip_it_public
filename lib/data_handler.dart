import 'dart:convert';

import 'config.dart';
import 'constants.dart';
import 'models/entities/address.dart';
import 'models/api_response.dart';
import 'models/entities/customer.dart';
import 'models/entities/employee.dart';
import 'package:http/http.dart';

import 'package:http/http.dart' as http;

import 'models/entities/rental_item.dart';
import 'models/views/employee_address_view.dart';

class DataHandler {
  static final String _apiPath = "${Config.rootPath}api/";

  //#region Image
  static Future<ApiResponse> uploadImage(
      String imageBytes, String fileName, String imageSubject) async {
    ApiResponse apiResponse = ApiResponse();

    var uri = Uri.parse("${_apiPath}upload_image.php");

    try {
      // TODO: Test on larger image files.
      // TODO: clean up upload_image.php add validation and required key.

      var response = await http.post(uri, body: {
        "api_key": Config.apiKey,
        'image': imageBytes,
        'file_name': fileName,
        'image_subject': imageSubject,
      });

      if (response.statusCode == 200) {
        print(response.body.toString());
        var jsonData = json.decode(response.body);

        if (jsonData["error"]) {
          apiResponse.error = true;
          apiResponse.message = jsonData["message"];
        }
      }
    } catch (e) {
      // TODO: Remove for prod.
      print("********** uploadImage error: " + e.toString() + " **********");
      apiResponse.error = true;
      apiResponse.message = "API response failed.";
    }
    return apiResponse;
  }

  static Future<ApiResponse> deleteImage(String fileName) async {
    ApiResponse apiResponse = ApiResponse();

    var uri = Uri.parse("${_apiPath}delete_image.php");

    try {
      var response = await http.post(uri, body: {
        "api_key": Config.apiKey,
        'file_name': fileName,
      });

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);

        if (jsonData["error"]) {
          apiResponse.error = true;
          apiResponse.message = jsonData["message"];
        }
      }
    } catch (e) {
      // TODO: Remove for prod.
      print("********** deleteImage error: " + e.toString() + " **********");
      apiResponse.error = true;
      apiResponse.message = "API response failed.";
    }
    return apiResponse;
  }

  //#endregion

  //#region RentalItems
  static Future<List<RentalItem>> getAllRentalItems() async {
    Uri uri = Uri.parse("${_apiPath}rental_item/get_rental_items.php");

    try {
      var response = await http.post(uri, body: {"api_key": Config.apiKey});

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);

        return List<RentalItem>.from(jsonData["data"].map((i) {
          return RentalItem.fromJson(i);
        }));
      } else {
        throw Exception();
      }
    } catch (e) {
      // TODO: Remove for prod.
      print(
          "********** getAllRentalItems error: " + e.toString() + " **********");
      return <RentalItem>[];
    }
  }

  static Future<List<RentalItem>> getRentalItemsByName({String searchName = ""}) async {
    Uri uri = Uri.parse("${_apiPath}rental_item/get_rental_items_by_name.php");

    try {
      var response = await http.post(uri, body: {"api_key": Config.apiKey, "search_name": searchName});

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);

        return List<RentalItem>.from(jsonData["data"].map((i) {
          return RentalItem.fromJson(i);
        }));
      } else {
        throw Exception();
      }
    } catch (e) {
      // TODO: Remove for prod.
      print(
          "********** getRentalItemsByName error: " + e.toString() + " **********");
      return <RentalItem>[];
    }
  }

  static Future<ApiResponse> createRentalItem(RentalItem rentalItem) async {
    ApiResponse apiResponse = ApiResponse();

    Uri uri = Uri.parse("${_apiPath}rental_item/create_rental_item.php");

    try {
      var body = <String, dynamic>{"api_key": Config.apiKey};
      body.addAll(rentalItem.toJson());

      var response = await http.post(uri, body: body);

      if (response.statusCode == 200) {
        // TODO: Remove print after testing.
        print(response.body);

        var jsonData = json.decode(response.body);

        if (jsonData["error"]) {
          apiResponse.error = true;
          apiResponse.message = jsonData["message"];
        }
      }
    } catch (e) {
      // TODO: Remove for prod.
      print("********** createRentalItem error: " + e.toString() + " **********");

      apiResponse.error = true;
      apiResponse.message = e.toString();
    }
    return apiResponse;
  }

  static Future<ApiResponse> updateRentalItem(RentalItem rentalItem) async {
    ApiResponse apiResponse = ApiResponse();

    Uri uri = Uri.parse("${_apiPath}rental_item/update_rental_item.php");

    try {
      var body = <String, dynamic>{"api_key": Config.apiKey};
      body.addAll(rentalItem.toJson());
      var response = await http.post(uri, body: body);

      if (response.statusCode == 200) {
        // TODO: Remove print after testing.
        print(response.body);

        var jsonData = json.decode(response.body);

        if (jsonData["error"]) {
          apiResponse.error = true;
          apiResponse.message = jsonData["message"];
        }
      }
    } catch (e) {
      // TODO: Remove for prod.
      print("********** updateRentalItem error: " + e.toString() + " **********");

      apiResponse.error = true;
      apiResponse.message = "Could not send data.";
    }
    return apiResponse;
  }
  //#endregion

  //#region Employee
  static Future<List<Employee>> getAllEmployees() async {
    Uri uri = Uri.parse("${_apiPath}employee/get_employees.php");

    try {
      var response = await http.post(uri, body: {"api_key": Config.apiKey});

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);

        return List<Employee>.from(jsonData["data"].map((i) {
          return Employee.fromJson(i);
        }));
      } else {
        throw Exception();
      }
    } catch (e) {
      // TODO: Remove for prod.
      print(
          "********** getAllEmployees error: " + e.toString() + " **********");
      return <Employee>[];
    }
  }

  static Future<ApiResponse> createEmployee(Employee employee) async {
    ApiResponse apiResponse = ApiResponse();

    Uri uri = Uri.parse("${_apiPath}employee/create_employee.php");

    try {
      var body = <String, dynamic>{"api_key": Config.apiKey};
      body.addAll(employee.toJson());

      var response = await http.post(uri, body: body);

      if (response.statusCode == 200) {
        // TODO: Remove print after testing.
        print(response.body);

        var jsonData = json.decode(response.body);

        if (jsonData["error"]) {
          apiResponse.error = true;
          apiResponse.message = jsonData["message"];
        }
      }
    } catch (e) {
      // TODO: Remove for prod.
      print("********** createEmployee error: " + e.toString() + " **********");

      apiResponse.error = true;
      apiResponse.message = e.toString();
    }
    return apiResponse;
  }

  static Future<ApiResponse> updateEmployee(Employee employee) async {
    ApiResponse apiResponse = ApiResponse();

    Uri uri = Uri.parse("${_apiPath}employee/update_employee.php");

    try {
      var body = <String, dynamic>{"api_key": Config.apiKey};
      body.addAll(employee.toJson());
      var response = await http.post(uri, body: body);

      if (response.statusCode == 200) {
        // TODO: Remove print after testing.
        print(response.body);

        var jsonData = json.decode(response.body);

        if (jsonData["error"]) {
          apiResponse.error = true;
          apiResponse.message = jsonData["message"];
        }
      }
    } catch (e) {
      // TODO: Remove for prod.
      print("********** updateEmployee error: " + e.toString() + " **********");

      apiResponse.error = true;
      apiResponse.message = "Could not send data.";
    }
    return apiResponse;
  }
  //#endregion

  //#region Customer

  static Future<List<Customer>> getCustomers({String searchName = ""}) async {
    Uri uri = Uri.parse("${_apiPath}customer/get_customers.php");

    try {
      var response = await http.post(uri, body: {"api_key": Config.apiKey, "search_name": searchName});

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);

        return List<Customer>.from(jsonData["data"].map((i) {
          return Customer.fromJson(i);
        }));
      } else {
        throw Exception();
      }
    } catch (e) {
      // TODO: Remove for prod.
      print(
          "********** getCustomerByName error: " + e.toString() + " **********");
      return <Customer>[];
    }
  }

  static Future<ApiResponse> createCustomer(Customer customer) async {
    ApiResponse apiResponse = ApiResponse();

    Uri uri = Uri.parse("${_apiPath}customer/create_customer.php");

    try {
      var body = <String, dynamic>{"api_key": Config.apiKey};
      body.addAll(customer.toJson());

      var response = await http.post(uri, body: body);

      if (response.statusCode == 200) {
        // TODO: Remove print after testing.
        print(response.body);

        var jsonData = json.decode(response.body);

        if (jsonData["error"]) {
          apiResponse.error = true;
          apiResponse.message = jsonData["message"];
        }
      }
    } catch (e) {
      // TODO: Remove for prod.
      print("********** createCustomer error: " + e.toString() + " **********");

      apiResponse.error = true;
      apiResponse.message = e.toString();
    }
    return apiResponse;
  }

  static Future<ApiResponse> updateCustomer(Customer customer) async {
    ApiResponse apiResponse = ApiResponse();

    Uri uri = Uri.parse("${_apiPath}customer/update_customer.php");

    try {
      var body = <String, dynamic>{"api_key": Config.apiKey};
      body.addAll(customer.toJson());
      var response = await http.post(uri, body: body);

      if (response.statusCode == 200) {
        // TODO: Remove print after testing.
        print(response.body);

        var jsonData = json.decode(response.body);

        if (jsonData["error"]) {
          apiResponse.error = true;
          apiResponse.message = jsonData["message"];
        }
      }
    } catch (e) {
      // TODO: Remove for prod.
      print("********** updateCustomer error: " + e.toString() + " **********");

      apiResponse.error = true;
      apiResponse.message = "Could not send data.";
    }
    return apiResponse;
  }
  //#endregion

  //#region Address

  static Future<ApiResponse> createAddress(Address address) async {
    ApiResponse apiResponse = ApiResponse();

    Uri uri = Uri.parse("${_apiPath}address/create_address.php");

    try {
      var body = <String, dynamic>{"api_key": Config.apiKey};
      body.addAll(address.toJson());
      var response = await http.post(uri, body: body);

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);

        if (jsonResponse["error"]) {
          apiResponse.error = true;
          apiResponse.message = jsonResponse["message"];
        }

        if (jsonResponse["data"] != null) {
          apiResponse.args["address_id"] =
              jsonResponse["data"][0]["address_id"].toString();
        }
      }
    } catch (e) {
      //TODO: Remove
      print("********** createAddress exception $e **********");

      apiResponse.error = true;
      apiResponse.message = "Could not send data.";
    }
    return apiResponse;
  }

  static Future<ApiResponse> updateAddress(Address address) async {
    ApiResponse apiResponse = ApiResponse();

    Uri uri = Uri.parse("${_apiPath}address/update_address.php");

    try {
      var body = <String, dynamic>{"api_key": Config.apiKey};
      body.addAll(address.toJson());
      var response = await http.post(uri, body: body);

      if (response.statusCode == 200) {
        // TODO: Remove print after testing.
        print(response.body);

        var jsonData = json.decode(response.body);

        if (jsonData["error"]) {
          apiResponse.error = true;
          apiResponse.message = jsonData["message"];
        }
      }
    } catch (e) {
      // TODO: Remove for prod.
      print("********** updateAddress error: " + e.toString() + " **********");

      apiResponse.error = true;
      apiResponse.message = "Could not send data.";
    }
    return apiResponse;
  }

  //#endregion

  static Future<List<EmployeeAddressView>> getEmployeeAddressViews(
      {String searchName = ""}) async {
    Uri uri = Uri.parse("${_apiPath}views/employee_address_view.php");

    try {
      var response = await http.post(uri,
          body: {"api_key": Config.apiKey, "search_name": searchName});

      if (response.statusCode == 200) {
        var viewJson = json.decode(response.body);

        return List<EmployeeAddressView>.from(viewJson["data"].map((i) {
          return EmployeeAddressView.fromJson(i);
        }));
      } else {
        throw Exception();
      }
    } catch (e) {
      // TODO: Remove for prod.
      print("********** getEmployeeAddressViews error: " +
          e.toString() +
          " **********");
      return <EmployeeAddressView>[];
    }
  }
}
