import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path_provider/path_provider.dart';
import '../models/absence_model.dart';

class AbsenceService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Save selfie to local storage and return full path
  Future<String> _saveImageLocally(File imageFile, String absenceId) async {
    try {
      // Get app's document directory
      final Directory appDir = await getApplicationDocumentsDirectory();

      // Create selfies folder if it doesn't exist
      final Directory selfiesDir = Directory('${appDir.path}/selfies');
      if (!await selfiesDir.exists()) {
        await selfiesDir.create(recursive: true);
      }

      // Create new file path with timestamp and absenceId
      final String fileName =
          '${absenceId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final String newPath = '${selfiesDir.path}/$fileName';

      // Copy image to new location
      final File newImage = await imageFile.copy(newPath);

      print('Image saved locally at: ${newImage.path}');
      return newImage.path;
    } catch (e) {
      print('Error saving image locally: $e');
      // If local save fails, return original path
      return imageFile.path;
    }
  }

  // Save absence with local image path - Used by AbsenceController
  Future<String?> saveAbsence({
    required File selfieImage,
    required String status,
    String? notes,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      print('Starting absence save for user: ${user.uid}');

      // Check if image file exists
      if (!await selfieImage.exists()) {
        throw Exception('Image file does not exist');
      }

      // Generate unique ID
      final docId = _firestore.collection('absences').doc().id;
      print('Generated document ID: $docId');

      // Save image locally and get full path
      final String localImagePath = await _saveImageLocally(selfieImage, docId);

      // Create absence model with local image path
      final absence = AbsenceModel(
        id: docId,
        userId: user.uid,
        userEmail: user.email ?? 'Unknown', // Store email in userEmail field
        timestamp: DateTime.now(),
        selfieUrl: localImagePath, // Store full local path
        status: status,
        notes: notes,
      );

      // Save to Firestore
      await _firestore.collection('absences').doc(docId).set(absence.toMap());

      print(
        'Absence saved successfully to Firestore with local image path: $localImagePath',
      );
      return docId;
    } catch (e) {
      print('Error saving absence: $e');
      return null;
    }
  }

  // Get user's absences - Used by HistoryController
  Stream<List<AbsenceModel>> getUserAbsences() {
    final user = _auth.currentUser;
    if (user == null) return Stream.value([]);

    return _firestore
        .collection('absences')
        .where('userId', isEqualTo: user.uid)
        // Temporarily remove orderBy until index is created
        // .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
          // Sort in code instead of Firestore
          final docs = snapshot.docs;
          docs.sort((a, b) {
            final aTime = (a.data()['timestamp'] as Timestamp).toDate();
            final bTime = (b.data()['timestamp'] as Timestamp).toDate();
            return bTime.compareTo(aTime); // Descending order
          });
          return docs.map((doc) => AbsenceModel.fromMap(doc.data())).toList();
        });
  }

  // Check if user already marked attendance today - Used by AbsenceController
  Future<bool> hasMarkedAttendanceToday() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        print('No user logged in');
        return false;
      }

      print('Checking attendance for user: ${user.email}');

      final today = DateTime.now();
      final startOfDay = DateTime(today.year, today.month, today.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      print('Checking from: $startOfDay to: $endOfDay');

      final snapshot = await _firestore
          .collection('absences')
          .where('userId', isEqualTo: user.uid)
          .get(); // Remove date filter first to check if any data exists

      print('Total absences found for user: ${snapshot.docs.length}');

      if (snapshot.docs.isEmpty) {
        print('No absences found for this user yet');
        return false;
      }

      // Check for today's attendance
      final todaySnapshot = await _firestore
          .collection('absences')
          .where('userId', isEqualTo: user.uid)
          .where('timestamp', isGreaterThanOrEqualTo: startOfDay)
          .where('timestamp', isLessThan: endOfDay)
          .get();

      print('Today attendance records: ${todaySnapshot.docs.length}');

      return todaySnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking today attendance: $e');
      return false;
    }
  }

  // Get attendance statistics - Optional method for future use
  Future<Map<String, int>> getAttendanceStats() async {
    final user = _auth.currentUser;
    if (user == null) return {'present': 0, 'late': 0, 'very_late': 0};

    final snapshot = await _firestore
        .collection('absences')
        .where('userId', isEqualTo: user.uid)
        .get();

    final stats = {'present': 0, 'late': 0, 'very_late': 0};

    for (var doc in snapshot.docs) {
      final status = doc.data()['status'] as String;
      if (stats.containsKey(status)) {
        stats[status] = stats[status]! + 1;
      }
    }

    return stats;
  }
}
