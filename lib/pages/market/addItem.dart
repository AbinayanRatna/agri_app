import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class AddItemPage extends StatefulWidget {
  @override
  _AddItemPageState createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  final _formKey = GlobalKey<FormState>(); // Form key for validation
  final _nameController = TextEditingController();
  final _contactController = TextEditingController();
  final _itemController = TextEditingController();
  final _priceController = TextEditingController();
  final DatabaseReference _database = FirebaseDatabase.instance.ref().child('items');

  String _selectedUnit = 'Piece';
  final List<String> _units = ['Piece', 'Kilogram'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Gradient Background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green.shade300, Colors.green.shade900],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Column(
            children: [
              // App Bar Style Header
              Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Center(
                  child: Text(
                    'Add Item',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey, // Assign form key
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: 'Seller Name',
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.9),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the seller name';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            controller: _contactController,
                            decoration: InputDecoration(
                              labelText: 'Contact Number',
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.9),
                            ),
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a contact number';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            controller: _itemController,
                            decoration: InputDecoration(
                              labelText: 'Item Name',
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.9),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the item name';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            controller: _priceController,
                            decoration: InputDecoration(
                              labelText: 'Price',
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.9),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the price';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10),
                          DropdownButtonFormField<String>(
                            value: _selectedUnit,
                            onChanged: (value) {
                              setState(() {
                                _selectedUnit = value!;
                              });
                            },
                            items: _units
                                .map(
                                  (unit) => DropdownMenuItem(
                                value: unit,
                                child: Text(unit),
                              ),
                            )
                                .toList(),
                            decoration: InputDecoration(
                              labelText: 'Unit',
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.9),
                            ),
                          ),
                          SizedBox(height: 20),
                          Center(
                            child: ElevatedButton(
                              onPressed: () async {
                                // Validate all fields
                                if (_formKey.currentState!.validate()) {
                                  await _database.push().set({
                                    'name': _nameController.text,
                                    'contact': _contactController.text,
                                    'item': _itemController.text,
                                    'price': _priceController.text,
                                    'unit': _selectedUnit,
                                  });

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Item Added Successfully')),
                                  );
                                  Navigator.pop(context);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                                textStyle: TextStyle(fontSize: 18),
                              ),
                              child: Text('Submit'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}