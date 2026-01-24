import 'package:flutter/material.dart';
import 'package:flutter_proj_1/models/login_result.dart';
import 'package:flutter_proj_1/screens/home_screen.dart';
import 'package:provider/provider.dart';
import '../components/my_text_field.dart';
import '../providers/login_provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();

  String _username = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    final loginProvider = context.watch<LoginProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text('Login', style: TextStyle(fontWeight: FontWeight.w900)),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: EdgeInsetsGeometry.all(15),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    MyTextField(
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Username is required';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        _username = value;
                      },
                      label: 'Username',
                      hint: 'Username',
                    ),
                    MyTextField(
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Password is required';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        _password = value;
                      },
                      label: 'Password',
                      hint: 'Password',
                      obscureText: true,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          FocusScope.of(context).unfocus();

                          final result = await loginProvider.login(
                            _username,
                            _password,
                          );
                          if (!context.mounted) return;
                          if (result == LoginStatus.success) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomeScreen(),
                              ),
                            );
                          } else {
                            final message =
                                result == LoginStatus.invalidCredentials
                                ? 'Wrong '
                                      'Username/Password.'
                                : 'Server Error';
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(message),
                                backgroundColor: Colors.redAccent,
                                duration: Duration(seconds: 3),
                              ),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                      ),
                      child: Text(
                        'Login',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                      child: Text(
                        'Continue as Guest',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (loginProvider.isLoading)
            Positioned.fill(
              child: AbsorbPointer(
                child: Container(
                  color: Colors.black.withAlpha(102),
                  child: const Center(child: CircularProgressIndicator()),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
