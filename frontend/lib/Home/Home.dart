// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

// import 'package:cataract_detector1/Appoint/app/total_appintment/view/total_appointment_view.dart';
import 'package:cataract_detector1/doctorScreen/schedule_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:siddhi_app1/Appointments_Screen/appointmentscreen.dart';
// import 'package:siddhi_app1/Controllers/home_controller.dart';
import 'package:cataract_detector1/Camera/camera.dart';
import 'package:cataract_detector1/Home/controller/home_controller1.dart';
import 'package:cataract_detector1/Home/Home_screen.dart';
import 'package:cataract_detector1/profile_screen/profile.dart';
// import 'package:siddhi_app1/service/style.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
// import 'package:cataract_detector1/total_appointment/view/total_appointment_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final PageController _pageController = PageController();
  final HomeController1 controller1 = Get.put(HomeController1());

  @override
  Widget build(BuildContext context) {
    var navBody = [
      HomeScreen(),
      CameraScreen(),
      ScheduleScreen(),
      ProfileScreen(),
    ];

    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          controller1.currentNavIndex.value = index;
        },
        children: navBody,
      ),
      bottomNavigationBar: Obx(
        () => Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
            child: GNav(
              backgroundColor: Colors.white,
              color: Colors.blue,
              activeColor: Colors.blue,
              tabBackgroundColor: Colors.black,
              gap: 8,
              padding: EdgeInsets.all(16),
              selectedIndex: controller1.currentNavIndex.value,
              onTabChange: (index) {
                controller1.currentNavIndex.value = index;
                _pageController.jumpToPage(index);
              },
              tabs: [
                GButton(
                  icon: Icons.home,
                  text: 'Home',
                ),
                GButton(
                  icon: Icons.camera_alt_outlined,
                  text: 'SCAN',
                ),
                GButton(
                  icon: Icons.alarm,
                  text: 'Appointments',
                ),
                GButton(
                  icon: Icons.person,
                  text: 'Profile',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
