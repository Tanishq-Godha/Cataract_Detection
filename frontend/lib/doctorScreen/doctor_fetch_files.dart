import 'package:cloud_firestore/cloud_firestore.dart';

class Doctor {
  final String name;
  final String about;
  final String addressTitle;
  final String addressSubtitle;
  final double consultancyFee;
  final String phone;
  final String imageURL;
  final String edu;

  Doctor({
    required this.name,
    required this.about,
    required this.addressTitle,
    required this.addressSubtitle,
    required this.consultancyFee,
    required this.phone,
    required this.imageURL,
    required this.edu,
  });

  factory Doctor.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Doctor(
      name: data['docName'] ?? '',
      about: data['docAbout'] ?? '',
      addressTitle: data['docAddressTitle'] ?? '',
      addressSubtitle: data['docAddressSubtitle'] ?? '',
      consultancyFee: (data['docConsultancyFee'] ?? 0).toDouble(),
      phone: data['docPhone'] ?? '',
      imageURL: data['docProfilePic'] ?? '',
      edu: data['docEducation'] ?? '',
    );
  }
}
