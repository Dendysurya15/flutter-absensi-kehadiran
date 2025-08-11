import 'dart:io';
import 'package:absensi_kehadiran/services/absence_service.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AbsenceController extends GetxController {
  final AbsenceService _absenceService = AbsenceService();
  final ImagePicker _picker = ImagePicker();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Observable variables
  var isLoading = false.obs;
  var hasMarkedToday = false.obs;
  var currentUser = Rx<User?>(null);

  @override
  void onInit() {
    super.onInit();
    getCurrentUser();
    checkTodayAttendance();
  }

  // Get current user data
  void getCurrentUser() {
    currentUser.value = _auth.currentUser;

    // Listen to auth state changes
    _auth.authStateChanges().listen((User? user) {
      currentUser.value = user;
      if (user == null) {
        // User logged out, redirect to login
        Get.offAllNamed('/login');
      }
    });
  }

  // Get user display name (use email)
  String get userName {
    final user = currentUser.value;
    return user?.email ?? 'User';
  }

  // Get user email
  String get userEmail {
    return currentUser.value?.email ?? 'No email';
  }

  // Get user ID
  String get userId {
    return currentUser.value?.uid ?? '';
  }

  // Get user photo URL
  String? get userPhotoUrl {
    return currentUser.value?.photoURL;
  }

  // Check if user already marked attendance today
  Future<void> checkTodayAttendance() async {
    print('Checking if user marked attendance today...');
    hasMarkedToday.value = await _absenceService.hasMarkedAttendanceToday();
    print('Has marked today: ${hasMarkedToday.value}');
  }

  // Take selfie and mark attendance
  Future<void> markAttendance() async {
    if (hasMarkedToday.value) {
      Get.snackbar(
        'Already Marked',
        'You have already marked attendance today',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Check if user is logged in
    if (currentUser.value == null) {
      Get.snackbar(
        'Error',
        'Please login first',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;

      // Take selfie
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front,
        imageQuality: 80,
      );

      if (photo != null) {
        final File imageFile = File(photo.path);

        // Determine status based on time (you can customize this logic)
        final now = DateTime.now();
        final String status = _getAttendanceStatus(now);

        // Save attendance
        final result = await _absenceService.saveAbsence(
          selfieImage: imageFile,
          status: status,
          notes: 'Marked via selfie at ${now.toString()} by $userName',
        );

        if (result != null) {
          Get.snackbar(
            'Success',
            'Attendance marked successfully!',
            snackPosition: SnackPosition.BOTTOM,
          );
          hasMarkedToday.value = true;
        } else {
          Get.snackbar(
            'Error',
            'Failed to mark attendance. Please try again.',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Determine attendance status based on time
  String _getAttendanceStatus(DateTime time) {
    final hour = time.hour;

    // Customize these times based on your requirements
    if (hour <= 8) {
      return 'present';
    } else if (hour <= 9) {
      return 'late';
    } else {
      return 'very_late';
    }
  }

  // Refresh user data
  void refreshUserData() {
    getCurrentUser();
    checkTodayAttendance();
  }
}
