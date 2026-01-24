import 'package:flutter/material.dart';
import 'package:flutter_proj_1/providers/item_provider.dart';
import 'package:flutter_proj_1/screens/home_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(create: (_) => ItemProvider(), child: IMDB()));
}

class IMDB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomeScreen());
  }
}
