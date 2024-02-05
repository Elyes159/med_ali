import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> registerUser() async {
    final response = await http.post(
      Uri.parse(
          'http://192.168.1.17:8000/register/'), // Mettez votre URL d'inscription Django ici
      body: {
        'username': usernameController.text,
        'password1': passwordController.text,
        'password2': passwordController.text,
      },
    );

    if (response.statusCode == 200) {
      // L'inscription a réussi
      print('Registration successful');
    } else {
      // L'inscription a échoué
      print('Registration failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register Page'),
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
              onPressed: registerUser,
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
