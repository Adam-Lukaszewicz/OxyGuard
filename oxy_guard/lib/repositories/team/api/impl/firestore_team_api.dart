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
  Stream<List<Team>> getTeamsBySquadId(String squadId) {
    return _teamsRef.where('squadId', isEqualTo: squadId).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Team.fromJson(data);
      }).toList();
    });
  }

  @override
  Stream<Team> getTeamById(String id) {
    return _teamsRef.doc(id).snapshots().map((snapshot) {
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        return Team.fromJson(data);
      } else {
        throw TeamNotFoundException();
      }
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