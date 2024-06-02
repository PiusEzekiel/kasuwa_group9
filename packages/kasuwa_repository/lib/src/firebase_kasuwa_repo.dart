import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kasuwa_repository/kasuwa_repository.dart';

class FirebaseKasuwaRepo implements KasuwaRepo {
  final kasuwaCollection = FirebaseFirestore.instance.collection('kasuwas');

  @override
  Future<List<Kasuwa>> getKasuwas() async {
    try {
      return await kasuwaCollection.get().then((value) => value.docs
          .map((e) => Kasuwa.fromEntity(KasuwaEntity.fromDocument(e.data())))
          .toList());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
