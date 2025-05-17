import 'package:OxyGuard/repositories/team/api/team_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../models/models.dart';

class FirestoreTeamApi implements TeamApi {
  FirestoreTeamApi();

  final CollectionReference _teamsRef = FirebaseFirestore.instance.collection("teams");

  @override
  Stream<List<Team>> getTeams() {
    return _teamsRef.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Team.fromJson(data);
      }).toList();
    });
  }

  @override
  Stream<List<Team>> getTeamsByUserId(String userId) {
    return _teamsRef.where('uid', isEqualTo: userId).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Team.fromJson(data);
      }).toList();
    });
  }

  @override
  Future<void> saveTeam(Team team) {
    return _teamsRef.doc(team.id).set(team);
  }

  @override
  Future<void> deleteTeam(String id) {
    return _teamsRef.doc(id).delete();
  }
}