import 'dart:io';
import 'dart:async';
import 'dart:math' as math;
import 'package:absensi_kehadiran/services/absence_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class AbsenceController extends GetxController {
  final AbsenceService _absenceService = AbsenceService();
  final ImagePicker _picker = ImagePicker();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Observable variables
  var isLoading = false.obs;
  var hasMarkedToday = false.obs;
  var currentUser = Rx<User?>(null);
  var currentLocation = 'Mengambil lokasi...'.obs;
  var coordinates = ''.obs;
  var latitude = 0.0.obs;
  var longitude = 0.0.obs;
  var currentTime = DateTime.now().obs; // Real-time clock
  var isLocationLoading = true.obs;
  var isLocationValid = false.obs; // Track if location is valid
  var distanceFromOffice = 0.0.obs; // Distance in meters

  Timer? _timer;
  Timer? _locationTimer;

  // Office coordinates
  static const double officeLatitude = -2.622724;
  static const double officeLongitude = 111.674346;

  @override
  void onInit() {
    super.onInit();
    getCurrentUser();
    getCurrentLocation();
    checkTodayAttendance();
    startRealTimeClock();
    startLocationUpdates();
  }

  @override
  void onClose() {
    _timer?.cancel();
    _locationTimer?.cancel();
    super.onClose();
  }

  // Start real-time clock
  void startRealTimeClock() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      currentTime.value = DateTime.now();
    });
  }

  // Start location updates every 5 seconds
  void startLocationUpdates() {
    _locationTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      getCurrentLocation();
    });
  }

  // Get current user data
  void getCurrentUser() {
    currentUser.value = _auth.currentUser;

    // Listen to auth state changes
    _auth.authStateChanges().listen((User? user) {
      currentUser.value = user;
      if (user == null) {
        Get.offAllNamed('/login');
      }
    });
  }

  // Get current location using real GPS
  Future<void> getCurrentLocation() async {
    try {
      isLocationLoading.value = true;

      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        currentLocation.value = 'Layanan lokasi tidak aktif';
        isLocationLoading.value = false;
        return;
      }

      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          currentLocation.value = 'Izin lokasi ditolak';
          isLocationLoading.value = false;
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        currentLocation.value = 'Izin lokasi ditolak permanen';
        isLocationLoading.value = false;
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      latitude.value = position.latitude;
      longitude.value = position.longitude;
      coordinates.value =
          '${latitude.value.toStringAsFixed(6)}, ${longitude.value.toStringAsFixed(6)}';

      // Calculate distance and validate location
      _calculateDistanceAndValidate();

      print('GPS Location updated: ${coordinates.value}');

      // Get address from coordinates
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          latitude.value,
          longitude.value,
        );

        if (placemarks.isNotEmpty) {
          Placemark place = placemarks[0];
          currentLocation.value =
              '${place.street ?? ''}, ${place.locality ?? ''}, ${place.administrativeArea ?? ''}';
        } else {
          currentLocation.value = 'Alamat tidak ditemukan';
        }
      } catch (e) {
        print('Error getting address: $e');
        currentLocation.value = 'Koordinat: ${coordinates.value}';
      }

      isLocationLoading.value = false;
    } catch (e) {
      print('Error getting location: $e');
      currentLocation.value = 'Error mengambil lokasi: $e';
      isLocationLoading.value = false;
    }
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

  // Check if user already marked attendance today
  Future<void> checkTodayAttendance() async {
    print('Checking if user marked attendance today...');
    hasMarkedToday.value = await _absenceService.hasMarkedAttendanceToday();
    print('Has marked today: ${hasMarkedToday.value}');
  }

  // Calculate distance from office and validate location
  void _calculateDistanceAndValidate() {
    if (latitude.value == 0.0 && longitude.value == 0.0) {
      isLocationValid.value = false;
      distanceFromOffice.value = 0.0;
      return;
    }

    // Calculate distance using Haversine formula
    const double earthRadiusKm = 6371;

    final double dLat = _degreesToRadians(latitude.value - officeLatitude);
    final double dLon = _degreesToRadians(longitude.value - officeLongitude);

    final double a =
        math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_degreesToRadians(officeLatitude)) *
            math.cos(_degreesToRadians(latitude.value)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);

    final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    final double distanceKm = earthRadiusKm * c;
    final double distanceMeters = distanceKm * 1000;

    distanceFromOffice.value = distanceMeters;
    isLocationValid.value = distanceMeters <= 100; // 100 meter radius

    print('Distance from office: ${distanceMeters.toStringAsFixed(2)} meters');
    print('Location valid: ${isLocationValid.value}');
  }

  // Convert degrees to radians
  double _degreesToRadians(double degrees) {
    return degrees * (math.pi / 180);
  }

  // Take selfie and mark attendance
  Future<void> markAttendance() async {
    if (hasMarkedToday.value) {
      Get.snackbar(
        'Sudah Absen',
        'Anda sudah melakukan absensi hari ini',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Check if user is logged in
    if (currentUser.value == null) {
      Get.snackbar(
        'Error',
        'Silakan login terlebih dahulu',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Check location validity
    if (!isLocationValid.value) {
      Get.snackbar(
        'Lokasi Tidak Valid',
        'Anda harus berada dalam radius 100m dari kantor. Jarak saat ini: ${distanceFromOffice.value.toStringAsFixed(0)}m',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
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

        // Determine status based on time
        final now = DateTime.now();
        final String status = _getAttendanceStatus(now);

        // Save attendance with location data
        final result = await _absenceService.saveAbsence(
          selfieImage: imageFile,
          status: status,
          notes:
              'Absen via selfie pada ${_formatDateTime(now)} dari lokasi $currentLocation',
          latitude: latitude.value,
          longitude: longitude.value,
          locationAddress: currentLocation.value,
        );

        if (result != null) {
          Get.snackbar(
            'Berhasil',
            'Absensi berhasil dicatat!',
            snackPosition: SnackPosition.BOTTOM,
          );
          hasMarkedToday.value = true;
        } else {
          Get.snackbar(
            'Error',
            'Gagal mencatat absensi. Silakan coba lagi.',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Determine attendance status based on time
  String _getAttendanceStatus(DateTime time) {
    final hour = time.hour;

    if (hour <= 8) {
      return 'hadir';
    } else if (hour <= 9) {
      return 'terlambat';
    } else {
      return 'sangat_terlambat';
    }
  }

  // Format date time for Indonesian
  String _formatDateTime(DateTime time) {
    return '${time.day}/${time.month}/${time.year} ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')} WIB';
  }

  // Refresh user data
  void refreshUserData() {
    getCurrentUser();
    getCurrentLocation();
    checkTodayAttendance();
  }
}
