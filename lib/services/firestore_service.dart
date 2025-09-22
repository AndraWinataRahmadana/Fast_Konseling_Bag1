import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_konseling/models/psychologist.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Psychologist>> getPsychologists() {
    return _db.collection('psychologists').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Psychologist.fromMap(doc.id, doc.data());
      }).toList();
    });
  }
}