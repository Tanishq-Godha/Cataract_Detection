// ignore_for_file: prefer_const_constructors

import 'package:cataract_detector1/Home/Home.dart';
import 'package:cataract_detector1/LoginPage/login.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
    Country selectedCountry = Country(phoneCode: "91", countryCode: "IN", e164Sc: 0, geographic: true, level: 1, name:"India", example: "India", displayName: "India", displayNameNoCountryCode: "IN", e164Key: "");

  String email = "", password = "", name = "", phone = "", gender = "Male";
  int age = 0;
  bool _isLoading = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController mailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController ageController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;

  registration() async {
    if (password.isNotEmpty &&
        nameController.text.isNotEmpty &&
        mailController.text.isNotEmpty &&
        phoneController.text.isNotEmpty &&
        ageController.text.isNotEmpty &&
        gender.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'name': name,
          'email': email,
          'phone': phone,
          'gender': gender,
          'age': age,
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "Registered Successfully",
            style: TextStyle(fontSize: 20.0),
          ),
        ));

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Home()),
          (route) => false,
        );
      } on FirebaseAuthException catch (e) {
        setState(() {
          _isLoading = false;
        });
        if (e.code == 'weak-password') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.orangeAccent,
            content: Text(
              "Password Provided is too Weak",
              style: TextStyle(fontSize: 18.0),
            ),
          ));
        } else if (e.code == "email-already-in-use") {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.orangeAccent,
            content: Text(
              "Account Already exists",
              style: TextStyle(fontSize: 18.0),
            ),
          ));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text("Wait For Few Seconds"),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: screenWidth,
                    child: Image.asset(
                      "images/Drishti.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 30.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          buildTextFormField(
                              nameController, "Name", "Please Enter Name"),
                          SizedBox(height: 10.0),
                          buildTextFormField(
                              mailController, "Email", "Please Enter Email"),
                          SizedBox(height: 10.0),
                          buildTextFormFieldPhone(phoneController,
                              "Phone Number", "Please Enter Phone Number"),
                          SizedBox(height: 10.0),
                          buildDropDownField(),
                          SizedBox(height: 10.0),
                          buildTextFormField(
                              ageController, "Age", "Please Enter Age",
                              isNumber: true),
                          SizedBox(height: 20.0),
                          buildTextFormField(passwordController, "Password",
                              "Please Enter Password",
                              obscureText: _obscureText, togglePassword: true),
                          SizedBox(height: 30.0),
                          GestureDetector(
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  email = mailController.text;
                                  name = nameController.text;
                                  password = passwordController.text;
                                  phone = phoneController.text;
                                  age = int.parse(ageController.text);
                                });
                                registration();
                              }
                            },
                            child: buildSignUpButton(screenWidth),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style: TextStyle(
                            color: Color(0xFF8c8e98),
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(width: 5.0),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LogIn()));
                        },
                        child: Text(
                          "LogIn",
                          style: TextStyle(
                              color: Color(0xFF273671),
                              fontSize: 20.0,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Image.asset(
                  'images/charak.png',
                  height: 50,
                ),
                                  // SizedBox(height: 10),
                ],
              ),
            ),
    );
  }

  Widget buildTextFormField(TextEditingController controller, String hintText,
      String validationMessage,
      {bool isNumber = false, bool obscureText = false, bool togglePassword = false}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 30.0),
      decoration: BoxDecoration(
        color: Color(0xFFedf0f8),
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return validationMessage;
          }
          return null;
        },
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        obscureText: obscureText,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(color: Color(0xFFb2b7bf), fontSize: 18.0),
          suffixIcon: togglePassword
              ? IconButton(
                  icon: Icon(
                    obscureText ? Icons.visibility : Icons.visibility_off,
                    color: Color(0xFFb2b7bf),
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }

  Widget buildDropDownField() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 30.0),
      decoration: BoxDecoration(
        color: Color(0xFFedf0f8),
        borderRadius: BorderRadius.circular(30),
      ),
      child: DropdownButtonFormField<String>(
        value: gender,
        items: ['Male', 'Female', 'Other']
            .map((label) => DropdownMenuItem(
                  child: Text(label),
                  value: label,
                ))
            .toList(),
        onChanged: (value) {
          setState(() {
            gender = value!;
          });
        },
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "MALE",
          hintStyle: TextStyle(color: Color(0xFFb2b7bf), fontSize: 18.0),
        ),
      ),
    );
  }
Widget buildTextFormFieldPhone(TextEditingController controller, String hintText,
      String validationMessage,
      {bool isNumber = false, bool obscureText = false, bool togglePassword = false}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 30.0),
      decoration: BoxDecoration(
        color:  Color(0xFFedf0f8),
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return validationMessage;
          }
          return null;
        },
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: Color(0xFFb2b7bf),),
          enabledBorder: OutlineInputBorder (
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color:  Color(0xFFedf0f8)),
          ),
          focusedBorder: OutlineInputBorder (
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color:   Color(0xFFedf0f8)),
          ),
          prefixIcon: Container(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: (){
                // Implement your Country Picker functionality here
              },
              child: Text("${selectedCountry.flagEmoji} + ${selectedCountry.phoneCode}", 
              style: const TextStyle(
                fontSize: 18, 
                color: Colors.black, fontWeight: FontWeight.bold,
              ), // TextStyle
            ),
          ),
          // suffixIcon : phoneController.text.length > 9
          //     ?Container(
          //       height: 30,
          //       width: 30,
          //       margin:  const EdgeInsets.all(10.0),
          //       decoration: const BoxDecoration(
          //         shape: BoxShape.circle,
          //         color: Colors.green,
          //       ),
          //       child: const Icon(
          //         Icons.done,
          //         color: Colors.white,
          //         size: 20,
          //       ),
          //     )
          //     : null,
        ),
      ),
    ),
    );
  }

  Widget buildSignUpButton(double screenWidth) {
    return Container(
      width: screenWidth,
      padding: EdgeInsets.symmetric(vertical: 13.0, horizontal: 30.0),
      decoration: BoxDecoration(
        color: Color(0xFF273671),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Center(
        child: Text(
          "Sign Up",
          style: TextStyle(
              color: Colors.white, fontSize: 22.0, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
