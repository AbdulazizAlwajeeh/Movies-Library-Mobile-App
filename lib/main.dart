import 'package:flutter/material.dart';
import 'package:flutter_proj_1/providers/item_provider.dart';
import 'package:flutter_proj_1/providers/login_provider.dart';
import 'package:flutter_proj_1/screens/home_screen.dart';
import 'package:flutter_proj_1/screens/login_screen.dart';
import 'package:flutter_proj_1/services/item_service.dart';
import 'package:flutter_proj_1/services/login_service.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  final myBox = await Hive.openBox('myBox');
  final loginService = LoginService(myBox);

  final loginProvider = LoginProvider(service: loginService);
  await loginProvider.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ItemProvider(
            service: ItemService(),
            loginProvider: loginProvider,
          ),
        ),
        ChangeNotifierProvider.value(value: loginProvider),
      ],
      child: IMDB(),
    ),
  );
}

class IMDB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loginProvider = context.watch<LoginProvider>();

    return MaterialApp(
      scaffoldMessengerKey: scaffoldMessengerKey,
      debugShowCheckedModeBanner: false,
      home: loginProvider.isLoggedIn ? HomeScreen() : LoginScreen(),
    );
  }
}
