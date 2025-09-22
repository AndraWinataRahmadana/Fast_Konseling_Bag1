import 'package:cloud_firestore/cloud_firestore.dart';

class CounselingSession {
  final String id;
  final String userId;
  final String psychologistId;
  final Timestamp schedule;
  final String status;

  CounselingSession({
    required this.id,
    required this.userId,
    required this.psychologistId,
    required this.schedule,
    required this.status,
  });
}