import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Updateemployee extends StatefulWidget {
  @override
  _UpdateemployeeState createState() => _UpdateemployeeState();
}

class _UpdateemployeeState extends State<Updateemployee> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _joiningDate; // Variable to store joining date
  String? _selectedDesignation; // Variable to store selected designation
  final List<String> _designations = [
    'Software Engineer',
    'Product Manager',
    'Designer',
    'QA Engineer',
    'Business Analyst',
    'HR Manager',
    'Other' // Add more designations as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 1, 117, 98),
                Color.fromARGB(255, 22, 202, 184),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Set Your Employee Details',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Profile Picture with 3D effect
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 15,
                        spreadRadius: 2,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage('assets/profile_picture.png'),
                  ),
                ),
                SizedBox(height: 20),

                // Input Fields with 3D effects
                _buildInputField('Employee ID', Icons.badge),
                _buildJoiningDateField(),
                _buildInputField('Full Name', Icons.person),
                _buildDesignationField(),
                _buildMobileField(),
                _buildInputField('Basic Pay / Day', Icons.money),
                _buildInputField('Address (Optional)', Icons.home),
                _buildInputField('Note (Optional)', Icons.note),

                SizedBox(height: 20),

                // Payment Type Section with better padding and spacing
                Text(
                  'Payment Type:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildPaymentOption('Per Day'),
                    _buildPaymentOption('Monthly'),
                  ],
                ),

                SizedBox(height: 20),

                // Working Days Section with better layout
                Text(
                  'Working Days:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
                      .map((day) => _buildChip(day))
                      .toList(),
                ),

                // Submit Button
                SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 1, 117, 98),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Handle form submission
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Submitting Employee Details...')),
                      );
                      // Add your submission logic here
                    }
                  },
                  child: Text(
                    'Submit',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Method to build input fields with a 3D effect
  Widget _buildInputField(String field, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Color.fromARGB(255, 1, 117, 98), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              spreadRadius: 2,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: TextFormField(
          decoration: InputDecoration(
            labelText: field,
            border: InputBorder.none,
            prefixIcon: Icon(icon, color: Color.fromARGB(255, 1, 117, 98)),
            contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            labelStyle: TextStyle(color: Color.fromARGB(255, 22, 202, 184)),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter $field';
            }
            return null;
          },
        ),
      ),
    );
  }

  // Method to build joining date field
  Widget _buildJoiningDateField() {
    return GestureDetector(
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: _joiningDate ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );
        if (pickedDate != null && pickedDate != _joiningDate) {
          setState(() {
            _joiningDate = pickedDate;
          });
        }
      },
      child: AbsorbPointer(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Color.fromARGB(255, 1, 117, 98), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                spreadRadius: 2,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: TextFormField(
            decoration: InputDecoration(
              labelText: 'Joining Date',
              border: InputBorder.none,
              prefixIcon: Icon(Icons.date_range, color: Color.fromARGB(255, 1, 117, 98)),
              contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              labelStyle: TextStyle(color: Color.fromARGB(255, 22, 202, 184)),
            ),
            readOnly: true,
            controller: TextEditingController(text: _joiningDate == null
                ? ''
                : DateFormat('yyyy-MM-dd').format(_joiningDate!)),
            validator: (value) {
              if (_joiningDate == null) {
                return 'Please select your joining date';
              }
              return null;
            },
          ),
        ),
      ),
    );
  }

  // Method to build designation field
  Widget _buildDesignationField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color.fromARGB(255, 1, 117, 98), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 2,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        ),
        hint: Text('Select Designation'),
        value: _selectedDesignation,
        onChanged: (newValue) {
          setState(() {
            _selectedDesignation = newValue;
          });
        },
        items: _designations.map((designation) {
          return DropdownMenuItem(
            value: designation,
            child: Text(designation),
          );
        }).toList(),
        validator: (value) {
          if (value == null) {
            return 'Please select a designation';
          }
          return null;
        },
      ),
    );
  }

  // Method to build mobile number field
  Widget _buildMobileField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color.fromARGB(255, 1, 117, 98), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 2,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          labelText: 'Mobile Number',
          border: InputBorder.none,
          prefixIcon: Icon(Icons.phone, color: Color.fromARGB(255, 1, 117, 98)),
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          labelStyle: TextStyle(color: Color.fromARGB(255, 22, 202, 184)),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your mobile number';
          }
          return null;
        },
      ),
    );
  }

  // Method to build payment option button
  Widget _buildPaymentOption(String title) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: Color.fromARGB(255, 1, 117, 98)),
        ),
      ),
      onPressed: () {},
      child: Text(
        title,
        style: TextStyle(color: Color.fromARGB(255, 1, 117, 98)),
      ),
    );
  }


  Widget _buildChip(String label) {
    return Chip(
      label: Text(label),
      backgroundColor: Colors.white,
      padding: EdgeInsets.all(8),
      elevation: 3,
      shadowColor: Colors.black.withOpacity(0.2),
      side: BorderSide(color: Color.fromARGB(255, 1, 117, 98)),
    );
  }
}
