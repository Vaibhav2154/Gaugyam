import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AllFeedStockPage extends StatefulWidget {
  @override
  _AllFeedStockPageState createState() => _AllFeedStockPageState();
}

class _AllFeedStockPageState extends State<AllFeedStockPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  bool isLoading = true;
  List<Map<String, dynamic>> allFeedStock = [];

  @override
  void initState() {
    super.initState();
    fetchAllFeedStock();
  }

  Future<void> fetchAllFeedStock() async {
    final response = await supabase.from('feed_stock').select().order('updated_at', ascending: false);

    if (mounted) {
      setState(() {
        allFeedStock = response;
        isLoading = false;
      });
    }
  }

  Future<void> deleteFeedStock(String id) async {
    await supabase.from('feed_stock').delete().eq('id', id);
    fetchAllFeedStock();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('All Feed Stock')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : allFeedStock.isEmpty
              ? Center(child: Text('No feed stock available'))
              : Padding(
                  padding: EdgeInsets.all(16.0),
                  child: ListView.builder(
                    itemCount: allFeedStock.length,
                    itemBuilder: (context, index) {
                      final feed = allFeedStock[index];
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
                ),
    );
  }
}
