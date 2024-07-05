import 'package:flutter/material.dart';
class ViewAllDoctorsScreen extends StatefulWidget {
  final List<Map<String, dynamic>> doctors;

  ViewAllDoctorsScreen({required this.doctors});

  @override
  State<ViewAllDoctorsScreen> createState() => _ViewAllDoctorsScreenState();
}

class _ViewAllDoctorsScreenState extends State<ViewAllDoctorsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Doctors'),
      ),
      body: ListView.builder(
        itemCount: widget.doctors.length,
        itemBuilder: (context, index) {
          var doctor = widget.doctors[index];
          return ListTile(
            leading: CircleAvatar(
              // backgroundImage: userData!['UserProfilePicture'] != null
              //                 ? NetworkImage(userData!['UserProfilePicture'])
              //                 : AssetImage('images/placeholder.png')
              //                     as ImageProvider,
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
            title: Text(doctor['docName']),
            subtitle: Text(doctor['docType']),
            onTap: () {
              
            },
          );
        },
      ),
    );
  }
}
