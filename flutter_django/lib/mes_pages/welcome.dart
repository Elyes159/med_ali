import 'package:flutter/material.dart';
import 'package:flutter_django/login,register/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

Future<void> logout() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('token');

  if (token != null) {
    final response = await http.post(
      Uri.parse(
          'http://192.168.1.17:8000/logout/'), // Remplacez l'URL par l'URL réelle de votre API de déconnexion
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      print('Logout successful: ${response.body}');
    } else {
      print('Logout failed: ${response.body}');
    }
  }

  // Supprimer le token lors de la déconnexion
  prefs.remove('token');

  // Rediriger vers la page de connexion
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Center(
          child: ElevatedButton(
            onPressed: () {
              // Appel de la fonction de déconnexion
              logout();
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => LoginPage()));
            },
            child: Text('Logout'),
          ),
        ),
      ),
    );
  }
}
