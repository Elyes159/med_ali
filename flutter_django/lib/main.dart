import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_django/CRUD/create.dart';
import 'package:flutter_django/CRUD/product.dart';
import 'package:flutter_django/CRUD/update.dart';
import 'package:flutter_django/login,register/login.dart';
import 'package:flutter_django/mes_pages/welcome.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

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

Future<int> loginUser(BuildContext context) async {
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
    // Connexion réussie
    print('Login successful : ${response.body}');

    // Sauvegarder le token pour une utilisation ultérieure
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', csrfToken);
  } else if (response.statusCode == 400) {
    // Échec de la connexion
    print('Login failed: ${response.body}');
  } else {
    // Erreur inattendue
    print('Unexpected error: ${response.statusCode}');
  }
  return response.statusCode;
}

Future<bool> isUserLoggedIn() async {
  final prefs = await SharedPreferences.getInstance();
  final String? authToken = prefs.getString('token');

  return authToken != null;
}

class _MyAppState extends State<MyApp> {
  late Future<int> _loginStatus = loginUser(context);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder<int>(
        future: _loginStatus,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Si la future est en cours d'exécution, affichez un indicateur de chargement
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            // En cas d'erreur, affichez un message d'erreur
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.data == 401) {
            loginUser(context);
            return Welcome();
          } else {
            return LoginPage();
          }
        },
      ),
      routes: {
        'update': (context) => Update(),
        'create': (context) => Create(),
        'login': (context) => LoginPage(),
        'product': (context) => ProductList(),
      },
    );
  }
}
