import 'package:congnghephanmem/pages/clock_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'alarm_clock.dart';
import 'stopWatch_clock.dart';
class homepages extends StatefulWidget {
  const homepages({super.key});

  @override
  State<homepages> createState() => _homepagesState();
}

class _homepagesState extends State<homepages> {
  @override
  Widget build(BuildContext context) {
    var now =DateTime.now();
    var formattedTime=DateFormat('HH:mm').format(now);
    var formattedDate=DateFormat('EEE,d MMM').format(now);
    var timezoneString=now.timeZoneOffset.toString().split('.').first;
    var offsetSign='';
    if(!timezoneString.startsWith('-'))
      offsetSign='+';
    print(timezoneString);


    return
      SafeArea(
        child: Scaffold(
        backgroundColor: Color(0xFF2D2F41),
        body:
        Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
        Container(
        padding: EdgeInsets.symmetric(vertical: 16.0),
          child: ElevatedButton(onPressed: (){

          },
            style: ElevatedButton.styleFrom(
              backgroundColor:Color(0xFF2D2F41)

            ),
            child:

            Column(


              children: [
                Image.asset('assets/clock_icon.png',scale: 1.3,),
                SizedBox(height: 12),
                Text('Clock',style: TextStyle(color: Colors.white,fontSize: 14),)
              ],

            ),
          ),
        ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  AlarmScreen()),
                    );

                  },
                    style: ElevatedButton.styleFrom(
                        backgroundColor:Color(0xFF2D2F41)

                    ),
                    child:

                    Column(


                      children: [
                        Image.asset('assets/alarm_icon.png',scale: 1.3,),
                        SizedBox(height: 12),
                        Text('Alarm',style: TextStyle(color: Colors.white,fontSize: 14),)
                      ],

                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TimerScreen()),
                    );

                  },
                    style: ElevatedButton.styleFrom(
                        backgroundColor:Color(0xFF2D2F41)

                    ),
                    child:

                    Column(


                      children: [
                        Image.asset('assets/stopwatch_icon.png',scale: 1.3,),
                        SizedBox(height: 12),
                        Text('StopWatch',style: TextStyle(color: Colors.white,fontSize: 14),)
                      ],

                    ),
                  ),
                ),



              ],),
            VerticalDivider(
              color: Colors.white54,
              width: 1,
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 32,vertical: 64),
                alignment: Alignment.center,
                color: Color(0xFF2D2F41),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: Text("Stop Watch ",style: TextStyle(
                        color: Colors.white,fontWeight: FontWeight.bold,fontSize: 28
                      ),),
                    ),
                    Flexible(
                      flex: 2,
                      fit: FlexFit.tight,
                      child: Column(

                        children: [
                          Text(formattedTime,style: TextStyle(
                              color: Colors.white,fontWeight: FontWeight.bold,fontSize: 64
                          ),),
                          SizedBox(height: 12),

                          Expanded(
                            child: Text(formattedDate,style: TextStyle(
                                color: Colors.white,fontWeight: FontWeight.bold,fontSize: 22
                            ),),
                          ),

                        ]

                      ),
                    ),
                    Flexible(
                      flex: 4,
                        fit: FlexFit.tight,
                        child:Expanded(
                          child: Align(
                            alignment: Alignment.center,
                              child:  ClockView()
                          ),
                        )

                    ),
                    Flexible(
                      flex: 2,
                      fit: FlexFit.tight,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Timezone",style: TextStyle(
                              color: Colors.white,fontWeight: FontWeight.bold,fontSize: 28
                          ),),
                        SizedBox(height: 12),
                          Row(
                            children: [

                              Container(



                                child: Icon(Icons.language,color: Colors.white,),
                                padding: EdgeInsets.only(right: 20),
                              ),

                              Text('UTC'+offsetSign+timezoneString,style: TextStyle(
                                  color: Colors.white,fontSize: 18
                              ),)
                            ],
                          )
                        ],
                      ),
                    )

                  ],
                ),
              ),
            ),
          ],
        )
            ),
      );
  }
}

