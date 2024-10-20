
List<Map<String, dynamic>> listUsers = [
  {
    "user_name": 'Aanda S. Vitiello', 
    "email": "Aanda@gmail.com",
    "password": "12345678",
    "designation": 'Direktur Utama', 
    "id": 10112025
  },
  {
    "user_name": 'Amy B. Clay', 
    "email": "Amy@gmail.com",
    "password": "12311156",
    "designation": 'Teknisi', 
    "id": 10222025
  },
  {
    "user_name": 'Brville S. Martin', 
    "email": "Brville@gmail.com",
    "password": "19870876",
    "designation": 'Petugas Teknik', 
    "id": 10332025
  },
  {
    "user_name": 'Bark M Wilkins', 
    "email": "Bark@gmail.com",
    "password": "143509321",
    "designation": 'Wakil Direktur', 
    "id": 10442025
  },
  {
    "user_name": 'Cernestin A Weekes',
    "email": "Cernestin@gmail.com",
    "password": "12976843",
    "designation": 'Wakil Direktur', 
    "id": 10552025
  },
   {
    "user_name": 'Chilip Munoz', 
    "email": "Chilip@gmail.com",
    "password": "09876678",
    "designation": 'Petugas Teknik', 
    "id": 10662025
  },
  ];

  class Employee {
  final String userName;
  final String email;
  final String password;
  final String designation;
  final int id;

  Employee({
    required this.userName,
    required this.email,
    required this.password,
    required this.designation,
    required this.id,
  });
}


class AttendanceRecord {
  final String name;
  final String position;
  final List<String> attendanceStatus;
  final String date;

  AttendanceRecord({
    required this.name,
    required this.position,
    required this.attendanceStatus,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'position': position,
      'attendanceStatus': attendanceStatus.join(','), // Gabungkan status menjadi string
      'date': date,
    };
  }
}
