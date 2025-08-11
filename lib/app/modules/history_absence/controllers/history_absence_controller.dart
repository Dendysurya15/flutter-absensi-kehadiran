import 'dart:ui';

import 'package:absensi_kehadiran/models/absence_model.dart';
import 'package:absensi_kehadiran/services/absence_service.dart';
import 'package:get/get.dart';

class HistoryController extends GetxController {
  final AbsenceService _absenceService = AbsenceService();

  // Observable variables
  var absences = <AbsenceModel>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadAbsences();
  }

  // Load user absences
  void loadAbsences() {
    isLoading.value = true;
    _absenceService.getUserAbsences().listen((absenceList) {
      absences.value = absenceList;
      isLoading.value = false;
    });
  }

  // Refresh absences
  void refreshAbsences() {
    loadAbsences();
  }

  // Get status color
  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'present':
        return const Color(0xFF4CAF50); // Green
      case 'late':
        return const Color(0xFFFF9800); // Orange
      case 'very_late':
        return const Color(0xFFF44336); // Red
      default:
        return const Color(0xFF9E9E9E); // Grey
    }
  }

  // Format date
  String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  // Format time
  String formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
