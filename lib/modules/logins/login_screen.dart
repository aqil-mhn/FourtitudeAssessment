import 'package:flutter/material.dart';
import 'package:fourtitude_assessment/configs/app_theme.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final appTheme = Provider.of<AppTheme>(context);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 243, 241),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  // hintText: "Username",
                  labelText: "Username",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)
                  )
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                obscureText: true,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)
                  )
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}