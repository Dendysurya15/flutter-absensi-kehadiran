import 'package:cloud_firestore/cloud_firestore.dart';

class AbsenceModel {
  final String id;
  final String userId;
  final String userEmail;
  final DateTime timestamp;
  final String? selfieUrl; // Foto selfie path
  final String status; // 'present', 'late', 'very_late'
  final String? notes;
  final double? latitude; // Koordinat lokasi
  final double? longitude; // Koordinat lokasi
  final String? locationAddress; // Alamat lokasi

  AbsenceModel({
    required this.id,
    required this.userId,
    required this.userEmail,
    required this.timestamp,
    this.selfieUrl,
    required this.status,
    this.notes,
    this.latitude,
    this.longitude,
    this.locationAddress,
  });

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'userEmail': userEmail,
      'timestamp': timestamp,
      'selfieUrl': selfieUrl,
      'status': status,
      'notes': notes,
      'latitude': latitude,
      'longitude': longitude,
      'locationAddress': locationAddress,
    };
  }

  // Create from Firestore Map
  factory AbsenceModel.fromMap(Map<String, dynamic> map) {
    return AbsenceModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      userEmail: map['userEmail'] ?? '',
      timestamp: (map['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      selfieUrl: map['selfieUrl'],
      status: map['status'] ?? '',
      notes: map['notes'],
      latitude: map['latitude']?.toDouble(),
      longitude: map['longitude']?.toDouble(),
      locationAddress: map['locationAddress'],
    );
  }
}
