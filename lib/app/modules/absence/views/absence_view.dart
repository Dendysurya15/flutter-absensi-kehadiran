import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/absence_controller.dart';

class AbsenceView extends GetView<AbsenceController> {
  const AbsenceView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF0C487B).withOpacity(0.05), Colors.white],
              stops: [0.0, 0.3],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Welcome Header
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF0C487B).withOpacity(0.08),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Color(0xFF0C487B).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Icon(
                                Icons.person_outline,
                                color: Color(0xFF0C487B),
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Selamat Datang',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade600,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Obx(
                                    () => Text(
                                      controller.currentUser.value?.email ??
                                          'User',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.grey.shade800,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Container(
                          height: 1,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                Colors.grey.shade200,
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.calendar_today_outlined,
                                    color: Color(0xFF0C487B),
                                    size: 20,
                                  ),
                                  const SizedBox(height: 8),
                                  Obx(
                                    () => Text(
                                      _formatDate(controller.currentTime.value),
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey.shade700,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 40,
                              color: Colors.grey.shade200,
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.access_time_outlined,
                                    color: Color(0xFF0C487B),
                                    size: 20,
                                  ),
                                  const SizedBox(height: 8),
                                  Obx(
                                    () => Text(
                                      _formatTime(controller.currentTime.value),
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey.shade700,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Location Card
                  Obx(
                    () => Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.location_on_outlined,
                                  color: Colors.green.shade600,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Lokasi Saat Ini',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey.shade800,
                                ),
                              ),
                              const Spacer(),
                              if (controller.isLocationLoading.value)
                                SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Color(0xFF0C487B),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            controller.currentLocation.value,
                            style: TextStyle(
                              fontSize: 14,
                              color:
                                  controller.currentLocation.value.contains(
                                        'Error',
                                      ) ||
                                      controller.currentLocation.value.contains(
                                        'ditolak',
                                      ) ||
                                      controller.currentLocation.value.contains(
                                        'tidak',
                                      )
                                  ? Colors.red.shade600
                                  : Colors.grey.shade600,
                              height: 1.4,
                            ),
                          ),
                          if (controller.coordinates.value.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            Text(
                              'Koordinat: ${controller.coordinates.value}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade500,
                                fontFamily: 'monospace',
                              ),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: controller.isLocationValid.value
                                    ? Colors.green.shade50
                                    : Colors.red.shade50,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: controller.isLocationValid.value
                                      ? Colors.green.shade200
                                      : Colors.red.shade200,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    controller.isLocationValid.value
                                        ? Icons.check_circle_outline
                                        : Icons.error_outline,
                                    size: 18,
                                    color: controller.isLocationValid.value
                                        ? Colors.green.shade600
                                        : Colors.red.shade600,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      controller.isLocationValid.value
                                          ? 'Dalam area kantor'
                                          : 'Di luar area kantor (${controller.distanceFromOffice.value.toStringAsFixed(0)}m)',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: controller.isLocationValid.value
                                            ? Colors.green.shade700
                                            : Colors.red.shade700,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Attendance Status Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: controller.hasMarkedToday.value
                            ? [Colors.green.shade50, Colors.green.shade100]
                            : [Colors.orange.shade50, Colors.orange.shade100],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: controller.hasMarkedToday.value
                            ? Colors.green.shade200
                            : Colors.orange.shade200,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: controller.hasMarkedToday.value
                                ? Colors.green.shade600
                                : Colors.orange.shade600,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            controller.hasMarkedToday.value
                                ? Icons.check_circle
                                : Icons.schedule,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Status Absensi Hari Ini',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                controller.hasMarkedToday.value
                                    ? 'Sudah Absen'
                                    : 'Belum Absen',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: controller.hasMarkedToday.value
                                      ? Colors.green.shade700
                                      : Colors.orange.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Mark Attendance Button
                  Container(
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow:
                          (controller.isLoading.value ||
                              !controller.isLocationValid.value ||
                              controller.hasMarkedToday.value)
                          ? null
                          : [
                              BoxShadow(
                                color: Color(0xFF0C487B).withOpacity(0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                    ),
                    child: ElevatedButton(
                      onPressed:
                          (controller.isLoading.value ||
                              !controller.isLocationValid.value ||
                              controller.hasMarkedToday.value)
                          ? null
                          : () => controller.markAttendance(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            (controller.hasMarkedToday.value ||
                                !controller.isLocationValid.value)
                            ? Colors.grey.shade400
                            : Color(0xFF0C487B),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (controller.isLoading.value)
                            const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          else
                            Icon(
                              controller.hasMarkedToday.value
                                  ? Icons.check
                                  : !controller.isLocationValid.value
                                  ? Icons.location_off
                                  : Icons.camera_alt,
                              size: 24,
                            ),
                          const SizedBox(width: 12),
                          Text(
                            controller.isLoading.value
                                ? 'Memproses...'
                                : controller.hasMarkedToday.value
                                ? 'Sudah Absen Hari Ini'
                                : !controller.isLocationValid.value
                                ? 'Di Luar Area Kantor'
                                : 'Absen Sekarang (Ambil Foto Selfie)',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Rules Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Color(0xFF0C487B).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.info_outline,
                            size: 28,
                            color: Color(0xFF0C487B),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Aturan Absensi',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              _buildRuleItem(
                                'Sebelum 08:00',
                                'Hadir',
                                Colors.green,
                              ),
                              _buildRuleItem(
                                '08:01 - 09:00',
                                'Terlambat',
                                Colors.orange,
                              ),
                              _buildRuleItem(
                                'Setelah 09:00',
                                'Sangat Terlambat',
                                Colors.red,
                              ),
                              const SizedBox(height: 12),
                              Container(height: 1, color: Colors.grey.shade300),
                              const SizedBox(height: 12),
                              _buildInfoItem(
                                Icons.location_on,
                                'Radius 100m dari kantor',
                              ),
                              _buildInfoItem(
                                Icons.gps_fixed,
                                'Koordinat: -2.622724, 111.674346',
                              ),
                              _buildInfoItem(
                                Icons.camera_alt,
                                'Wajib ambil foto selfie',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRuleItem(String time, String status, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '$time - ',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            status,
            style: TextStyle(
              fontSize: 13,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.grey.shade500),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')} WIB';
  }
}
