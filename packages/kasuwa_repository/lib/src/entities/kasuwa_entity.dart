class KasuwaEntity {
  String kasuwaId;
  String picture;
  bool isVeg;
  int spicy;
  String name;
  String description;
  double price;
  double discount;
  String detailsDescription;

  KasuwaEntity({
    required this.kasuwaId,
    required this.picture,
    required this.isVeg,
    required this.spicy,
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
      'isVeg': isVeg,
      'spicy': spicy,
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
      isVeg: doc['isVeg'],
      spicy: doc['spicy'],
      name: doc['name'],
      description: doc['description'],
      price: doc['price'],
      discount: doc['discount'],
      detailsDescription: doc['detailsDescription'],
    );
  }
}
