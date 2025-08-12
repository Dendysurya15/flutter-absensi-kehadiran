import 'dart:io';
import 'package:absensi_kehadiran/app/modules/history_absence/controllers/history_absence_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HistoryView extends GetView<HistoryController> {
  const HistoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF0C487B).withOpacity(0.05), Colors.white],
                stops: [0.0, 0.3],
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF0C487B).withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFF0C487B),
                      ),
                      strokeWidth: 3,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Memuat riwayat absensi...',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        if (controller.absences.isEmpty) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF0C487B).withOpacity(0.05), Colors.white],
                stops: [0.0, 0.3],
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Color(0xFF0C487B).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(60),
                    ),
                    child: Icon(
                      Icons.history_outlined,
                      size: 60,
                      color: Color(0xFF0C487B),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Belum Ada Riwayat',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey.shade800,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Lakukan absensi untuk melihat riwayat',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                  ),
                  const SizedBox(height: 32),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xFF0C487B).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Mulai dengan absen pertama Anda',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF0C487B),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF0C487B).withOpacity(0.05), Colors.white],
              stops: [0.0, 0.3],
            ),
          ),
          child: RefreshIndicator(
            onRefresh: () async {
              controller.refreshAbsences();
            },
            color: Color(0xFF0C487B),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF0C487B).withOpacity(0.08),
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Color(0xFF0C487B).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.history_outlined,
                              size: 24,
                              color: Color(0xFF0C487B),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Riwayat Absensi',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.grey.shade800,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${controller.absences.length} catatan kehadiran',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Color(0xFF0C487B),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${controller.absences.length}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // List
                    Expanded(
                      child: ListView.builder(
                        itemCount: controller.absences.length,
                        itemBuilder: (context, index) {
                          final absence = controller.absences[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
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
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Row(
                                children: [
                                  // Avatar
                                  Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: Colors.grey.shade200,
                                        width: 2,
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(14),
                                      child:
                                          absence.selfieUrl != null &&
                                              File(
                                                absence.selfieUrl!,
                                              ).existsSync()
                                          ? Image.file(
                                              File(absence.selfieUrl!),
                                              width: 60,
                                              height: 60,
                                              fit: BoxFit.cover,
                                            )
                                          : Container(
                                              color: Color(
                                                0xFF0C487B,
                                              ).withOpacity(0.1),
                                              child: Icon(
                                                Icons.person_outline,
                                                color: Color(0xFF0C487B),
                                                size: 28,
                                              ),
                                            ),
                                    ),
                                  ),

                                  const SizedBox(width: 16),

                                  // Content
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Date
                                        Text(
                                          controller.formatDate(
                                            absence.timestamp,
                                          ),
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16,
                                            color: Colors.grey.shade800,
                                          ),
                                        ),
                                        const SizedBox(height: 4),

                                        // Time
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.access_time_outlined,
                                              size: 14,
                                              color: Colors.grey.shade500,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              controller.formatTime(
                                                absence.timestamp,
                                              ),
                                              style: TextStyle(
                                                color: Colors.grey.shade600,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 6),

                                        // Email
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.email_outlined,
                                              size: 14,
                                              color: Colors.grey.shade500,
                                            ),
                                            const SizedBox(width: 4),
                                            Expanded(
                                              child: Text(
                                                absence.userEmail,
                                                style: TextStyle(
                                                  color: Colors.grey.shade600,
                                                  fontSize: 13,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),

                                        // Notes (if available)
                                        if (absence.notes != null) ...[
                                          const SizedBox(height: 8),
                                          Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade50,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.note_outlined,
                                                  size: 14,
                                                  color: Colors.grey.shade500,
                                                ),
                                                const SizedBox(width: 6),
                                                Expanded(
                                                  child: Text(
                                                    absence.notes!,
                                                    style: TextStyle(
                                                      color:
                                                          Colors.grey.shade600,
                                                      fontSize: 12,
                                                    ),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),

                                  const SizedBox(width: 12),

                                  // Status Badge
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: controller
                                          .getStatusColor(absence.status)
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: controller
                                            .getStatusColor(absence.status)
                                            .withOpacity(0.3),
                                        width: 1,
                                      ),
                                    ),
                                    child: Text(
                                      absence.status.toUpperCase(),
                                      style: TextStyle(
                                        color: controller.getStatusColor(
                                          absence.status,
                                        ),
                                        fontWeight: FontWeight.w700,
                                        fontSize: 11,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
