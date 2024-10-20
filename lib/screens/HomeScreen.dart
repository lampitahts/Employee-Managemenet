import 'dart:io';
import 'package:employee_management/models/attendance_model.dart';
import 'package:employee_management/screens/Account_screen.dart';
import 'package:employee_management/screens/CompanyScreen.dart';
import 'package:employee_management/screens/UpdateEmployee.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:employee_management/screens/AttendanceScreen.dart';
import 'package:employee_management/screens/ReminderScreen.dart';
import 'package:employee_management/screens/RekapAbsensiScreen.dart';
import 'package:employee_management/screens/TeamCommunicationScreen.dart';
import 'package:employee_management/screens/submissionScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  int _indeksTerpilih = 0;
  File? _gambarProfil;
  late AnimationController _kontrolAnimasi;

  void _pindahItem(int indeks) {
    setState(() {
      _indeksTerpilih = indeks;
    });

    if (indeks == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else if (indeks == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfileSettingsPage()),
      );
    }
  }

  Future<void> _ambilGambarDariGaleri() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? gambar = await _picker.pickImage(source: ImageSource.gallery);

    if (gambar != null) {
      setState(() {
        _gambarProfil = File(gambar.path);
      });
    }
  }

  Future<void> _scanBarcode() async {
    try {
      var result = await BarcodeScanner.scan();

      if (result.rawContent.isNotEmpty) {
        int scannedId = int.parse(result.rawContent);
        var employeeData = listUsers.firstWhere(
            (user) => user['id'] == scannedId,
            orElse: () => {'user_name': 'Unknown', 'designation': 'Unknown'});

        String employeeName = employeeData['user_name'];
        String employeePosition = employeeData['designation'];
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Hasil Pemindaian'),
              content: Text('Nama: $employeeName\nJabatan: $employeePosition'),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AttendanceScreen(
                          barcode: result.rawContent,
                          employeeName: employeeName,
                          employeePosition: employeePosition,
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        );
      } else {
        _tampilkanPesan('Pemindaian tidak menghasilkan data.');
      }
    } catch (e) {
      print(e);
      _tampilkanPesan('Kesalahan saat memindai: $e');
    }
  }

  void _tampilkanPesan(String pesan) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(pesan),
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _kontrolAnimasi = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _mulaiAnimasiPutar();
  }

  @override
  void dispose() {
    _kontrolAnimasi.dispose();
    super.dispose();
  }

  void _mulaiAnimasiPutar() async {
    await _kontrolAnimasi.forward();
    await _kontrolAnimasi.reverse();
    _kontrolAnimasi.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Employee Management',
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'RobotoMono',
              fontWeight: FontWeight.bold),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color.fromARGB(255, 1, 179, 164), Color(0xFF1DE9B6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 10,
        shadowColor: Colors.black.withOpacity(0.5),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF00BFAE), Color(0xFF1DE9B6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontFamily: 'RobotoMono'),
              ),
            ),
            _bangunItemDrawer(Icons.help_outline, 'Bantuan'),
            _bangunItemDrawer(Icons.settings, 'Pengaturan'),
            _bangunItemDrawer(Icons.announcement, 'Pengumuman'),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 167, 231, 167),
              Color.fromARGB(255, 107, 243, 209)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: GestureDetector(
                onTap: _ambilGambarDariGaleri,
                child: Card(
                  elevation: 20,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                    side: BorderSide(color: Colors.teal[600]!, width: 1),
                  ),
                  shadowColor:
                      const Color.fromARGB(255, 57, 61, 61).withOpacity(0.5),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 35,
                          backgroundColor: Colors.grey[300],
                          backgroundImage: _gambarProfil != null
                              ? FileImage(_gambarProfil!)
                              : null,
                          child: _gambarProfil == null
                              ? Icon(Icons.person, size: 35, color: Colors.grey)
                              : null,
                        ),
                        SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Soleh Bin Maksum',
                              style: TextStyle(
                                  color: Colors.teal,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  fontFamily: 'RobotoMono'),
                            ),
                            Text(
                              'Bisdev Business Development',
                              style: TextStyle(
                                  color: const Color.fromARGB(202, 96, 125, 139),
                                  fontFamily: 'RobotoMono'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 8),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                padding: EdgeInsets.all(15),
                children: [
                  _bangunItemGridAnimasi(Icons.fingerprint, 'Absensi', context, _scanBarcode),
                  _bangunItemGridAnimasi(Icons.fact_check_outlined, 'Rekap Absensi', context, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RekapAbsensiScreen(
                          entryTime: 'time',
                          employeeName: 'Nama Karyawan',
                          employeePosition: 'Jabatan Karyawan', attendanceStatusList: [],
                        ),
                      ),
                    );
                  }),
                  _bangunItemGridAnimasi(Icons.airplane_ticket, 'Pengajuan Cuti/Izin', context, () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SubmissionScreen()));
                  }),
                  _bangunItemGridAnimasi(Icons.notification_add, 'Reminder', context, () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ReminderScreen()));
                  }),
                  _bangunItemGridAnimasi(Icons.group, 'Komunikasi Tim', context, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TeamCommunicationScreen()),
                    );
                  }),
                  _bangunItemGridAnimasi(Icons.business, 'Perusahaan', context, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CompanyScreen()),
                    );
                  }),
                  
                  _bangunItemGridAnimasi(Icons.person, 'Update Account', context, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Updateemployee()),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indeksTerpilih,
        backgroundColor: const Color.fromARGB(255, 3, 170, 153),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Akun',
          ),
        ],
        onTap: _pindahItem,
      ),
    );
  }

  Widget _bangunItemDrawer(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.teal),
      title: Text(
        title,
        style: TextStyle(fontFamily: 'RobotoMono'),
      ),
      onTap: () {
        
      },
    );
  }

  Widget _bangunItemGridAnimasi(
      IconData ikon, String label, BuildContext context, VoidCallback onTap) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: AnimatedBuilder(
        animation: _kontrolAnimasi,
        builder: (context, child) {
          double skala = 1 + (_kontrolAnimasi.value * 0.03);

          return Container(
            margin: EdgeInsets.symmetric(vertical: 8.0),
            child: Transform.scale(
              scale: skala,
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(35),
                  side: BorderSide(color: Colors.teal[600]!, width: 1.2),
                ),
                shadowColor:
                    const Color.fromARGB(255, 57, 61, 61).withOpacity(0.5),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(ikon, size: 65, color: Colors.teal[600]),
                      SizedBox(height: 8),
                      Text(label,
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'RobotoMono',
                              color: Colors.teal)),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
