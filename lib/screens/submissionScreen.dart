import 'package:flutter/material.dart';

class SubmissionScreen extends StatefulWidget {
  @override
  _SubmissionScreenState createState() => _SubmissionScreenState();
}

class _SubmissionScreenState extends State<SubmissionScreen> {
  DateTime selectedDate = DateTime.now();
  int selectedTabIndex = -1;
  String selectedLeaveType = '';
  bool isRequestSubmitted = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        isRequestSubmitted = false; // Reset the request status
      });
    }
  }

  void _onTabSelected(int index) {
    setState(() {
      selectedTabIndex = index;
      selectedDate = DateTime.now(); // Reset to current date
      isRequestSubmitted = false; // Reset request status on tab change
      selectedLeaveType = ''; // Reset leave type on tab change
    });
  }

  void _submitRequest() {
    // Logic to submit request to HR or manager
    setState(() {
      isRequestSubmitted = true;
    });
    // Ideally, send this request to your backend or API
    // For example: sendLeaveRequest(selectedLeaveType, selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pengajuan Cuti/Izin', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 59, 193, 211),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.lightBlueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            // Tab Section
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (int i = 0; i < 5; i++)
                    GestureDetector(
                      onTap: () => _onTabSelected(i),
                      child: _buildTabItem(context, ['Absensi', 'Cuti', 'Izin', 'Sakit', 'Lembur'][i], isSelected: selectedTabIndex == i),
                    ),
                ],
              ),
            ),
            Divider(),
            
            if (selectedTabIndex >= 0) 
              GestureDetector(
                onTap: () => _selectDate(context),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Column(
                    children: [
                      Text(
                        '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(7, (index) {
                          DateTime date = DateTime.now().add(Duration(days: index - 3)); // Adjust to show week
                          return _buildDateCircle(date, selectedDate: selectedDate);
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Column(
                children: [
                  Image.asset(
                    'img/landscape_image.png',
                    width: double.infinity, 
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    // Show leave type selection only for "Cuti" tab
                    if (selectedTabIndex == 1 && !isRequestSubmitted) 
                      DropdownButton<String>(
                        hint: Text('Pilih Jenis Cuti'),
                        value: selectedLeaveType.isEmpty ? null : selectedLeaveType,
                        items: <String>['Cuti Tahunan', 'Cuti Bulanan', 'Cuti Harian'].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedLeaveType = newValue!;
                          });
                        },
                      ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: (selectedTabIndex == 1 && selectedLeaveType.isEmpty) ? null : _submitRequest,
                      child: Text('Ajukan'),
                    ),
                    SizedBox(height: 20),
                    // Display confirmation message in a styled container
                    if (isRequestSubmitted)
                      Container(
                        padding: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.green[100],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.green, width: 1),
                        ),
                        child: Text(
                          'Permintaan ${selectedTabIndex == 1 ? selectedLeaveType : "Absensi"} pada ${selectedDate.day}/${selectedDate.month}/${selectedDate.year} telah diajukan.',
                          style: TextStyle(color: Colors.green),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    if (!isRequestSubmitted && ((selectedTabIndex == 1 && selectedLeaveType.isEmpty)))
                      Text(
                        'Silakan pilih tanggal dan jenis izin sebelum mengajukan.',
                        style: TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
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

  Widget _buildTabItem(BuildContext context, String title, {bool isSelected = false}) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.green : const Color.fromARGB(255, 99, 97, 97),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        if (isSelected)
          Container(
            margin: EdgeInsets.only(top: 4),
            height: 3,
            width: 20,
            color: Colors.green,
          ),
      ],
    );
  }

  Widget _buildDateCircle(DateTime date, {required DateTime selectedDate}) {
    bool isToday = date.day == DateTime.now().day && date.month == DateTime.now().month && date.year == DateTime.now().year;
    bool isSelected = date.day == selectedDate.day && date.month == selectedDate.month && date.year == selectedDate.year;

    return Column(
      children: [
        Text(date.weekday.toString(), style: TextStyle(color: isSelected ? Colors.green : Colors.grey)),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: isSelected ? Colors.green : (isToday ? const Color.fromARGB(255, 159, 205, 240) : Colors.grey[200]),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 20,
            backgroundColor: Colors.transparent,
            child: Text(
              '${date.day}',
              style: TextStyle(color: isSelected || isToday ? Colors.white : Colors.black),
            ),
          ),
        ),
      ],
    );
  }
}
