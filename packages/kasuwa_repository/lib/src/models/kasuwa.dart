import '../entities/kasuwa_entity.dart';

class Kasuwa {
  dynamic kasuwaId;
  dynamic picture;
  bool isFresh;
  // int pieces;
  dynamic name;
  dynamic description;
  dynamic price;
  dynamic discount;
  dynamic detailsDescription;

  Kasuwa({
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

  KasuwaEntity toEntity() {
    return KasuwaEntity(
      kasuwaId: kasuwaId,
      picture: picture,
      isFresh: isFresh,
      // pieces: pieces,
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
      isFresh: entity.isFresh,
      // pieces: entity.pieces,
      name: entity.name,
      description: entity.description,
      price: entity.price,
      discount: entity.discount,
      detailsDescription: entity.detailsDescription,
    );
  }
}
