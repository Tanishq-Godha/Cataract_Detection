import 'package:cataract_detector1/doctorScreen/widgets/upcoming_appointment.dart';
import 'package:cataract_detector1/src/consts/consts.dart';
import 'package:flutter/cupertino.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  int _buttonIndex = 0;
  final _scheduleWidgets =[
    UpcomingAppointment(),
    Container(),
    Container(),
  ];
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child:  Padding(padding: EdgeInsets.only(top: 30),
        child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
            Padding(padding: EdgeInsets.symmetric(horizontal: 15),
            child: Text("Schedule",
            style: TextStyle(fontSize:25 , fontWeight: FontWeight.w500),
            ),
            ),
            SizedBox(height: 20,),
            Container(
              padding: EdgeInsets.all(5),
              margin: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                 color: Color(0xFFF4F6FA),
                 borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: (){
                      setState(() {
                        _buttonIndex=0;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 25),
                      decoration:BoxDecoration(
                        color: _buttonIndex == 0 ? Colors.blue.shade700 :Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text("Upcoming",
                      style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500,
                        color: _buttonIndex ==0 ?Colors.white : Colors.black38,
                      ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      setState(() {
                        _buttonIndex=1;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 25),
                      decoration:BoxDecoration(
                        color: _buttonIndex == 1 ? Colors.blue.shade700 :Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text("Completed",
                      style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500,
                        color: _buttonIndex ==1 ?Colors.white : Colors.black38,
                      ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      setState(() {
                        _buttonIndex=2;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 25),
                      decoration:BoxDecoration(
                        color: _buttonIndex == 2 ? Colors.blue.shade700 :Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text("Canceled",
                      style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500,
                        color: _buttonIndex ==2 ?Colors.white : Colors.black38,
                      ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30,),
            _scheduleWidgets [_buttonIndex],
           ],
        ),
        ),
    );
  }
}