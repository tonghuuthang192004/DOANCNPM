import 'package:congnghephanmem/pages/clock_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'alarm_clock.dart';
import 'stopWatch_clock.dart';
import 'package:provider/provider.dart';
import '../them_mode.dart';
import '../provider/provider.dart';

class homepages extends StatefulWidget {
  const homepages({super.key});

  @override
  State<homepages> createState() => _homepagesState();
}

class _homepagesState extends State<homepages> {
  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    var formattedTime = DateFormat('HH:mm').format(now);
    var formattedDate = DateFormat('EEE,d MMM').format(now);
    var timezoneString = now.timeZoneOffset.toString().split('.').first;
    var offsetSign = '';
    if (!timezoneString.startsWith('-')) offsetSign = '+';

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFF2D2F41),
        body: Row(
          children: [
            // Thanh menu bên trái
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF2D2F41),
                    ),
                    child: Column(
                      children: [
                        Image.asset('assets/clock_icon.png', scale: 1.3),
                        SizedBox(height: 12),
                        Text(
                          'Clock',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AlarmScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF2D2F41),
                    ),
                    child: Column(
                      children: [
                        Image.asset('assets/alarm_icon.png', scale: 1.3),
                        SizedBox(height: 12),
                        Text(
                          'Alarm',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TimerScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF2D2F41),
                    ),
                    child: Column(
                      children: [
                        Image.asset('assets/timer_icon.png', scale: 1.3),
                        SizedBox(height: 12),
                        Text(
                          'Timer',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            VerticalDivider(
              color: Colors.white54,
              width: 1,
            ),
            // Phần giao diện đồng hồ bên phải
            Expanded(
              child: Container(

                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 64),
                alignment: Alignment.center,
                // color: Color(0xFF2D2F41),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    // Chọn ảnh nền phù hợp với chế độ sáng/tối
                    image: AssetImage(
                      Provider.of<mode>(context).lightModeEnable? "assets/light_mode.png" // Chế độ sáng
                          : "assets/dark_mode.png", // Chế độ tối
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tiêu đề và công tắc
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Home",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 28,
                          ),
                        ),
                        Switch(
                          value: Provider.of<mode>(context).lightModeEnable,
                          onChanged: (value) {
                            Provider.of<mode>(context, listen: false)
                                .chaneMode();
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    // Hiển thị thời gian
                    Text(
                      formattedTime,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 64,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      formattedDate,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    SizedBox(height: 20),
                    // Đồng hồ analog
                    Expanded(
                      flex: 3,
                      child: Align(
                        alignment: Alignment.center,
                        child: ClockView(),
                      ),
                    ),
                    SizedBox(height: 20),
                    // Múi giờ
                    Text(
                      "Timezone",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                      ),
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(
                          Icons.language,
                          color: Colors.white,
                        ),
                        SizedBox(width: 20),
                        Text(
                          'UTC' + offsetSign + timezoneString,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ],
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
