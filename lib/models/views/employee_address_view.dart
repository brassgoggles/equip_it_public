import '../entities/address.dart';
import '../entities/employee.dart';

class EmployeeAddressView {
  Employee employee;
  Address address;

  EmployeeAddressView(this.employee, this.address);

  EmployeeAddressView.fromJson(Map<String, dynamic> json)
      : employee = Employee.fromJson(json),
        address = Address.fromJson(json);
}
