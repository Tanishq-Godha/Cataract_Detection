import 'dart:io';
import 'package:cataract_detector1/Camera/camera.dart';
import 'package:cataract_detector1/Camera/result_history.dart';
import 'package:cataract_detector1/Home/Home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'result.dart';

class ResultScreen extends StatefulWidget {
  final File rightEyeImage;
  final File leftEyeImage;
  final String righteyeresult;
  final String lefteyeresult;
  final List<Result> results;

  const ResultScreen({
    Key? key,
    required this.rightEyeImage,
    required this.leftEyeImage,
    required this.righteyeresult,
    required this.lefteyeresult,
    required this.results,
  }) : super(key: key);

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  Map<String, dynamic>? userData;
  bool isResultSaved = false;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Result'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
                    CircleAvatar(
                      radius: 75,
                      backgroundImage: FileImage(widget.rightEyeImage),
                    ),
                    Text(
                      'Right Eye: ${widget.righteyeresult}',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  
                SizedBox(height: 20),
                
                    CircleAvatar(
                      radius: 75,
                      backgroundImage: FileImage(widget.leftEyeImage),
                    ),
                    Text(
                      'Left Eye: ${widget.lefteyeresult}',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  
              
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final newResult = Result(
                  rightEyeResult: widget.righteyeresult,
                  leftEyeResult: widget.lefteyeresult,
                  rightEyeImagePath: '', // Initialize image paths before upload
                  leftEyeImagePath: '',
                  dateTime: DateTime.now(),
                );

                await _uploadImages(newResult); // Upload images first
                await _saveResultsToFirebase(newResult); // Save data to Firestore

                widget.results.add(newResult); // Update local results list
                setState(() {
                  isResultSaved = true; // Enable view result history button
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('YOUR RESULT IS SAVED')),
                );
              },
              child: Text('Save Result'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isResultSaved
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ResultHistoryScreen(results: widget.results),
                        ),
                      );
                    }
                  : null,
              child: Text('VIEW RESULT HISTORY'),
            ),
          ],
        ),
      ),
       bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Home()),
                    // (route) => false,
                  );
                },
                child: Text('HOME PAGE'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CameraScreen()),
                    // (route) => false,
                  );
                },
                child: Text('TEST AGAIN'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveResultsToFirebase(Result newResult) async {
    final firestore = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final docRef = firestore
          .collection('users')
          .doc(user.uid)
          .collection('eye_results')
          .doc(); // Automatically generate a unique document ID
      await docRef.set(newResult.toMap());
    } else {
      print('No authenticated user found');
    }
  }

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

  Future<void> _uploadImages(Result newResult) async {
    if (widget.rightEyeImage != null && widget.leftEyeImage != null && user != null) {
      try {
        // Upload right eye image
        Reference rightEyeRef = FirebaseStorage.instance
            .ref()
            .child('eye_images/${newResult.dateTime}/${user!.uid}_right.jpg');
        TaskSnapshot uploadTask1 = await rightEyeRef.putFile(widget.rightEyeImage);
        newResult.rightEyeImagePath = await rightEyeRef.getDownloadURL();

        // Upload left eye image
        Reference leftEyeRef = FirebaseStorage.instance
            .ref()
            .child('eye_images/${newResult.dateTime}/${user!.uid}_left.jpg');
        TaskSnapshot uploadTask2 = await leftEyeRef.putFile(widget.leftEyeImage);
        newResult.leftEyeImagePath = await leftEyeRef.getDownloadURL();
      } catch (e) {
        print('Error uploading images: $e');
      }
    }
  }
}