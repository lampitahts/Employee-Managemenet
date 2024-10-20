import 'package:flutter/material.dart';
import 'package:employee_management/models/attendance_model.dart'; // Pastikan import model

class CompanyScreen extends StatefulWidget {
  @override
  _CompanyScreenState createState() => _CompanyScreenState();
}

class _CompanyScreenState extends State<CompanyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text('Company Employee Details',
            style: TextStyle(color: Colors.white, fontFamily: 'RobotoMono')),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color.fromARGB(255, 1, 117, 98),
                const Color.fromARGB(255, 22, 202, 184),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: listUsers.length,
        itemBuilder: (context, index) {
          var user = listUsers[index];
          return EmployeeCard(
            name: user['user_name'],
            designation: user['designation'],
            id: user['id'],
          );
        },
      ),
    );
  }
}

class EmployeeCard extends StatelessWidget {
  final String name;
  final String designation;
  final int id;

  EmployeeCard({required this.name, required this.designation, required this.id});

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.rotationZ(-0.1), // Efek 3D rotasi ringan
      child: Card(
        elevation: 8,
        margin: EdgeInsets.symmetric(vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: ListTile(
          leading: CircleAvatar(
            child: Text(name[0], style: TextStyle(fontWeight: FontWeight.bold)),
            backgroundColor: Colors.blue[100],
          ),
          title: Text(
            name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: _getTitleColor(designation),
            ),
          ),
          subtitle: Text(
            designation,
            style: TextStyle(
              fontStyle: FontStyle.italic,
              fontSize: 16,
              color: Colors.blueGrey,
            ),
          ),
          trailing: Text('ID: $id',
              style: TextStyle(
                  color: Colors.blue[800], fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Color _getTitleColor(String designation) {
    switch (designation) {
      case 'Direktur Utama':
      case 'Wakil Direktur':
        return Colors.teal[800]!;
      case 'Teknisi':
      case 'Petugas Teknik':
        return Colors.orange[800]!;
      case 'Petugas Akun':
        return Colors.purple[800]!;
      default:
        return Colors.black;
    }
  }
}
