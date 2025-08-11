import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/absence_controller.dart';

class AbsenceView extends GetView<AbsenceController> {
  const AbsenceView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // User info card - Nama pengguna
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.person, color: Colors.blue[600]),
                          const SizedBox(width: 8),
                          Text(
                            'Nama Pengguna',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Obx(
                        () => Text(
                          controller.currentUser.value?.email ?? 'User',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      const Divider(height: 16),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            color: Colors.blue[600],
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Obx(
                            () => Text(
                              'Tanggal: ${_formatDate(controller.currentTime.value)}',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            color: Colors.blue[600],
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Obx(
                            () => Text(
                              'Waktu: ${_formatTime(controller.currentTime.value)}',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Location info card - Lokasi pengguna (updates every 5 seconds)
              Obx(
                () => Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.location_on, color: Colors.green[600]),
                            const SizedBox(width: 8),
                            Text(
                              'Lokasi Pengguna',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700],
                              ),
                            ),
                            const Spacer(),
                            if (controller.isLocationLoading.value)
                              const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          controller.currentLocation.value,
                          style: TextStyle(
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
                                ? Colors.red[600]
                                : Colors.grey[700],
                          ),
                        ),
                        if (controller.coordinates.value.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            'Koordinat: ${controller.coordinates.value}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Location validation status
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: controller.isLocationValid.value
                                  ? Colors.green[100]
                                  : Colors.red[100],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: controller.isLocationValid.value
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  controller.isLocationValid.value
                                      ? Icons.check_circle
                                      : Icons.error,
                                  size: 16,
                                  color: controller.isLocationValid.value
                                      ? Colors.green
                                      : Colors.red,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  controller.isLocationValid.value
                                      ? 'Dalam area kantor'
                                      : 'Di luar area kantor (${controller.distanceFromOffice.value.toStringAsFixed(0)}m)',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: controller.isLocationValid.value
                                        ? Colors.green[700]
                                        : Colors.red[700],
                                    fontWeight: FontWeight.w500,
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
              ),

              const SizedBox(height: 16),

              // Attendance status - Status absensi hari ini
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: controller.hasMarkedToday.value
                      ? Colors.green[100]
                      : Colors.orange[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: controller.hasMarkedToday.value
                        ? Colors.green
                        : Colors.orange,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      controller.hasMarkedToday.value
                          ? Icons.check_circle
                          : Icons.schedule,
                      color: controller.hasMarkedToday.value
                          ? Colors.green
                          : Colors.orange,
                      size: 30,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Status Absensi Hari Ini',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            controller.hasMarkedToday.value
                                ? 'Sudah Absen'
                                : 'Belum Absen',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Mark attendance button - Tombol Absen Sekarang
              ElevatedButton.icon(
                onPressed:
                    (controller.isLoading.value ||
                        !controller.isLocationValid.value ||
                        controller.hasMarkedToday.value)
                    ? null
                    : () => controller.markAttendance(),
                icon: controller.isLoading.value
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Icon(
                        controller.hasMarkedToday.value
                            ? Icons.check
                            : !controller.isLocationValid.value
                            ? Icons.location_off
                            : Icons.camera_alt,
                      ),
                label: Text(
                  controller.isLoading.value
                      ? 'Memproses...'
                      : controller.hasMarkedToday.value
                      ? 'Sudah Absen Hari Ini'
                      : !controller.isLocationValid.value
                      ? 'Di Luar Area Kantor'
                      : 'Absen Sekarang (Ambil Foto Selfie)',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      (controller.hasMarkedToday.value ||
                          !controller.isLocationValid.value)
                      ? Colors.grey
                      : Colors.blue[600],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const Spacer(),

              // Info card - Aturan absensi
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 40,
                        color: Colors.blue[600],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Aturan Absensi',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '• Sebelum 08:00 - Hadir\n• 08:01 - 09:00 - Terlambat\n• Setelah 09:00 - Sangat Terlambat\n• Lokasi harus dalam radius 100m dari kantor\n• Koordinat kantor: -2.622724, 111.674346\n• Wajib ambil foto selfie',
                        style: TextStyle(fontSize: 13),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
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
