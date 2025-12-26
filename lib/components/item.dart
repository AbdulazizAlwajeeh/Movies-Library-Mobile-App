import 'package:flutter/material.dart';
import 'package:flutter_proj_1/screens/add_screen.dart';
import 'package:flutter_proj_1/models/item.dart' as model;
import 'package:provider/provider.dart';
import 'package:flutter_proj_1/providers/item_provider.dart';

class Item extends StatelessWidget {
  const Item({required this.item});

  final model.Item item;

  Future delete(BuildContext context) async {
    final confirmed =
        await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Confirm Delete'),
              content: const Text('Are you sure you want to delete this?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text(
                    'Delete',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            );
          },
        ) ??
        false;
    if (confirmed) {
      if (context.mounted) context.read<ItemProvider>().deleteItem(item.id!);
    }
  }

  Future update(BuildContext context) async {
    final result = await Navigator.push<model.Item?>(
      context,
      MaterialPageRoute(
        builder: (context) => AddScreen(newItem: false, item: item),
      ),
    );
    if (result != null && result != item) {
      if (context.mounted) context.read<ItemProvider>().updateItem(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      padding: EdgeInsets.all(10),
      color: Colors.white,
      child: Column(
        children: [
          Image.network(
            item.image,
            height: 185,
            width: double.infinity,
            fit: BoxFit.contain,
          ),
          Text(
            item.title,
            style: TextStyle(fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            item.description,
            style: TextStyle(color: Colors.grey),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[400],
                    iconColor: Colors.white,
                  ),
                  onPressed: () {
                    delete(context);
                  },
                  child: const Icon(Icons.delete_forever),
                ),
              ),
              SizedBox(width: 5),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                  ),
                  onPressed: () {
                    update(context);
                  },
                  child: const Icon(Icons.edit_note),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
