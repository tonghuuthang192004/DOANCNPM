import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';
import 'alarm_clock.dart';
import 'homepage.dart';
import 'package:flutter/cupertino.dart';
class TimerScreen extends StatefulWidget {
  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  int _hours = 0;
  int _minutes = 0;
  int _seconds = 0;
  int _totalSeconds = 0; // Tổng số giây của thời gian hẹn giờ
  Timer? _timer;
  bool _isRunning = false;
  bool _isPaused = false;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void dispose() {
    _timer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _startTimer() {
    if (_totalSeconds > 0 && !_isRunning) {
      setState(() {
        _isRunning = true;
        _isPaused = false;
      });

      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          _totalSeconds--;
        });

        if (_totalSeconds <= 0) {
          _timer?.cancel();
          _isRunning = false;
          _playAlarmSound();
          _showTimerEndNotification();
        }
      });
    }
  }

  void _pauseTimer() {
    if (_timer != null) {
      _timer!.cancel();
      setState(() {
        _isRunning = false;
        _isPaused = true;
      });
    }
  }

  void _resetTimer() {
    if (!_isRunning) {
      setState(() {
        _hours = 0;
        _minutes = 0;
        _seconds = 0;
        _totalSeconds = 0;
      });
    }
  }

  void _playAlarmSound() async {
    await _audioPlayer.play(AssetSource('audio/aaa.mp3'));
  }

  void _showTimerEndNotification() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFF2D2F41),
        title: Text(
          'Hẹn giờ kết thúc!',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Thời gian đã hết!',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _audioPlayer.stop();
              Navigator.of(context).pop();
            },
            child: Text('Tắt', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }

  // Sử dụng CupertinoTimerPicker để chọn thời gian
  void _setTimer() async {
    final Duration? selectedDuration = await showModalBottomSheet<Duration>(
      context: context,
      builder: (BuildContext context) {
        Duration tempDuration = Duration(
          hours: _hours,
          minutes: _minutes,
          seconds: _seconds,
        );

        return Container(
          height: 250,
          color: Color(0xFF2D2F41),
          child: Column(
            children: [
              Expanded(
                child: CupertinoTimerPicker(
                  mode: CupertinoTimerPickerMode.hms,
                  initialTimerDuration: tempDuration,
                  onTimerDurationChanged: (Duration newDuration) {
                    tempDuration = newDuration;
                  },
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(tempDuration);
                },
                child: Text('Chọn', style: TextStyle(color: Colors.blue)),
              ),
            ],
          ),
        );
      },
    );

    if (selectedDuration != null) {
      setState(() {
        _hours = selectedDuration.inHours;
        _minutes = selectedDuration.inMinutes % 60;
        _seconds = selectedDuration.inSeconds % 60;
        _totalSeconds = _hours * 3600 + _minutes * 60 + _seconds;
      });
    }
  }

  String _formatTime(int seconds) {
    int hours = (seconds / 3600).floor();
    int minutes = (seconds % 3600) ~/ 60;
    int remainingSeconds = seconds % 60;
    return '$hours:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      
      child: Scaffold(

        backgroundColor: Color(0xFF2D2F41),
        body: Row(
          children: [

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                NavigationButton(
                  image: 'assets/clock_icon.png',
                  label: 'Clock',
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => homepages()),
                  ),
                ),
                NavigationButton(
                  image: 'assets/alarm_icon.png',
                  label: 'Alarm',
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AlarmScreen()),
                  ),
                ),
                NavigationButton(
                  image: 'assets/stopwatch_icon.png',
                  label: 'StopWatch',
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TimerScreen()),
                  ),
                ),
              ],
            ),
            Expanded(

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _formatTime(_totalSeconds),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                        color: Colors.grey[850], // Màu nền khung
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.blueAccent, // Màu đường viền
                          width: 2,
                        ),
                        boxShadow:[
                          BoxShadow(
                            color: Colors.black54, // Màu bóng (đen mờ)
                            offset: Offset(4, 4),  // Độ dịch chuyển của bóng (x, y)
                            blurRadius: 8,         // Độ mờ của bóng
                            spreadRadius: 2,
                          ),
                        ]
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: _isRunning ? null : _startTimer,
                          child: Text('Bắt đầu', style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                        ),
                        SizedBox(width: 20),
                        ElevatedButton(
                          onPressed: _isRunning ? _pauseTimer : null,
                          child: Text('Tạm dừng', style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: _resetTimer,
                    child: Text('Reset', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _setTimer,
                    child: Text('Chọn thời gian', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NavigationButton extends StatelessWidget {
  final String image;
  final String label;
  final VoidCallback onPressed;

  NavigationButton({required this.image, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF2D2F41)),
        child: Column(
          children: [
            Image.asset(image, scale: 1.3),
            SizedBox(height: 12),
            Text(label, style: TextStyle(color: Colors.white, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
