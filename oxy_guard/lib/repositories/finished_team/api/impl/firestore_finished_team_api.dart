import 'package:OxyGuard/models/models.dart';
import 'package:OxyGuard/repositories/finished_team/api/finished_team_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreFinishedTeamApi implements FinishedTeamApi {
  FirestoreFinishedTeamApi();

  final CollectionReference _finishedTeamRef = FirebaseFirestore.instance.collection("finishedTeams");

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
  Stream<List<FinishedTeam>> getFinishedTeamsByArchivedSquadId(String archivedSquadId) {
    return _finishedTeamRef.where('archivedSquadId', isEqualTo: archivedSquadId).snapshots().map((snapshot){
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
  Stream<List<FinishedTeam>> getFinishedTeamsByUserId(String userId) {
    return _finishedTeamRef.where('userId', isEqualTo: userId).snapshots().map((snapshot){
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