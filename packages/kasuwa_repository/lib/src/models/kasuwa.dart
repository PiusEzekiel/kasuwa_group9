import '../entities/kasuwa_entity.dart';

class Kasuwa {
  String kasuwaId;
  String picture;
  bool isVeg;
  int spicy;
  String name;
  String description;
  double price;
  double discount;
  String detailsDescription;

  Kasuwa({
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

  KasuwaEntity toEntity() {
    return KasuwaEntity(
      kasuwaId: kasuwaId,
      picture: picture,
      isVeg: isVeg,
      spicy: spicy,
      name: name,
      description: description,
      price: price,
      discount: discount,
      detailsDescription: detailsDescription,
    );
  }

  static Kasuwa fromEntity(KasuwaEntity entity) {
    return Kasuwa(
      kasuwaId: entity.kasuwaId,
      picture: entity.picture,
      isVeg: entity.isVeg,
      spicy: entity.spicy,
      name: entity.name,
      description: entity.description,
      price: entity.price,
      discount: entity.discount,
      detailsDescription: entity.detailsDescription,
    );
  }
}
