import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileSettingsPage extends StatefulWidget {
  @override
  _ProfileSettingsPageState createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends State<ProfileSettingsPage> {
  XFile? _selectedImage;
  final _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employee Account'),
        backgroundColor: Colors.transparent, 
        iconTheme: IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 1, 179, 164), Color(0xFF1DE9B6)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ), toolbarTextStyle: TextTheme(
          titleLarge: TextStyle(color: Colors.white, fontSize: 20), 
        ).bodyMedium, titleTextStyle: TextTheme(
          titleLarge: TextStyle(color: Colors.white, fontSize: 20), 
        ).titleLarge,
      ),
      body: Container(
        color: Color.fromARGB(255, 251, 240, 255),
        child: ListView(
          children: [
            ListTile(
              leading: GestureDetector(
                onTap: () async {
                  await _pickImageFromGallery();
                },
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.blue,
                  child: _selectedImage != null
                      ? Stack(
                          children: [
                            ClipOval(
                              child: Image.network(
                                (_selectedImage!.path),
                                fit: BoxFit.cover,
                                width: 50,
                                height: 60,
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () async {
                                  await _pickImageFromCamera();
                                },
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 8,
                                  child: Icon(
                                    Icons.camera_alt,
                                    size: 13,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Stack(
                          children: [
                            Center(
                              child: Text(
                                'L',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () async {
                                  await _pickImageFromCamera();
                                },
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 10,
                                  child: Icon(
                                    Icons.camera_alt,
                                    size: 15,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Lampita Hts'),
                  Text(
                    'lampita@gmail.com',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              trailing: CircleAvatar(
                backgroundColor: Colors.blue,
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.blue,
                                  child: Text(
                                    'L',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                title: Text('lampita@gmail.com'),
                              ),
                              Divider(),
                              ListTile(
                                leading: Icon(Icons.add),
                                title: Text('Tambahkan Akun'),
                                onTap: () {},
                              ),
                              ListTile(
                                leading: Icon(Icons.manage_accounts),
                                title: Text('Kelola Akun di Perangkat Ini'),
                                onTap: () {
                                  Navigator.pop(context);
                                  _openDeviceSettings();
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5.0),
              ),
              margin: EdgeInsets.all(20.0),
              child: ListTile(
                leading: Icon(Icons.account_circle),
                title: Text('Kelola Akun Google Anda'),
                onTap: () async {
                  const url = 'https://myaccount.google.com';
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
              ),
            ),
           
          
            ListTile(
              leading: Icon(Icons.library_books),
              title: Text('Employee ID'),
            ),
            ListTile(
              leading: Icon(Icons.card_giftcard),
              title: Text('Designition'),
            ),
            ListTile(
              leading: Icon(Icons.abc),
              title: Text('Mobile Number'),
            ),
            ListTile(
              leading: Icon(Icons.abc),
              title: Text('Adress'),
            ),
            
            ListTile(
              leading: Icon(Icons.abc),
              title: Text('Joining Date'),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Setelan'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.help),
              title: Text('Bantuan & masukan'),
            ),
            ListTile(
              leading: Icon(Icons.policy),
              title: Text('Kebijakan Privasi'),
            ),
            ListTile(
              leading: Icon(Icons.policy),
              title: Text('Persyaratan Layanan'),
            ),
            ListTile(
              leading: Icon(Icons.book),
              title: Text('Aplikasi pendidikan'),
            ),
            ListTile(
              leading: Icon(Icons.gamepad),
              title: Text('Game'),
            ),
            ListTile(
              leading: Icon(Icons.store),
              title: Text('Aplikasi'),
            ),
            ListTile(
              leading: Icon(Icons.book),
              title: Text('Buku'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _selectedImage = pickedFile;
    });
  }

  Future<void> _pickImageFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = pickedFile;
      });
    }
  }

  void _openDeviceSettings() async {
    const url = 'package:com.android.settings';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isSliderActive = false;
  double _sliderValue = 0.0;

  Color _calculateBackgroundColor() {
    int value = (_sliderValue * 255).toInt();
    return Color.fromARGB(255, value, 0, value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Container(
        color: _isSliderActive ? _calculateBackgroundColor() : null,
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              title: Text('Enable Slider'),
              value: _isSliderActive,
              onChanged: (bool value) {
                setState(() {
                  _isSliderActive = value;
                });
              },
            ),
            if (_isSliderActive)
              Slider(
                value: _sliderValue,
                min: 0.0,
                max: 1.0,
                onChanged: (value) {
                  setState(() {
                    _sliderValue = value;
                  });
                },
              ),
          ],
        ),
      ),
    );
  }
}
