import 'package:flutter/material.dart';
import 'package:flutter_proj_1/screens/home_screen.dart';

void main() {
  runApp(IMDB());
}

class IMDB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomeScreen());
  }
}
