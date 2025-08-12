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
        title: Row(
          children: [
            Text(
              'AbsensiKu',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 20,
                color: Colors.white,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'v1.0.0',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Color(0xFF0C487B),
        foregroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: controller.tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
          tabs: const [
            Tab(
              icon: Icon(Icons.camera_alt, size: 22),
              text: 'Mark Attendance',
            ),
            Tab(icon: Icon(Icons.history_outlined, size: 22), text: 'History'),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.logout_outlined, size: 20),
              ),
              onPressed: () => controller.signOut(),
              tooltip: 'Sign Out',
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0C487B), // Primary blue
              Color(0xFF1565C0), // Lighter blue
              Colors.white,
            ],
            stops: [0.0, 0.1, 0.3],
          ),
        ),
        child: TabBarView(
          controller: controller.tabController,
          children: const [AbsenceView(), HistoryView()],
        ),
      ),
    );
  }
}
