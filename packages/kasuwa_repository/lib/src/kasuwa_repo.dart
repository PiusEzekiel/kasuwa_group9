import 'models/models.dart';

abstract class KasuwaRepo {
  Future<List<Kasuwa>> getKasuwas();
}
