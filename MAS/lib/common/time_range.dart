// Getting the Time Range For Doctors
List<dynamic> generateTimeRange(String timeRange) {
  List appointmentTime = [];
  List<String> timeSlot = timeRange.split("-");
  DateTime start = DateTime.parse('2000-01-01T${timeSlot.first}:00Z');
  DateTime end = DateTime.parse('2000-01-01T${timeSlot.last}:00Z');
  Duration interval = const Duration(minutes: 20);
  while (start.isBefore(end) || start.isAtSameMomentAs(end)) {
    String formattedTime =
        '${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')}';
    start = start.add(interval);
    if (formattedTime.compareTo("12") <= 0) {
      formattedTime = formattedTime + "AM";
    } else {
      formattedTime += "PM";
    }
    appointmentTime.add(formattedTime);
  }
  return appointmentTime;
}
