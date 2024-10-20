import 'package:flutter/material.dart';

class ReminderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE0F7EF), 
      appBar: AppBar(
        title: Text(
          'Employee Management System',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Color(0xFF1DE9B6),
        elevation: 10,
        shadowColor: Colors.black.withOpacity(0.4),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reminder and Notifications',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF00796B)),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildReminderTile(Icons.task, 'Task Notifications', 'You have 3 tasks due today.', context),
                  _buildReminderTile(Icons.calendar_today, 'Upcoming Deadlines', 'Project XYZ deadline is tomorrow.', context),
                  _buildReminderTile(Icons.event, 'Events', 'Team meeting at 3 PM today.', context),
                  _buildReminderTile(Icons.notifications, 'Important Alerts', 'Check your email for urgent updates.', context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReminderTile(IconData icon, String title, String subtitle, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: Offset(5, 5),
            blurRadius: 10,
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Color(0xFF80DEEA), Color(0xFF00ACC1)], 
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: EdgeInsets.all(8),
          child: Icon(icon, color: Colors.white, size: 28),
        ),
        title: Text(
          title,
          style: TextStyle(fontSize: 18, color: Color(0xFF00796B), fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
        onTap: () {
          // Tambahkan fungsi untuk menangani klik di sini
        },
      ),
    );
  }
}
