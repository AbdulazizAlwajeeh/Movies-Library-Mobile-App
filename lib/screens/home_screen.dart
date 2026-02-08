import 'package:flutter/material.dart';
import 'package:flutter_proj_1/screens/add_screen.dart';
import 'package:flutter_proj_1/screens/login_screen.dart';
import '../constants/colors.dart';
import '../models/item.dart' as model;
import 'package:provider/provider.dart';
import 'package:flutter_proj_1/providers/item_provider.dart';
import 'package:flutter_proj_1/providers/login_provider.dart';
import '../use_cases/home_screen_actions.dart';

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
    final itemProvider = context.watch<ItemProvider>();
    final loginProvider = context.watch<LoginProvider>();

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.grey[350],
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.login),
              color: loginProvider.isLoggedIn ? AppColors.red : AppColors.green,
              onPressed: () {
                !loginProvider.isLoggedIn
                    ? Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      )
                    : handleDialog(this, context, loginProvider);
              },
            ),
          ],
          backgroundColor: AppColors.amber,
          title: const Text(
            'IMDB',
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.amber,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => loginProvider.isLoggedIn
                    ? AddScreen(newItem: true, item: model.Item.emptyItem())
                    : LoginScreen(),
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: RefreshIndicator(
              onRefresh: () async {
                await context.read<ItemProvider>().fetchItems();
              },
              child: generateBody(context, itemProvider, loginProvider),
            ),
          ),
        ),
      ),
    );
  }
}
