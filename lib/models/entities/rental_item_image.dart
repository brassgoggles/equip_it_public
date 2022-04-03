class RentalItemImage {
  int? id;
  int rentalItemId;
  String url;
  int collectionOrder;
  DateTime created;

  RentalItemImage(
    this.id,
    this.rentalItemId,
    this.url,
    this.collectionOrder,
    this.created,
  );
}
