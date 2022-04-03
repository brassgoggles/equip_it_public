class Address {
  int? id;
  String? unitNumber;
  String streetNumber = "";
  String streetName = "";
  String suburb = "";
  String state = "";
  String country = "";
  String postCode = "";
  String? additionalInformation;

  Address();

  Address.update(
    this.id,
    this.unitNumber,
    this.streetNumber,
    this.streetName,
    this.suburb,
    this.state,
    this.country,
    this.postCode,
    this.additionalInformation,
  );

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "id": id.toString(),
      "unit_number": unitNumber.toString(),
      "street_number": streetNumber,
      "street_name": streetName,
      "suburb": suburb,
      "state": state,
      "country": country,
      "post_code": postCode,
      "additional_information": additionalInformation.toString(),
    };
  }

  Address.fromJson(Map<String, dynamic> json)
      : id = int.parse(
            json.containsKey('address_id') ? json['address_id'] : json['id']),
        unitNumber = json["unit_number"],
        streetNumber = json["street_number"],
        streetName = json["street_name"],
        suburb = json["suburb"],
        state = json["state"],
        country = json["country"],
        postCode = json["post_code"],
        additionalInformation = json["additional_information"];

  @override
  String toString() {
    return "Address\n"
        "id: $id\n"
        "unitNumber: $unitNumber\n"
        "streetNumber: $streetNumber\n"
        "streetName: $streetName\n"
        "suburb: $suburb\n"
        "state: $state\n"
        "country: $country\n"
        "postCode: $postCode\n"
        "additionalInformation: $additionalInformation\n";
  }
}
