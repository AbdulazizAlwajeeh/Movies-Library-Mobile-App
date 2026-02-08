import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/item.dart';
import '../providers/item_provider.dart';
import '../providers/login_provider.dart';
import '../screens/login_screen.dart';
import 'item_actions.dart';

Future<void> handleLogout(
  BuildContext context,
  LoginProvider loginProvider,
) async {
  await loginProvider.logout();

  if (!context.mounted) return;

  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (_) => LoginScreen()),
    (route) => false,
  );
}

Widget generateBody(
  BuildContext context,
  ItemProvider provider,
  LoginProvider loginProvider,
) {
  if (provider.isLoading) {
    return const Center(child: CircularProgressIndicator());
  } else if (provider.error != null || provider.items.isEmpty) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          provider.error != null
              ? Text('Error: ${provider.error}')
              : const Center(child: Text('No items found.')),
          ElevatedButton(
            onPressed: () {
              context.read<ItemProvider>().fetchItems();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
            child: Text(
              'Refresh',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  } else {
    const itemActions = ItemActions();
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio:
            MediaQuery.of(context).orientation == Orientation.landscape
            ? 2 / 3
            : 1 / 2,
        crossAxisCount:
            MediaQuery.of(context).orientation == Orientation.landscape ? 4 : 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: provider.items.length,
      itemBuilder: (context, index) {
        return Item(
          actions: {
            ItemActionType.delete: itemActions.delete,
            ItemActionType.update: itemActions.update,
            ItemActionType.login: itemActions.login,
          },
          item: provider.items[index],
          modifiable: loginProvider.isLoggedIn ? true : false,
        );
      },
    );
  }
}

Future<void> handleDialog(
  State state,
  BuildContext context,
  LoginProvider loginProvider,
) async {
  final confirmed =
      await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Confirm Logout'),
            content: const Text('Are you sure you want to logout?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          );
        },
      ) ??
      false;
  if (confirmed) {
    handleLogout(context, loginProvider);
  }
}
