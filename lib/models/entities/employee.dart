class Employee {
  int? id;
  String? password;
  String firstName = "";
  String lastName = "";
  String gender = "";
  String phone = "";
  String email = "";
  DateTime? birthDate;
  String profileImageUrl = "";
  String position = "";
  String employmentStatus = "";
  String userLevel = "";
  DateTime? created;
  DateTime lastModified;
  int? addressId;

  // For creating a new user.
  Employee(this.lastModified) {
    position = "staff";
    employmentStatus = "employed";
    userLevel = "user";
    created = DateTime.now();
  }

  Employee.update(
      this.id,
      this.firstName,
      this.lastName,
      this.gender,
      this.phone,
      this.email,
      this.birthDate,
      this.profileImageUrl,
      this.position,
      this.employmentStatus,
      this.userLevel,
      this.created,
      this.lastModified,
      this.addressId);

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "id": id.toString(),
      "first_name": firstName,
      "last_name": lastName,
      "gender": gender,
      "phone": phone,
      "email": email,
      "birth_date": birthDate.toString(),
      "profile_image_url": profileImageUrl,
      "position": position,
      "employment_status": employmentStatus,
      "user_level": userLevel,
      "created": created.toString(),
      "last_modified": lastModified.toString(),
      "address_id": addressId.toString(),
    };
  }

  Employee.fromJson(Map<String, dynamic> json)
      : id = int.parse(
            json.containsKey('employee_id') ? json['employee_id'] : json['id']),
        firstName = json["first_name"],
        lastName = json["last_name"],
        gender = json["gender"],
        phone = json["phone"],
        email = json["email"],
        birthDate = DateTime.parse(json["birth_date"]),
        profileImageUrl = json["profile_image_url"],
        position = json["position"],
        employmentStatus = json["employment_status"],
        userLevel = json["user_level"],
        created = DateTime.parse(json["created"]),
        lastModified = DateTime.parse(json["last_modified"]),
        addressId = int.parse(json["address_id"]);

  @override
  String toString() {
    return "Employee\n"
        "id: $id\n"
        "firstName: $firstName\n"
        "lastName: $lastName\n"
        "gender: $gender\n"
        "phone: $phone\n"
        "email: $email\n"
        "birthDate: $birthDate\n"
        "profileImageUrl: $profileImageUrl\n"
        "position: $position\n"
        "employmentStatus: $employmentStatus\n"
        "userLevel: $userLevel\n"
        "created: $created\n"
        "lastModified: $lastModified\n"
        "addressId: $addressId\n";
  }
}
