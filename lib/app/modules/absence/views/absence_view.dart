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
              // User info card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome, ${controller.currentUser.value?.email}',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Today: ${DateTime.now().toString().split(' ')[0]}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Attendance status
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
                      child: Text(
                        controller.hasMarkedToday.value
                            ? 'Attendance marked for today!'
                            : 'Please mark your attendance',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Mark attendance button
              ElevatedButton.icon(
                onPressed: controller.isLoading.value
                    ? null
                    : () => controller.markAttendance(),
                icon: controller.isLoading.value
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.camera_alt),
                label: Text(
                  controller.isLoading.value
                      ? 'Processing...'
                      : controller.hasMarkedToday.value
                      ? 'Already Marked Today'
                      : 'Take Selfie & Mark Attendance',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: controller.hasMarkedToday.value
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

              // Info card
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
                        'Attendance Rules',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '• Before 8:00 AM - Present\n• 8:01 - 9:00 AM - Late\n• After 9:00 AM - Very Late',
                        style: TextStyle(fontSize: 14),
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
}
