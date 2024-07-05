// import 'package:cataract_detector1/Home/Home.dart';
import 'package:cataract_detector1/LoginPage/login.dart';
import 'package:cataract_detector1/landing_page.dart';
// import 'package:cataract_detector1/SignUpPage/firebase_authentication.dart';
// import 'package:cataract_detector1/landing_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:cataract_detector/src/login.dart';
// import 'package:cataract_detector/src/landing_page.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  var auth = FirebaseAuth.instance;
  var isLogin = false;

  checkIfLogin() async{
        auth.authStateChanges().listen((User? user){
          if(user!= null && mounted){
            setState((){
              isLogin = true;
            });
          }
        });
  }
@override
  void initState() {
    // TODO: implement initState
    checkIfLogin();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    // auth.signOut();
    return MaterialApp(
      title: 'Siddhi Cataract',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: isLogin ? Home() : const LandingPage(),
      home:LandingPage(),
      routes: {
        '/login': (context) => LogIn(),
      },
    );
  }
}
