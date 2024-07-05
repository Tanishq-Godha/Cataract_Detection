// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, sort_child_properties_last, file_names, unused_element

import 'package:cataract_detector1/Home/controller/home_controller1.dart';
import 'package:cataract_detector1/doctorScreen/all_doctor_screen.dart';
import 'package:cataract_detector1/doctorScreen/doctor_screen.dart';
import 'package:intl/intl.dart';
import 'package:cataract_detector1/Home/controller/home_screen_controller.dart';
// import 'package:cataract_detector1/DoctorView/Doctor_View.dart';
import 'package:cataract_detector1/src/consts/consts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:cataract_detector1/profile_screen/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';


class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> doctors = []; // List to hold doctors' data
  User? user = FirebaseAuth.instance.currentUser;
  Map<String, dynamic>? userData;
  var controller = Get.put(HomeController());
  final PageController _pageController = PageController();
    final HomeController1 controller1 = Get.put(HomeController1());
    final ScrollController _scrollController = ScrollController();
    fetchUserData() async {
  if (user != null) {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();
      if (userDoc.exists) {
        setState(() {
          userData = userDoc.data() as Map<String, dynamic>;
        });
      } else {
        print("User document does not exist");
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  } else {
    print("No authenticated user found");
  }
}
void fetchDoctorData() async {
  try {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('doctors').get();

    setState(() {
      doctors = querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    });
  } catch (e) {
    print("Error fetching doctors: $e");
  }
}

  //    @override
  // void dispose() {
  //   _scrollController.dispose(); // Dispose the controller when the widget is disposed
  //   super.dispose();
  // }
  
  @override
  void initState() {
    super.initState();
    fetchUserData();
    fetchDoctorData();
  }
  List imgs = [
      "images/doctor1.jpg",
      "images/doctor2.jpg",
      "images/doctor3.jpg",
      "images/doctor4.jpg",
  ];
  @override
  Widget build(BuildContext context) {
 
    String currentMonthYear = DateFormat.yMMMM().format(DateTime.now());
    int currentDay = DateTime.now().day;
    List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    List<DateTime> weekDays = List.generate(7, (index) => DateTime.now().add(Duration(days: index - DateTime.now().weekday + 1)));

    return Scaffold(
      backgroundColor: Colors.white,
      body: userData == null
          ? Center(child: CircularProgressIndicator())
          :SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              
    Row(
      children: [
         // Optional: Add spacing between the icon and text
        Column(
          children: [
            Text(
              'Welcome back,',
              style: TextStyle(color: Colors.black, fontSize: 15),
                      ),
                      SizedBox(height:5),
                      Text(
                       userData!['name'],
                        style: TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold),
                      ),
          ],
        ),
        Spacer(),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileScreen()),
            );
          },
          child: CircleAvatar(
            backgroundImage: userData!['UserProfilePicture'] != null
                              ? NetworkImage(userData!['UserProfilePicture'])
                              : AssetImage('images/placeholder.png')
                                  as ImageProvider, // Placeholder image
            radius: 25,
          ),
        ),
      ],
    ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Change navigation bar to index 1 to go to the camera screen
                  controller1.currentNavIndex.value = 1;
                  _pageController.jumpToPage(1);
                },
                child: Text(
                  'Click To GET YOUR EYES\n CHECKED',
                  style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Background color
                  padding: EdgeInsets.symmetric(horizontal: 80, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    'Available Doctors',
                    style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 150),
                  GestureDetector(
                        onTap: () {
                          Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ViewAllDoctorsScreen(doctors: doctors)),
    );
                        },
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: "View All"
                              .text
                              .color(AppColors.primeryColor)
                              .size(AppFontSize.size16)
                              .make(),
                        ),
                      ),
                ],
              ),
              SizedBox(height: 8),
              Container(
                height: 200,

child: ListView.builder(
  shrinkWrap: true,
  scrollDirection: Axis.horizontal,
  itemCount: doctors.length,
  itemBuilder: (context, index) {
    var doctor = doctors[index];
    return Container(
      width: 125,
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DoctorScreen(),
                ),
              );
              // Handle tap on doctor card
              // Navigate to doctor details page, etc.
            },
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              
  
  child: Image.network(
                doctor['docProfilePic'],
                height: 110,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'images/placeholder.png', // Placeholder image asset path
                    height: 110,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doctor['docName'],
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.black.withOpacity(0.6),
                  ),
                ),
                Text(
                  doctor['docType'],
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.black.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  },
)
              ),
              SizedBox(height: 1), 
              Text(
                currentMonthYear,
                style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: weekDays.map((date) {
                  bool isSelected = date.day == currentDay;
                  return _calendarDay(
                    DateFormat('EEE').format(date),
                    date.day.toString(),
                    isSelected: isSelected,
                  );
                }).toList(),
              ),
              SizedBox(height: 16),
              Text(
                'Upcoming Appointments',
                style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Expanded(
                child: ListView(
                  children: <Widget>[
                    _appointmentCard('Medical Checkup - Routine', '09:00 - 10:15', 'Dr. Mike David'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _doctorAvatar(String imagePath) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: CircleAvatar(
        backgroundImage: AssetImage(imagePath), // Placeholder image
        radius: 30,
      ),
    );
  }

  Widget _calendarDay(String day, String date, {bool isSelected = false}) {
    return Column(
      children: <Widget>[
        Text(
          day,
          style: TextStyle(color: Colors.black),
        ),
        SizedBox(height: 4),
        CircleAvatar(
          backgroundColor: isSelected ? Colors.black : Colors.white,
          child: Text(
            date,
            style: TextStyle(color: isSelected ? Colors.blue : Colors.black),
          ),
        ),
      ],
    );
  }

  Widget _appointmentCard(String title, String time, String doctorName) {
    return Card(
      color: Colors.blue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        title: Text(title, style: TextStyle(color: Colors.black)),
        subtitle: Text('$time \n$doctorName', style: TextStyle(color: Colors.white70)),
        leading: CircleAvatar(
          backgroundImage: AssetImage('images/doctor.jpg'), // Placeholder image
        ),
      ),
    );
  }
}


