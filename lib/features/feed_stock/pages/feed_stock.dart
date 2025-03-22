import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import 'package:gaugyam/core/theme/app_pallete.dart';
import 'all_feed_stock_page.dart'; // Import the new page

class FeedStockPage extends StatefulWidget {
  @override
  _FeedStockPageState createState() => _FeedStockPageState();
}

class _FeedStockPageState extends State<FeedStockPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _supplierController = TextEditingController();
  DateTime? _expiryDate;
  String selectedUnit = 'kg';
  bool isLoading = true;
  List<Map<String, dynamic>> feedStock = [];

  @override
  void initState() {
    super.initState();
    fetchFeedStock();
  }

  Future<void> fetchFeedStock() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    final response = await supabase
        .from('feed_stock')
        .select()
        .eq('user_id', user.id)
        .order('updated_at', ascending: false)
        .limit(5); // Fetch only the latest 5 rows

    if (mounted) {
      setState(() {
        feedStock = response;
        isLoading = false;
      });
    }
  }

  Future<void> addFeedStock() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    final feedName = _nameController.text.trim();
    final quantity = int.tryParse(_quantityController.text.trim()) ?? 0;
    final supplier = _supplierController.text.trim();
    final expiryDate = _expiryDate != null ? DateFormat('yyyy-MM-dd').format(_expiryDate!) : null;

    if (feedName.isEmpty || quantity <= 0) return;

    await supabase.from('feed_stock').insert({
      'user_id': user.id,
      'feed_name': feedName,
      'quantity': quantity,
      'unit': selectedUnit,
      'supplier_name': supplier,
      'expiry_date': expiryDate,
      'updated_at': DateTime.now().toIso8601String(),
    });

    _nameController.clear();
    _quantityController.clear();
    _supplierController.clear();
    setState(() {
      _expiryDate = null;
    });

    fetchFeedStock();
  }

  Future<void> deleteFeedStock(String id) async {
    await supabase.from('feed_stock').delete().eq('id', id);
    fetchFeedStock();
  }

  void _pickExpiryDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
    );
    if (picked != null) {
      setState(() {
        _expiryDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feed Stock Management'),
        actions: [
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AllFeedStockPage()),
              );
            },
          )
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Form Fields
                  _buildFormFields(),

                  SizedBox(height: 20),

                  // Stored Feed Stock (Latest 5)
                  Divider(),
                  Text(
                    'Latest Feed Stock Entries',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppPallete.gradient1),
                  ),
                  SizedBox(height: 10),

                  feedStock.isEmpty
                      ? Text('No stock available', style: TextStyle(fontSize: 16))
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: feedStock.length,
                          itemBuilder: (context, index) {
                            final feed = feedStock[index];
                            return Card(
                              elevation: 2,
                              child: ListTile(
                                title: Text(feed['feed_name'], style: TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Text('${feed['quantity']} ${feed['unit']} | Supplier: ${feed['supplier_name'] ?? 'N/A'} | Expiry: ${feed['expiry_date'] ?? 'N/A'}'),
                                trailing: IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => deleteFeedStock(feed['id']),
                                ),
                              ),
                            );
                          },
                        ),

                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppPallete.gradient1,
                            minimumSize: Size(double.infinity, 50),
                          ),
                          onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => AllFeedStockPage()),
                              );
                            },
                          child: Text('View All Stock', style: TextStyle(fontSize: 16)),
                        ), 
                ],
              ),
            ),
    );
  }

  Widget _buildFormFields() {
    return Column(
      children: [
        TextField(
          controller: _nameController,
          decoration: InputDecoration(
            labelText: 'Feed Name',
            filled: true,
            fillColor: AppPallete.borderColor,
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 10),

        TextField(
          controller: _quantityController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Quantity',
            filled: true,
            fillColor: AppPallete.borderColor,
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 10),

        TextField(
          controller: _supplierController,
          decoration: InputDecoration(
            labelText: 'Supplier Name',
            filled: true,
            fillColor: AppPallete.borderColor,
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 10),

        GestureDetector(
          onTap: _pickExpiryDate,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            decoration: BoxDecoration(
              color: AppPallete.borderColor,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.grey),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _expiryDate == null ? 'Select Expiry Date' : DateFormat('yyyy-MM-dd').format(_expiryDate!),
                  style: TextStyle(fontSize: 16),
                ),
                Icon(Icons.calendar_today, color: Colors.blueGrey),
              ],
            ),
          ),
        ),
        SizedBox(height: 10),

        DropdownButtonFormField<String>(
          value: selectedUnit,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppPallete.borderColor,
            border: OutlineInputBorder(),
          ),
          items: ['kg', 'liters', 'bags']
              .map((unit) => DropdownMenuItem(value: unit, child: Text(unit)))
              .toList(),
          onChanged: (value) => setState(() => selectedUnit = value!),
        ),
        SizedBox(height: 15),

        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppPallete.gradient1,
            minimumSize: Size(double.infinity, 50),
          ),
          onPressed: addFeedStock,
          child: Text('Add Feed Stock', style: TextStyle(fontSize: 16)),
        ),
      ],
    );
  }
}
