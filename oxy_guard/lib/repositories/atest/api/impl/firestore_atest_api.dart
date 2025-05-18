import 'package:OxyGuard/repositories/atest/api/atest_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../models/models.dart';

class FirestoreAtestApi implements AtestApi {
  FirestoreAtestApi();

  final CollectionReference _atestsRef = FirebaseFirestore.instance.collection("atests");

  @override
  Stream<List<Extinguisher>> getAtests() {
    return _atestsRef.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Extinguisher.fromJson(data);
      }).toList();
    });
  }

  @override
  Stream<List<Extinguisher>> getAtestsByUserId(String userId) {
    return _atestsRef.where('uid', isEqualTo: userId).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Extinguisher.fromJson(data);
      }).toList();
    });
  }

  @override
  Stream<Extinguisher> getAtestById(String id) {
    return _atestsRef.doc(id).snapshots().map((snapshot) {
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        return Extinguisher.fromJson(data);
      } else {
        throw AtestNotFoundException();
      }
    });
    
  }

  @override
  Future<void> saveAtest(Extinguisher atest) {
    return _atestsRef.doc(atest.id).set(atest);
  }

  @override
  Future<void> deleteAtest(String id) {
    return _atestsRef.doc(id).delete();
  }
}