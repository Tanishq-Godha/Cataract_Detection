// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cataract_detector1/LoginPage/login.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MediaQuery(
        data: MediaQuery.of(context),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF63BCFF), Color(0xFF97D1FD), Color(0xFFFFFFFF)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Spacer(),
              Image.asset(
                'images/doctor3bg.png',
                 // Make sure to add your image to the assets folder and update the path
                 height: 400,
                 width: 300,
                // fit: BoxFit.cover,
              ),
              // SizedBox(height: 100),
              Text(
                'See if Cataracts Clouds Your Vision',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'See Clearly, Live Brightly\n Check for Cataracts Today',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black54,
                  fontStyle: FontStyle.italic,
                ),
              ),
              SizedBox(height: 10),
              // Column(
              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //   children: [
              //     ElevatedButton(
              //         onPressed: () {
              //           // Add your login as doctor action here
              //         },
              //         style: ElevatedButton.styleFrom(
              //           backgroundColor: Color(0xFF273671),
              //           padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
              //           shape: RoundedRectangleBorder(
              //             borderRadius: BorderRadius.circular(10),
              //           ),
              //         ),
              //         child: Text(
              //           'LOGIN AS DOCTOR',
              //           style: TextStyle(fontSize: 16, color: Colors.white),
              //         ),
              //       ),
                  SizedBox(height: 20),
                   ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => LogIn()));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF273671),
                        padding: EdgeInsets.symmetric(horizontal: 100, vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                      child: Text(
                      // SizedBox: double.infinity,
                        'GET STARTED',
                        style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  
              //   ],
              // ),
              SizedBox(height: 90),
              // Container(
              //   padding: EdgeInsets.all(20),
              //   decoration: BoxDecoration(
              //     color: Color(0xFF63BCFF),
              //     borderRadius: BorderRadius.circular(30),
              //   ),
              //   child: Icon(
              //     Icons.arrow_forward,
              //     color: Colors.white,
              //     size: 30,
              //   ),
              // ),
              // SizedBox(height: 50),
              Image.asset(
                'images/charak.png', // Make sure to add your image to the assets folder and update the path
                height: 50,
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}