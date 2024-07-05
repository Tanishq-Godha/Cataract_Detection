import 'package:cataract_detector1/doctorScreen/doctor_fetch_files.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Stream<List<Doctor>> getDoctors() {
  return FirebaseFirestore.instance.collection('doctor').snapshots().map(
    (snapshot) => snapshot.docs.map((doc) => Doctor.fromFirestore(doc)).toList(),
  );
}
