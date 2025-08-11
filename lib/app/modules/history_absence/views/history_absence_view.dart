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
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.absences.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.history, size: 80, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No attendance records yet',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Mark your attendance to see history',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            controller.refreshAbsences();
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Icon(Icons.history, size: 28, color: Colors.blue[600]),
                    const SizedBox(width: 8),
                    Text(
                      'Attendance History',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${controller.absences.length} records',
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // List
                Expanded(
                  child: ListView.builder(
                    itemCount: controller.absences.length,
                    itemBuilder: (context, index) {
                      final absence = controller.absences[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: CircleAvatar(
                            backgroundColor: Colors.grey[300],
                            radius: 30,
                            child:
                                absence.selfieUrl != null &&
                                    File(absence.selfieUrl!).existsSync()
                                ? ClipOval(
                                    child: Image.file(
                                      File(absence.selfieUrl!),
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Icon(
                                    Icons.person,
                                    color: Colors.grey[600],
                                    size: 30,
                                  ),
                          ),
                          title: Text(
                            controller.formatDate(absence.timestamp),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(
                                'Email: ${absence.userEmail}', // Show email instead of userName
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                'Time: ${controller.formatTime(absence.timestamp)}',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                              if (absence.notes != null) ...[
                                const SizedBox(height: 2),
                                Text(
                                  absence.notes!,
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 12,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ],
                          ),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: controller
                                  .getStatusColor(absence.status)
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: controller.getStatusColor(
                                  absence.status,
                                ),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              absence.status.toUpperCase(),
                              style: TextStyle(
                                color: controller.getStatusColor(
                                  absence.status,
                                ),
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
