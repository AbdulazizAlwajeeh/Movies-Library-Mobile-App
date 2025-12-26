import 'package:flutter/material.dart';
import 'package:flutter_proj_1/components/item.dart';
import 'package:flutter_proj_1/screens/add_screen.dart';
import '../models/item.dart' as model;
import 'package:provider/provider.dart';
import 'package:flutter_proj_1/providers/item_provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ItemProvider>().fetchItems();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ItemProvider>();

    Widget body;
    if (provider.isLoading) {
      body = const Center(child: CircularProgressIndicator());
    } else if (provider.error != null) {
      body = Center(child: Text('Error: ${provider.error}'));
    } else if (provider.items.isEmpty) {
      body = const Center(child: Text('No items found.'));
    } else {
      body = GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 1 / 2,
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: provider.items.length,
        itemBuilder: (context, index) {
          return Item(item: provider.items[index]);
        },
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[350],
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh), // the icon you want
            onPressed: () {
              provider.fetchItems();
            },
          ),
        ],
        backgroundColor: Colors.amber,
        title: const Text(
          'IMDB',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  AddScreen(newItem: true, item: model.Item.emptyItem()),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Padding(padding: EdgeInsets.all(8.0), child: body),
      ),
    );
  }
}
