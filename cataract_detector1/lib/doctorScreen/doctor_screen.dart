// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cataract_detector1/doctorScreen/appointment_screen.dart';
import 'package:cataract_detector1/doctorScreen/doctor_fetch_files.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
class DoctorScreen extends StatelessWidget {
  late final List<Map<String, dynamic>> doctors;
  // DoctorScreen({required this.doctor});
//   List imgs = [
// "images/doctor1.jpg"
// "images/doctor2.jpg"
// "images/doctor3.jpg"
// "images/doctor4.jpg",
// ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 130, 196, 250),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height:  50,),
            Padding(padding: EdgeInsets.symmetric(horizontal: 10),
            child: Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                   InkWell(
                  onTap: () => Navigator.pop(context),
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          size: 25,
                          color: Colors.white,
                        ),
                      ),
                  //     InkWell(
                  // onTap: () => Navigator.pop(context),
                  //       child: Icon(
                  //         Icons.more_vert,
                  //         size: 25,
                  //         color: Colors.white,
                  //       ),
                  //     ),
                  ],
                ),
                Padding(padding: EdgeInsets.symmetric(vertical: 10,),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage:AssetImage("images/doctor1.jpg") ,
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Dr. Doctor Name",
                      style: TextStyle(
                        fontSize: 23, fontWeight: FontWeight.w500, color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 5,),
                    Text(
                      "Ophthalmologist",
                      style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape:  BoxShape.circle
                          ),
                          child: Icon(Icons.call,
                          color: Colors.blue.shade700,
                          size: 25
                          ),
                        ),
                        SizedBox(width: 20,),
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape:  BoxShape.circle
                          ),
                          child: Icon(
                           CupertinoIcons.chat_bubble_text_fill,
                          color: Colors.blue.shade700,
                          size: 25
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                )
              ],
            ),
            ),
            SizedBox(height: 15,),
            Container(
              height: MediaQuery.of(context).size.height /1.5 ,
              width: double.infinity,
              padding: EdgeInsets.only(
                top: 20, left: 15,
              ),
              decoration: BoxDecoration(
                color:  Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10)
              )
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text("About Doctor",style: TextStyle(fontSize: 22,fontWeight: FontWeight.w500,
                    color: Colors.black.withOpacity(0.7),
                  )
                  ),
                  SizedBox(height: 5,),
                  Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. ",
                  style: TextStyle(fontSize: 16,color: Colors.black54,
                  ),
                  ),
                  SizedBox(height:  10,),
                  Text (
                      "Education :-", style:TextStyle( fontSize: 20, fontWeight: FontWeight. w500, color:Colors.black.withOpacity(0.7),),),
                    SizedBox(height:  10,),     
                  Row(
                    children: [
                        Text ("Reviews", 
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500,color: Colors.black.withOpacity(0.7),),), 
                    SizedBox(width: 10,),
                    Icon(Icons.star, color: Colors.amber,),
                    Text("4.9", style: TextStyle(fontWeight: FontWeight.w500, fontSize:16),),
                    SizedBox(width: 5),
                    Text("(124)",style: TextStyle(fontWeight: FontWeight. w500, color:Colors.blue.shade700,fontSize: 16,),),
                    ],),
                    
                                SizedBox(height: 10,),
                                // Spacer(),
                                Text (
                                  "Address", style:TextStyle( fontSize: 20, fontWeight: FontWeight. w500, color:Colors.black.withOpacity(0.7),),),
                            ListTile(
                              leading:  Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color:Color(0xFFF0EEFA),shape: BoxShape.circle,),
                                  child: Icon(Icons.location_on, color:Colors.blue.shade700,size:20,
                                  ),
                              ),
                              title: Text(
                                "IIT INDORE Health Centre", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black54),
                              ),
                              subtitle: Text("Address Line of medical centre"),
                            ),
                            Spacer(),
                    //           ],
                    //         ),
                    //       ) 
                    //     );
                    //   },

                    // ),
                    // )
                ],
              ),
            )
          ],
        )
      ),
      bottomNavigationBar: Container(
        padding:EdgeInsets.all(15) ,
        height: 140 ,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
              BoxShadow(
                color: Colors.black12, blurRadius: 4, spreadRadius: 2
          )
          ]
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Consultation Fee", style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w500),),
                Text("\₹1000", style: TextStyle(fontSize: 20, color:Colors.blue.withOpacity (0.8), fontWeight: FontWeight.bold,),)
              ],
            ),
            SizedBox(height: 5,),
            InkWell(
              onTap: (){
                Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => AppointmentScreen(), // Pass a function that returns the DoctorScreen widget
                                              ),
                                              );
              },
              child:  Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(
                  color:  Colors.blue.shade700,
                  borderRadius:BorderRadius.circular(10)
                ),
                child: Center(
                  child: Text("Book Appointment", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),),
                  )
              ),
            )
          ],
        ),
      ) ,
    );
  }
}