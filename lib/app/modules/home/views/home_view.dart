import 'package:absensi_kehadiran/app/modules/history_absence/bindings/history_absence_binding.dart';
import 'package:absensi_kehadiran/app/modules/history_absence/views/history_absence_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../../absence/views/absence_view.dart';
import '../../absence/bindings/absence_binding.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize bindings for child modules
    AbsenceBinding().dependencies();
    HistoryBinding().dependencies();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance App'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: controller.tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(icon: Icon(Icons.camera_alt), text: 'Mark Attendance'),
            Tab(icon: Icon(Icons.history), text: 'History'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => controller.signOut(),
          ),
        ],
      ),
      body: TabBarView(
        controller: controller.tabController,
        children: const [AbsenceView(), HistoryView()],
      ),
    );
  }
}
