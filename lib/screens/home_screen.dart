import 'package:flutter/material.dart';
import 'package:flutter_proj_1/components/item.dart';
import 'package:flutter_proj_1/screens/add_screen.dart';
import '../services/item_service.dart';
import '../models/item.dart' as model;

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<model.Item>> itemsList;

  void _refresh() {
    setState(() {
      ItemService().fetchItems();
    });
  }

  Widget buildItems(
    BuildContext context,
    AsyncSnapshot<List<model.Item>> snapshot,
  ) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    } else if (snapshot.hasError) {
      return Center(child: Text('Error: ${snapshot.error}'));
    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return const Center(child: Text('No items found.'));
    } else {
      final items = snapshot.data!;
      return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 1 / 2,
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Item(
            item: item,
            onDelete: () {
              _refresh();
            },
            onUpdate: () {
              _refresh();
            },
          );
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    itemsList = ItemService().fetchItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[350],
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh), // the icon you want
            onPressed: () {
              _refresh();
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
          ).then((result) {
            if (result == true) {
              _refresh();
            }
          });
        },
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: FutureBuilder<List<model.Item>>(
            future: itemsList,
            builder: (context, snapshot) {
              return buildItems(context, snapshot);
            },
          ),
        ),
      ),
    );
  }
}
