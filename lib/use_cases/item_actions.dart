import 'package:flutter/material.dart';
import 'package:flutter_proj_1/models/item.dart' as model;
import 'package:provider/provider.dart';
import '../providers/item_provider.dart';
import '../screens/add_screen.dart';
import '../screens/login_screen.dart';

typedef ItemAction =
    Future<void> Function(BuildContext context, model.Item item);

enum ItemActionType { delete, update, login }

class ItemActions {
  const ItemActions();

  Future<void> delete(BuildContext context, model.Item item) async {
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

  Future<void> update(BuildContext context, model.Item item) async {
    await Navigator.push<model.Item?>(
      context,
      MaterialPageRoute(
        builder: (context) => AddScreen(newItem: false, item: item),
      ),
    );
  }

  Future<void> login(BuildContext context, model.Item item) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }
}
