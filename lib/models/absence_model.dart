import 'package:cloud_firestore/cloud_firestore.dart';

class AbsenceModel {
  final String id;
  final String userId;
  final String userEmail; // Changed from userName to userEmail
  final DateTime timestamp;
  final String? selfieUrl; // Optional - stores local file path
  final String status; // 'present', 'late', 'very_late'
  final String? notes;

  AbsenceModel({
    required this.id,
    required this.userId,
    required this.userEmail, // Changed parameter name
    required this.timestamp,
    this.selfieUrl, // Optional now
    required this.status,
    this.notes,
  });

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'userEmail': userEmail, // Store as userEmail in Firestore
      'timestamp': timestamp,
      'selfieUrl': selfieUrl, // Can be null
      'status': status,
      'notes': notes,
    };
  }

  // Create from Firestore Map
  factory AbsenceModel.fromMap(Map<String, dynamic> map) {
    return AbsenceModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      userEmail: map['userEmail'] ?? '', // Read as userEmail from Firestore
      timestamp: (map['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      selfieUrl: map['selfieUrl'], // Can be null
      status: map['status'] ?? '',
      notes: map['notes'],
    );
  }
}
