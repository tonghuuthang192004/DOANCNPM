import 'package:flutter/material.dart';
import 'homepage.dart';
class HomeWelcome extends StatelessWidget {

  const HomeWelcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height/1.6,

        child: Stack(
          children: [
            Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height/1.6,
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height /1.6,
                  decoration: BoxDecoration(
                    color: Color(0xFF674AEF),
                    borderRadius: BorderRadius.only(bottomRight:Radius.circular(70)),
                  ),
                  child: Center(
                    child: Image.asset('assets/books.png',scale: 0.7,),
                  ),
                )
              ],
            ),


            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: MediaQuery.of(context).size.width,

                height:MediaQuery.of(context).size.height/2.666,
                decoration: BoxDecoration(
                  color: Color(0xFF674AEF)
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: MediaQuery.of(context).size.width,

                height:MediaQuery.of(context).size.height/2.666,
                padding: EdgeInsets.only(top: 40,bottom: 30),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(70),
                    )
                ),


                child: Column(children: [



                  Text("HOPE"
                     ,

                      style:
                    TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                      letterSpacing: 1,
                      wordSpacing: 2,
                    ),
                  ),
                  SizedBox(height: 20,),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Text("Mỗi giây trôi qua là một cơ hội mới. Đừng để thời gian vụt mất.",
                      textAlign: TextAlign.center
                      ,style:

                      TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,color: Colors.black38.withOpacity(0.6)
                      ),),
                  ),
                    SizedBox(height: 20),
                  Material(
                    color: Color(0xFF674AEF),
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      onTap: (){
                        Navigator.push(context,MaterialPageRoute(builder: (context)=>homepages())
                        );
                      },

                      child:Container(
                        padding:EdgeInsets.symmetric(vertical: 8.0,horizontal: 80),
                        child: Text("GET START",style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,



                        ),
                        ),

                      ),
                    ),
                  ),
                ],

                ),
              ),
            ),
          ],
        ),


      ),
    );
  }
}
