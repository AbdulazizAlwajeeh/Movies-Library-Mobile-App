import 'package:flutter/material.dart';
import 'package:flutter_proj_1/screens/add_screen.dart';
import 'package:flutter_proj_1/models/item.dart' as model;
import '../services/item_service.dart';

class Item extends StatelessWidget {
  const Item({
    required this.item,
    required this.onDelete,
    required this.onUpdate,
  });

  final model.Item item;
  final Function onDelete;
  final Function onUpdate;

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
      await ItemService().deleteItem(item.id);
      onDelete();
    }
  }

  Future update(BuildContext context) async {
    final result = await Navigator.push<model.Item?>(
      context,
      MaterialPageRoute(
        builder: (context) => AddScreen(newItem: false, item: item),
      ),
    );
    if (result != null) {
      onUpdate();
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
