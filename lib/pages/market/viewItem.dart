import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class ViewItemsPage extends StatefulWidget {
  @override
  _ViewItemsPageState createState() => _ViewItemsPageState();
}

class _ViewItemsPageState extends State<ViewItemsPage> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref().child('items');
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

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
            crossAxisAlignment: CrossAxisAlignment.start, // Align elements tightly
            children: [
              // Positioned Header
              Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Center(
                  child: Text(
                    'Items for Sale',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              // Search Bar
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0), // No bottom padding
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.toLowerCase();
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search items...',
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              // Items List
              Expanded(
                child: StreamBuilder(
                  stream: _database.onValue,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError || !snapshot.hasData || snapshot.data!.snapshot.value == null) {
                      return Center(
                        child: Text(
                          'No items available',
                          style: TextStyle(fontSize: 18, color: Colors.white70),
                        ),
                      );
                    }

                    final Map items = (snapshot.data!.snapshot.value as Map);
                    final filteredItems = items.entries
                        .where((entry) {
                      final data = entry.value as Map;
                      final itemName = data['item'].toLowerCase();
                      return itemName.contains(_searchQuery);
                    })
                        .map((entry) {
                      final data = entry.value as Map;
                      return {
                        'name': data['name'],
                        'contact': data['contact'],
                        'item': data['item'],
                        'price': double.tryParse(data['price']) ?? 0.00,
                        'unit': data['unit'],
                      };
                    })
                        .toList();

                    // Sort the filtered items by price in ascending order
                    filteredItems.sort((a, b) => a['price'].compareTo(b['price']));

                    final itemList = filteredItems.map((data) {
                      return Card(
                        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        color: Colors.white.withOpacity(0.9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          leading: CircleAvatar(
                            backgroundColor: Colors.green.shade700,
                            child: Text(
                              data['name'][0].toUpperCase(),
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Text(
                            data['item'],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Seller: ${data['name']}',
                                style: TextStyle(fontSize: 14, color: Colors.black54),
                              ),
                              Text(
                                'Contact: ${data['contact']}',
                                style: TextStyle(fontSize: 14, color: Colors.black54),
                              ),
                              Text(
                                'Price: Rs.${data['price'].toStringAsFixed(2)} / ${data['unit']}',
                                style: TextStyle(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList();

                    return ListView(children: itemList);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}