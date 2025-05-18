import 'package:OxyGuard/models/models.dart';
import 'package:OxyGuard/repositories/archive/api/archive_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreArchiveApi implements ArchiveApi {
  FirestoreArchiveApi();

  final CollectionReference _archiveRef = FirebaseFirestore.instance.collection("archive");
  final CollectionReference _finishedSquadRef = FirebaseFirestore.instance.collection("finishedSquads");
  final CollectionReference _finishedTeamRef = FirebaseFirestore.instance.collection("finishedTeams");

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
  Stream<ArchivedAction> getArchiveById(String id) {
    return _archiveRef.doc(id).snapshots().map((snapshot) {
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        return ArchivedAction.fromJson(data);
      } else {
        throw ArchiveNotFoundException();
      }
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

  @override
  Stream<List<FinishedSquad>> getFinishedSquads() {
    return _finishedSquadRef.snapshots().map((snapshot){
      return snapshot.docs.map((doc){
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return FinishedSquad.fromJson(data);
      }).toList();
    });
  }

  @override
  Stream<FinishedSquad> getFinishedSquadById(String id) {
    return _finishedSquadRef.doc(id).snapshots().map((snapshot) {
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        return FinishedSquad.fromJson(data);
      } else {
        throw FinishedSquadNotFoundException();
      }
    });
  }

  @override
  Stream<List<FinishedSquad>> getFinishedSquadsByArchivedActionId(String archivedActionId) {
    return _finishedSquadRef.where('archivedActionId', isEqualTo: archivedActionId).snapshots().map((snapshot){
      return snapshot.docs.map((doc){
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return FinishedSquad.fromJson(data);
      }).toList();
    });
  }

  @override
  Future<void> saveFinishedSquad(FinishedSquad finishedSquad) {
    return _finishedSquadRef.doc(finishedSquad.id).set(finishedSquad);
  }

  @override
  Future<void> deleteFinishedSquad(String id) {
    return _finishedSquadRef.doc(id).delete();
  }

  @override
  Stream<List<FinishedTeam>> getFinishedTeams() {
    return _finishedTeamRef.snapshots().map((snapshot){
      return snapshot.docs.map((doc){
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return FinishedTeam.fromJson(data);
      }).toList();
    });
  }

  @override
  Stream<FinishedTeam> getFinishedTeamById(String id) {
    return _finishedTeamRef.doc(id).snapshots().map((snapshot) {
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        return FinishedTeam.fromJson(data);
      } else {
        throw FinishedTeamNotFoundException();
      }
    });
  }

  @override
  Stream<List<FinishedTeam>> getFinishedTeamsByArchivedSquadId(String archivedSquadId) {
    return _finishedTeamRef.where('archivedSquadId', isEqualTo: archivedSquadId).snapshots().map((snapshot){
      return snapshot.docs.map((doc){
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return FinishedTeam.fromJson(data);
      }).toList();
    });
  }

  @override
  Future<void> saveFinishedTeam(FinishedTeam finishedTeam) {
    return _finishedTeamRef.doc(finishedTeam.id).set(finishedTeam);
  }

  @override
  Future<void> deleteFinishedTeam(String id) {
    return _finishedTeamRef.doc(id).delete();
  }
}