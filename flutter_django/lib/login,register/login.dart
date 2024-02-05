import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_django/mes_pages/welcome.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<String> getCsrfToken() async {
    final response =
        await http.get(Uri.parse('http://192.168.1.17:8000/get-csrf-token/'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['csrf_token'];
    } else {
      throw Exception('Failed to load CSRF token');
    }
  }

  void navigateToWelcomePage(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => Welcome(),
      ),
      (route) => false,
    );
  }

  Future<void> loginUser() async {
    final csrfToken = await getCsrfToken();

    final response = await http.post(
      Uri.parse('http://192.168.1.17:8000/login/'),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'X-CSRFToken': csrfToken,
      },
      body: {
        'username': usernameController.text,
        'password': passwordController.text,
      },
    );

    if (response.statusCode == 200) {
      // Successful login
      print('Login successful : ${response.body}');
      navigateToWelcomePage(context);

      /////
    } else if (response.statusCode == 400) {
      print('Login failed: ${response.body}');

      ///
    } else {
      print('Unexpected error: ${response.statusCode}');
      // You may want to handle other status codes accordingly
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: loginUser,
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
