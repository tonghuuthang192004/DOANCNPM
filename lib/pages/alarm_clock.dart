import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';
import 'dart:convert';
import 'stopWatch_clock.dart';
import '../provider/provider.dart';
import 'package:provider/provider.dart';

class Alarm {
  DateTime time;
  bool isEnabled;
  String note; // New field for note

  Alarm(this.time, this.isEnabled, {this.note = ''}); // Note is optional, default is empty string

  Map<String, dynamic> toJson() => {
    'time': time.toIso8601String(),
    'isEnabled': isEnabled,
    'note': note, // Include note in the JSON representation
  };

  static Alarm fromJson(Map<String, dynamic> json) =>
      Alarm(
        DateTime.parse(json['time']),
        json['isEnabled'],
        note: json['note'] ?? '', // Handle note
      );
}
class AlarmScreen extends StatefulWidget {
  @override
  _AlarmScreenState createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  List<Alarm> _alarmTimes = [];
  Timer? _timer;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _loadAlarmTimes();
    _startCheckingAlarm();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _loadAlarmTimes() async {
    final prefs = await SharedPreferences.getInstance();
    final alarmData = prefs.getString('alarm_times');
    if (alarmData != null) {
      final alarmList = (jsonDecode(alarmData) as List)
          .map((item) => Alarm.fromJson(Map<String, dynamic>.from(item)))
          .toList();
      setState(() {
        _alarmTimes = alarmList;
      });
    }
  }

  Future<void> _saveAlarmTimes() async {
    final prefs = await SharedPreferences.getInstance();
    final alarmData = _alarmTimes.map((alarm) => alarm.toJson()).toList();
    await prefs.setString('alarm_times', jsonEncode(alarmData));
  }
  void _startCheckingAlarm() {
    _timer = Timer.periodic(Duration(milliseconds: 500), (timer) {
      final now = DateTime.now();
      for (var alarm in _alarmTimes) {
        if (alarm.isEnabled &&
            now.isAfter(alarm.time) &&
            now.difference(alarm.time).inSeconds < 1) {
          _playAlarmSound();
          _showAlarmNotification(alarm.time);
          _removeAlarm(alarm);
          break;
        }
      }
    });
  }

  void _playAlarmSound() async {
    await _audioPlayer.play(AssetSource('audio/aaa.mp3'));
  }

  void _showAlarmNotification(DateTime alarmTime) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFF2D2F41),
        title: Text(
          'Báo thức!',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Đến giờ ${alarmTime.hour}:${alarmTime.minute.toString().padLeft(2, '0')} rồi!',
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


  Future<void> _addAlarm() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) {
      final now = DateTime.now();
      final alarmTime = DateTime(now.year, now.month, now.day, time.hour, time.minute);

      // Show a dialog for adding a note
      String? note = await _showNoteDialog();

      if (note != null && note.isNotEmpty) {
        if (!_alarmTimes.any((alarm) => alarm.time == alarmTime)) {
          setState(() {
            _alarmTimes.add(Alarm(alarmTime, true, note: note));
            _alarmTimes.sort((a, b) => a.time.compareTo(b.time));
          });
          await _saveAlarmTimes();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Khung giờ này đã được thêm trước đó!')),
          );
        }
      }
    }
  }

  Future<String?> _showNoteDialog() async {
    TextEditingController _controller = TextEditingController();

    return await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF2D2F41),
          title: Text(
            'Thêm ghi chú',
            style: TextStyle(color: Colors.white),
          ),
          content: TextField(
            controller: _controller,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Nhập ghi chú cho báo thức',
              hintStyle: TextStyle(color: Colors.grey),
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(_controller.text);
              },
              child: Text(
                'Lưu',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _removeAlarm(Alarm alarm) async {
    setState(() {
      _alarmTimes.remove(alarm);
    });
    await _saveAlarmTimes();
  }
  Future<void> _confirmDelete(Alarm alarm) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFF2D2F41),
        title: Text(
          'Xác nhận',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Bạn có chắc chắn muốn xóa báo thức này không?',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), // Không xóa
            child: Text(
              'Không',
              style: TextStyle(color: Colors.blue),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true), // Xóa
            child: Text(
              'Có',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      _removeAlarm(alarm);
    }
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
                Container(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF2D2F41)),
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/clock_icon.png',
                          scale: 1.3,
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Clock',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF2D2F41)),
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/alarm_icon.png',
                          scale: 1.3,
                        ),
                        SizedBox(height: 12),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Alarm',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ),
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
                    style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF2D2F41)),
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/stopwatch_icon.png',
                          scale: 1.3,
                        ),
                        SizedBox(height: 12),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Stop Watch',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ),
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
            Expanded(
              child: Container(
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
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 32),
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Alarm",
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
                      ),
                    ),
                    Flexible(
                      flex: 8,
                      child: Column(
                        children: [
                          ElevatedButton(
                            onPressed: _addAlarm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                            ),
                            child: Text('Thêm khung giờ báo thức'),
                          ),
                          SizedBox(height: 20),
                          // Expanded(
                          //
                          //   child: _alarmTimes.isEmpty
                          //       ? Center(
                          //     child: Text(
                          //       'Chưa có khung giờ báo thức nào.',
                          //       style: TextStyle(color: Colors.white),
                          //     ),
                          //   )
                          //
                          //       : ListView.builder(
                          //     itemCount: _alarmTimes.length,
                          //     itemBuilder: (context, index) {
                          //       final alarm = _alarmTimes[index];
                          //       return ListTile(
                          //         title: Text(
                          //           '${alarm.time.hour}:${alarm.time.minute.toString().padLeft(2, '0')}',
                          //           style: TextStyle(
                          //               color: Colors.white, fontSize: 18),
                          //         ),
                          //         trailing: Row(
                          //           mainAxisSize: MainAxisSize.min,
                          //           children: [
                          //
                          //             Switch(
                          //               value: alarm.isEnabled,
                          //               onChanged: (value) {
                          //                 setState(() {
                          //                   alarm.isEnabled = value;
                          //                 });
                          //                 _saveAlarmTimes();
                          //               },
                          //
                          //               activeColor: Colors.yellow, // Màu của nút khi bật
                          //               activeTrackColor: Colors.blue,
                          //             ),
                          //             IconButton(
                          //               icon: Icon(Icons.delete, color: Colors.red),
                          //               onPressed: () => _removeAlarm(alarm),
                          //             ),
                          //           ],
                          //         ),
                          //       );
                          //     },
                          //   ),
                          // ),
                          Expanded(
                            child: _alarmTimes.isEmpty
                                ? Center(
                              child: Text(
                                'Chưa có khung giờ báo thức nào.',
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                                : ListView.builder(
                              itemCount: _alarmTimes.length,
                              itemBuilder: (context, index) {
                                final alarm = _alarmTimes[index];
                                return
                                   Container(
                                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[850],
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.blueAccent,
                                        width: 2,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black54,
                                          offset: Offset(4, 4),
                                          blurRadius: 8,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                    child:
                                    Container(
                                      child: Row(

                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${alarm.time.hour}:${alarm.time.minute.toString().padLeft(2, '0')}',
                                                style: TextStyle(color: Colors.white, fontSize: 18),
                                              ),
                                              if (alarm.note.isNotEmpty) // Show the note if it's not empty
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 8.0),
                                                  child: Text(
                                                    alarm.note,
                                                    style: TextStyle(color: Colors.white, fontSize: 14),
                                                  ),
                                                ),
                                            ],
                                          ),
                                          SizedBox(width: 25,),

                                          Container(
                                            // margin: EdgeInsets.only(left: 2.0),
                                            child: Expanded(
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    child: Switch(
                                                      value: alarm.isEnabled,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          alarm.isEnabled = value;
                                                        });
                                                        _saveAlarmTimes();
                                                      },
                                                      activeColor: Colors.grey,
                                                      activeTrackColor: Colors.yellow,
                                                    ),
                                                  ),
                                                  SizedBox(width: 9,),

                                                  Expanded(
                                                    child: IconButton(
                                                      icon: Icon(Icons.delete, color: Colors.red),
                                                      onPressed: () => _confirmDelete(alarm),
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

                              },
                            ),
                          )


                        ],
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
