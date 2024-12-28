import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class ItemPage extends StatefulWidget {
  @override
  _ItemPageState createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref().child('items');
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _contactController = TextEditingController();
  final _itemController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();
  String _selectedUnit = 'Piece';
  final List<String> _units = ['Piece', 'Kilogram'];

  User? _user;
  List<Map<String, dynamic>> _items = [];
  Map<String, dynamic>? _currentItem;

  @override
  void initState() {
    super.initState();
    _fetchUser();
  }

  Future<void> _fetchUser() async {
    setState(() {
      _user = _auth.currentUser;
    });

    if (_user != null) {
      _fetchItems();
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  Future<void> _fetchItems() async {
    if (_user == null) return;

    _database.orderByChild('userId').equalTo(_user!.uid).onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>? ?? {};
      setState(() {
        _items = data.entries.map((entry) {
          final value = Map<String, dynamic>.from(entry.value as Map);
          return {'key': entry.key, ...value};
        }).toList();
      });
    });
  }

  void _clearForm() {
    _nameController.clear();
    _contactController.clear();
    _itemController.clear();
    _priceController.clear();
    _quantityController.clear();
    _selectedUnit = 'Piece';
    _currentItem = null;
  }

  Future<void> _saveItem() async {
    if (_user == null) return;

    if (_formKey.currentState!.validate()) {
      final itemData = {
        'name': _nameController.text,
        'contact': _contactController.text,
        'item': _itemController.text,
        'price': _priceController.text,
        'quantity': _quantityController.text,
        'unit': _selectedUnit,
        'userId': _user!.uid,
      };

      if (_currentItem == null) {
        await _database.push().set(itemData);
      } else {
        await _database.child(_currentItem!['key']).set(itemData);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_currentItem == null ? 'Item Added' : 'Item Updated')),
      );

      _clearForm();
      Navigator.pop(context);
    }
  }

  void _setForm(Map<String, dynamic> item) {
    _nameController.text = item['name'] ?? '';
    _contactController.text = item['contact'] ?? '';
    _itemController.text = item['item'] ?? '';
    _priceController.text = item['price'] ?? '';
    _quantityController.text = item['quantity'] ?? '';
    _selectedUnit = item['unit'] ?? 'Piece';
    _currentItem = item;
  }

  Future<void> _deleteItem(String key) async {
    await _database.child(key).remove();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Item Deleted')),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Gradient Background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade300, Colors.blue.shade900],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Header
                  Text(
                    'Manage Your Items',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Add, edit, or remove items from your list.',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  // Item List
                  Expanded(
                    child: _items.isEmpty
                        ? Center(
                      child: Text(
                        'No items found. Add your first item!',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white70,
                        ),
                      ),
                    )
                        : ListView.builder(
                      itemCount: _items.length,
                      itemBuilder: (context, index) {
                        final item = _items[index];
                        return Card(
                          color: Colors.white,
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            title: Text(item['item'], style: TextStyle(fontSize: 20)),
                            subtitle: Text(
                              'Price: ${item['price']}\nUnit: ${item['unit']}\nQuantity: ${item['quantity']}',
                              style: TextStyle(fontSize: 16), // Optional: Adjust the font size if needed
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () {
                                    _setForm(item);
                                    _showFormDialog(context);
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _deleteItem(item['key']),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  // Add Button
                  ElevatedButton.icon(
                    onPressed: () {
                      _clearForm();
                      _showFormDialog(context);
                    },
                    icon: Icon(Icons.add, size: 24),
                    label: Text('Add Item'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                      textStyle: TextStyle(fontSize: 18),
                      backgroundColor: Colors.orange.shade600,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFormDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_currentItem == null ? 'Add Item' : 'Edit Item'),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Seller Name'),
                  validator: (value) =>
                  value == null || value.isEmpty ? 'Enter Seller Name' : null,
                ),
                TextFormField(
                  controller: _contactController,
                  decoration: InputDecoration(labelText: 'Contact Number'),
                  keyboardType: TextInputType.phone,
                  validator: (value) =>
                  value == null || value.isEmpty ? 'Enter Contact Number' : null,
                ),
                TextFormField(
                  controller: _itemController,
                  decoration: InputDecoration(labelText: 'Item Name'),
                  validator: (value) =>
                  value == null || value.isEmpty ? 'Enter Item Name' : null,
                ),
                TextFormField(
                  controller: _priceController,
                  decoration: InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                  value == null || value.isEmpty ? 'Enter Price' : null,
                ),
                TextFormField(
                  controller: _quantityController,
                  decoration: InputDecoration(labelText: 'Available Quantity'),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                  value == null || value.isEmpty ? 'Enter Available Quantity' : null,
                ),
                DropdownButtonFormField<String>(
                  value: _selectedUnit,
                  onChanged: (value) {
                    setState(() {
                      _selectedUnit = value!;
                    });
                  },
                  items: _units
                      .map((unit) => DropdownMenuItem(value: unit, child: Text(unit)))
                      .toList(),
                  decoration: InputDecoration(labelText: 'Unit'),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: _saveItem,
            child: Text('Save'),
          ),
        ],
      ),
    );
  }
}