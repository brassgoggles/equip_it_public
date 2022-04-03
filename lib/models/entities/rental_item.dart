import 'package:decimal/decimal.dart';

class RentalItem {
  int? id;
  String name = "";
  Decimal rentCost = Decimal.parse("0.0");
  Decimal purchaseCost = Decimal.parse("0.0");
  String quality = "";
  String notes = "";
  bool retired = false;
  String imageUrl = "";
  DateTime? created;
  DateTime lastModified;

  RentalItem(this.name, this.lastModified) {
    created = DateTime.now();
  }

  RentalItem.update(this.name, this.retired, this.lastModified);

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "id": id.toString(),
      "name": name,
      "rent_cost": rentCost.toString(),
      "purchase_cost": purchaseCost.toString(),
      "quality": quality,
      "notes": notes,
      "retired": retired.toString(),
      "image_url": imageUrl,
      "created": created.toString(),
      "last_modified": lastModified.toString(),
    };
  }

  RentalItem.fromJson(Map<String, dynamic> json)
      : id = int.parse(json['id']),
        name = json["name"],
        rentCost = Decimal.parse(json["rent_cost"]),
        purchaseCost = Decimal.parse(json["purchase_cost"]),
        quality = json["quality"],
        notes = json["notes"],
        retired = json["retired"].toLowerCase() == "0" ? false : true,
        imageUrl = json["image_url"],
        created = DateTime.parse(json["created"]),
        lastModified = DateTime.parse(json["last_modified"]);

  @override
  String toString() {
    return "RentalItem\n"
        "id: $id\n"
        "name: $name\n"
        "rentCost: $rentCost\n"
        "purchaseCost: $purchaseCost\n"
        "quality: $quality\n"
        "notes: $notes\n"
        "retired: $retired\n"
        "imageUrl: $imageUrl\n"
        "created: $created\n"
        "lastModified: $lastModified\n";
  }
}
