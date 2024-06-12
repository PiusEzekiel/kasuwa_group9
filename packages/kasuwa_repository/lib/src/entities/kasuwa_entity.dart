class KasuwaEntity {
  dynamic kasuwaId;
  dynamic picture;
  bool isFresh;
  // int pieces;
  dynamic name;
  dynamic description;

  dynamic price;
  dynamic discount;
  dynamic detailsDescription;

  KasuwaEntity({
    required this.kasuwaId,
    required this.picture,
    required this.isFresh,
    // required this.pieces,
    required this.name,
    required this.description,
    required this.price,
    required this.discount,
    required this.detailsDescription,
  });

  Map<String, Object?> toDocument() {
    return {
      'kasuwaId': kasuwaId,
      'picture': picture,
      'isFresh': isFresh,
      // 'pieces': pieces,
      'name': name,
      'description': description,
      'price': price,
      'discount': discount,
      'detailsDescription': detailsDescription,
    };
  }

  static KasuwaEntity fromDocument(Map<String, dynamic> doc) {
    return KasuwaEntity(
      kasuwaId: doc['kasuwaId'],
      picture: doc['picture'],
      isFresh: doc['isFresh'],
      // pieces: doc['pieces'],
      name: doc['name'],
      description: doc['description'],
      price: doc['price'],
      discount: doc['discount'],
      detailsDescription: doc['detailsDescription'],
    );
  }
}
