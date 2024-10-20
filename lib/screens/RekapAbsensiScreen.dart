import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:intl/intl.dart'; 

class RekapAbsensiScreen extends StatefulWidget {
  final List<String> attendanceStatusList;
  final String entryTime;
  final String employeeName;
  final String employeePosition;

  RekapAbsensiScreen({
    required this.attendanceStatusList,
    required this.entryTime,
    required this.employeeName,
    required this.employeePosition,
  });

  @override
  _RekapAbsensiScreenState createState() => _RekapAbsensiScreenState();
}

class _RekapAbsensiScreenState extends State<RekapAbsensiScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  List<Map<String, dynamic>> attendanceRecords = [];
  double baseSalary = 4000000;

  // Store the month and year of the attendance records
  String currentMonthYear = DateFormat('MM-yyyy').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 1, end: 1.05).animate(_controller);
    _resetAttendanceRecordsIfNewMonth();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _resetAttendanceRecordsIfNewMonth() {
    String lastMonthYear = attendanceRecords.isNotEmpty 
        ? attendanceRecords[0]["date"].split('-')[1] // Get the month from the last record
        : "";

    if (lastMonthYear != currentMonthYear.split('-')[0]) {
      attendanceRecords.clear(); // Clear records if the month has changed
    }
  }

  void _addAttendanceRecord(String name, String position, String status) {
    // Get the current date
    String date = DateFormat('dd-MM-yyyy').format(DateTime.now());
    
    var existingRecord = attendanceRecords.firstWhere(
      (record) => record["name"] == name && record["position"] == position && record["date"] == date,
      orElse: () => {},
    );

    if (existingRecord.isNotEmpty) {
      if (!existingRecord["attendanceStatus"].contains(status)) {
        existingRecord["attendanceStatus"].add(status);
      }
    } else {
      attendanceRecords.add({
        "name": name,
        "position": position,
        "attendanceStatus": [status],
        "date": date,  // Store the date with the record
      });
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    for (String status in widget.attendanceStatusList) {
      _addAttendanceRecord(widget.employeeName, widget.employeePosition, status);
    }

    final Map<String, double> dataMap = {
      "Present": widget.attendanceStatusList.where((s) => s == 'H').length.toDouble(),
      "Rest": widget.attendanceStatusList.where((s) => s == 'K').length.toDouble(),
      "Re-enter": widget.attendanceStatusList.where((s) => s == 'B').length.toDouble(),
      "Go Home": widget.attendanceStatusList.where((s) => s == 'R').length.toDouble(),
      "Absent": 3,
      "Etc": 15,
    };

    String currentMonth = DateFormat('MMMM yyyy').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: ScaleTransition(
          scale: _animation,
          child: Text(
            'Rekap Absensi',
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 3, 173, 154),
      ),
      body: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        decoration: BoxDecoration(
          color: Colors.teal[100],
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Statistik Kehadiran: $currentMonth',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Waktu Masuk: ${widget.entryTime}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Center(
              child: ScaleTransition(
                scale: _animation,
                child: PieChart(
                  dataMap: dataMap,
                  animationDuration: Duration(milliseconds: 800),
                  chartLegendSpacing: 32,
                  chartRadius: MediaQuery.of(context).size.width / 3.2,
                  colorList: [
                    Colors.green,
                    Colors.orange,
                    Colors.blue,
                    Colors.red,
                    Colors.black,
                    Colors.purple,
                  ],
                  initialAngleInDegree: 0,
                  chartType: ChartType.ring,
                  ringStrokeWidth: 32,
                  centerText: "311 hari",
                  legendOptions: LegendOptions(
                    showLegends: true,
                    legendPosition: LegendPosition.right,
                    showLegendsInRow: false,
                    legendShape: BoxShape.circle,
                    legendTextStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  chartValuesOptions: ChartValuesOptions(
                    showChartValuesInPercentage: true,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: attendanceRecords.length,
                itemBuilder: (context, index) {
                  final record = attendanceRecords[index];
                  return _buildEmployeeCard(
                    record["name"],
                    record["position"],
                    record["attendanceStatus"],
                    record["date"], // Pass the date to the card
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getAttendanceStatusText(String status) {
    switch (status) {
      case 'H':
        return 'Present';
      case 'K':
        return 'Rest';
      case 'B':
        return 'Re-enter';
      case 'R':
        return 'Go Home';
      default:
        return 'Absent';
    }
  }

  Widget _buildEmployeeCard(String name, String position, List<String> attendanceStatuses, String date) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage('assets/profile1.png'),
                  radius: 24,
                ),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      position,
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 4),
                    Text(
                      date, // Display the date
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),
            _buildAttendanceStatusRow(attendanceStatuses),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceStatusRow(List<String> attendanceStatuses) {
    List<Widget> statusWidgets = attendanceStatuses.map((status) {
      Color statusColor;
      String statusText;

      switch (status) {
        case 'H':
          statusColor = Colors.green;
          statusText = 'Present';
          break;
        case 'K':
          statusColor = Colors.orange;
          statusText = 'Rest';
          break;
        case 'B':
          statusColor = Colors.blue;
          statusText = 'Re-enter';
          break;
        case 'R':
          statusColor = Colors.red;
          statusText = 'Go Home';
          break;
        default:
          statusColor = Colors.black;
          statusText = 'Absent';
          break;
      }

      String currentTime = DateFormat('HH:mm').format(DateTime.now());

      return Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: statusColor,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 4),
                Text(statusText, style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            Text(
              currentTime, 
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      );
    }).toList();

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: statusWidgets,
    );
  }
}
