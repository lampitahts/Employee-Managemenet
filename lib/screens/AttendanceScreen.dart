import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:employee_management/screens/RekapAbsensiScreen.dart';

class AttendanceScreen extends StatefulWidget {
  final String barcode;
  final String employeeName; 
  final String employeePosition;

  AttendanceScreen({
    required this.barcode,
    required this.employeeName,
    required this.employeePosition,
  });

  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  List<String> _statusAbsensiList = [];
  String? _statusAbsensi;
  TimeOfDay? _checkInTime;
  TimeOfDay? _checkOutTime;
  TimeOfDay? _breakTime;
  TimeOfDay? _returnTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE0F7FA),
      appBar: AppBar(
        title: Text(
          'Manajemen Absensi',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'RobotoMono',
            fontWeight: FontWeight.bold,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF00BFAE), Color(0xFF1DE9B6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 10,
        shadowColor: Colors.black.withOpacity(0.4),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildProfileCard(),
            SizedBox(height: 15),
            Text(
              'Scanned Barcode: ${widget.barcode}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 15),
            _buildAttendanceOptions(),
            SizedBox(height: 15),
            _buildAttendanceTimes(),
            SizedBox(height: 15), 
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF00BFAE), Color(0xFF1DE9B6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: Offset(5, 5),
            blurRadius: 15,
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceOptions() {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF00796B),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: Offset(5, 5),
            blurRadius: 15,
          ),
        ],
      ),
      padding: EdgeInsets.all(15.0),
      child: Column(
        children: [
          Text(
            'Absensi',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildAttendanceRadio('Present', 'H', const Color.fromARGB(255, 66, 250, 161)),              
              _buildAttendanceRadio('Rest', 'K', const Color.fromARGB(255, 252, 168, 59)),
              _buildAttendanceRadio('Re-enter', 'B', const Color.fromARGB(255, 62, 194, 255)),
              _buildAttendanceRadio('GO-Home', 'R', const Color.fromARGB(255, 255, 81, 81)),
            ],
          ),
        ],
      ),
    );
  }

  void _onAttendanceChanged(String newValue) {
    setState(() {
      if (!_statusAbsensiList.contains(newValue)) {
        _statusAbsensiList.add(newValue); // Tambah status baru jika belum ada
      }
      _statusAbsensi = newValue; // Update status saat ini

      // Set waktu sesuai dengan status yang dipilih
      if (newValue == 'H') {
        _checkInTime = TimeOfDay.now();
      } else if (newValue == 'K') {
        _breakTime = TimeOfDay.now();
      } else if (newValue == 'B') {
        _returnTime = TimeOfDay.now();
      } else if (newValue == 'R') {
        _checkOutTime = TimeOfDay.now();
      }
    });
  }

  Widget _buildAttendanceRadio(String label, String value, Color color) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [color.withOpacity(0.6), color],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                offset: Offset(4, 4),
                blurRadius: 10,
              ),
            ],
          ),
          child: Radio<String>(
            value: value,
            groupValue: _statusAbsensi,
            activeColor: Colors.white,
            onChanged: (String? newValue) {
              _onAttendanceChanged(newValue!); 
            },
          ),
        ),
        SizedBox(height: 15),
        Text(
          label,
          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildAttendanceTimes() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
          children: [
            _buildAttendanceInfo(
                Icons.login, 
                'Jam Masuk', 
                _statusAbsensi == 'H' ? _checkInTime : null, 
                Colors.orange, 
                (newTime) {
              setState(() {
                _checkInTime = newTime;
              });
            }),
            _buildAttendanceInfo(
                Icons.restaurant_menu, 
                'Istirahat', 
                _statusAbsensi == 'K' ? _breakTime : null, 
                Colors.green, 
                (newTime) {
              setState(() {
                _breakTime = newTime;
              });
            }),
            _buildAttendanceInfo(
                Icons.play_arrow, 
                'Masuk Kembali', 
                _statusAbsensi == 'B' ? _returnTime : null, 
                Colors.green, 
                (newTime) {
              setState(() {
                _returnTime = newTime;
              });
            }),
            _buildAttendanceInfo(
                Icons.logout, 
                'Jam Pulang', 
                _statusAbsensi == '' ? _checkOutTime : null, 
                Colors.grey, 
                (newTime) {
              setState(() {
                _checkOutTime = newTime;
              });
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceInfo(IconData icon, String label, TimeOfDay? time, Color color, ValueChanged<TimeOfDay?> onTimeSelected) {
    return GestureDetector(
      onTap: () async {
        TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: time ?? TimeOfDay.now(),
        );
        if (pickedTime != null) {
          onTimeSelected(pickedTime);
        }
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        elevation: 8,
        shadowColor: Colors.black26,
        child: Padding(
          padding: const EdgeInsets.all(20.0), 
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 28, color: color),
              SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14), 
              ),
              Spacer(),
              Text(
                time != null ? time.format(context) : '---/---',
                style: TextStyle(fontSize: 14), 
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: () {
        String entryTime = DateFormat('yyyy/MM/dd').format(DateTime.now());
        
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RekapAbsensiScreen(
              attendanceStatusList: _statusAbsensiList, 
              entryTime: entryTime,
              employeeName: widget.employeeName,
              employeePosition: widget.employeePosition,
            ),
          ),
        );
        print("Attendance submitted!");
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF00796B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
      ),
      child: Text(
        'Kirim Absensi',
        style: TextStyle(
          fontFamily: 'RobotoMono',
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}

