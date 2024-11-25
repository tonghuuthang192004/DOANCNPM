class AlarmInfo {
  int id;
  String title;
  DateTime alarmDateTime;
  bool isPending;
  int gradientColorIndex;

  AlarmInfo({
    required this.id,
    required this.title,
    required this.alarmDateTime,
    required this.isPending,
    required this.gradientColorIndex,
  });
}
