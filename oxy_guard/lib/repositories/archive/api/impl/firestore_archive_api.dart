import 'package:OxyGuard/models/models.dart';
import 'package:OxyGuard/repositories/archive/api/archive_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreArchiveApi implements ArchiveApi {
  FirestoreArchiveApi();

  final CollectionReference _archiveRef = FirebaseFirestore.instance.collection("archive");

  @override
  Stream<List<ArchivedAction>> getArchive() {
    return _archiveRef.snapshots().map((snapshot){
      return snapshot.docs.map((doc){
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return ArchivedAction.fromJson(data);
      }).toList();
    });
  }

  @override
  Stream<List<ArchivedAction>> getArchiveByUserId(String userId) {
    return _archiveRef.where('uid', isEqualTo: userId).snapshots().map((snapshot){
      return snapshot.docs.map((doc){
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return ArchivedAction.fromJson(data);
      }).toList();
    });
  }

  @override
  Future<void> saveArchive(ArchivedAction archivedAction) {
    return _archiveRef.doc(archivedAction.id).set(archivedAction);
  }

  @override
  Future<void> deleteArchive(String id) {
    return _archiveRef.doc(id).delete();
  }
}