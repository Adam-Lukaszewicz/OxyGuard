import 'package:OxyGuard/repositories/personnel/api/personnel_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../models/models.dart';

class FirestorePersonnelApi implements PersonnelApi {
  FirestorePersonnelApi();

  final CollectionReference _personnelRef = FirebaseFirestore.instance.collection("personnel");

  @override
  Stream<List<Personnel>> getPersonnel() {
    return _personnelRef.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Personnel.fromJson(data);
      }).toList();
    });
  }

  @override
  Stream<List<Personnel>> getPersonnelByUserId(String userId) {
    return _personnelRef.where('uid', isEqualTo: userId).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Personnel.fromJson(data);
      }).toList();
    });
  }

  @override
  Stream<Personnel> getPersonnelById(String id) {
    return _personnelRef.doc(id).snapshots().map((snapshot) {
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        return Personnel.fromJson(data);
      } else {
        throw PersonnelNotFoundException();
      }
    });
  }

  @override
  Future<void> savePersonnel(Personnel personnel) {
    return _personnelRef.doc(personnel.id).set(personnel);
  }

  @override
  Future<void> deletePersonnel(String id) {
    return _personnelRef.doc(id).delete();
  }
}