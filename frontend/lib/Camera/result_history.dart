import 'dart:io';

import 'package:cataract_detector1/Camera/camera.dart';
import 'package:cataract_detector1/Camera/current_result.dart';
import 'package:cataract_detector1/Home/Home.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'result.dart';
// import 'home_page.dart';
// import 'camera_screen.dart';

class ResultHistoryScreen extends StatelessWidget {
  final List<Result> results;

  const ResultHistoryScreen({Key? key, required this.results}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Result History'),
      ),
      body: ListView.builder(
        itemCount: results.length,
        itemBuilder: (context, index) {
          final result = results[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(result.rightEyeImagePath),
            ),
            title: Text('Right Eye: ${result.rightEyeResult}, Left Eye: ${result.leftEyeResult}'),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Delete Result'),
                    content: Text('Are you sure you want to delete this result?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: Text('Delete'),
                      ),
                    ],
                  ),
                );
                if (confirm == true) {
                  await _deleteResult(result);
                  results.removeAt(index);
                  // Update the UI
                  (context as Element).reassemble();
                }
              },
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ResultScreen(
                    rightEyeImage: File(result.rightEyeImagePath),
                    leftEyeImage: File(result.leftEyeImagePath),
                    righteyeresult: result.rightEyeResult,
                    lefteyeresult: result.leftEyeResult,
                    results: results,
                  ),
                ),
              );
            },
          );
        },
      ),
     
    );
  }

  Future<void> _deleteResult(Result result) async {
    final firestore = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final docRef = firestore
          .collection('users')
          .doc(user.uid)
          .collection('eye_results')
          .doc(result.dateTime.toString());
      await docRef.delete();

      // Delete the images from Firebase Storage
      await FirebaseStorage.instance.refFromURL(result.rightEyeImagePath).delete();
      await FirebaseStorage.instance.refFromURL(result.leftEyeImagePath).delete();
    } else {
      print('No authenticated user found');
    }
  }
}