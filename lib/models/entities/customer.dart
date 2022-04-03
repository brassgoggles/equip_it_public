class Customer {
  int? id;
  String firstName;
  String lastName;
  String organisation = "";
  String phone;
  String email = "";
  DateTime? created;
  DateTime lastModified;

  Customer(
    this.firstName,
    this.lastName,
    this.phone,
    this.lastModified,
  ) {
    created = DateTime.now();
  }

  Customer.update(this.id, this.firstName, this.lastName, this.organisation,
      this.phone, this.email, this.created, this.lastModified);

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "id": id.toString(),
      "first_name": firstName,
      "last_name": lastName,
      "organisation": organisation,
      "phone": phone,
      "email": email,
      "created": created.toString(),
      "last_modified": lastModified.toString(),
    };
  }

  Customer.fromJson(Map<String, dynamic> json)
      : id = int.parse(
            json.containsKey('customer_id') ? json['customer_id'] : json['id']),
        firstName = json["first_name"],
        lastName = json["last_name"],
        organisation = json["organisation"],
        phone = json["phone"],
        email = json["email"],
        created = DateTime.parse(json["created"]),
        lastModified = DateTime.parse(json["last_modified"]);

  @override
  String toString() {
    return "Customer\n"
        "id: $id\n"
        "firstName: $firstName\n"
        "lastName: $lastName\n"
        "organisation: $organisation\n"
        "phone: $phone\n"
        "email: $email\n"
        "created: $created\n"
        "lastModified: $lastModified\n";
  }
}
