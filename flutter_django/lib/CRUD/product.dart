import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class Product {
  final int id;
  final String name;
  final String description;
  final String price;

  Product(
      {required this.name,
      required this.description,
      required this.price,
      required this.id});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'],
      description: json['description'].toString(),
      price: json['price'],
      id: json['id'],
    );
  }
}

class ProductList extends StatefulWidget {
  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  List<Product> products = [];

  Future<void> fetchProducts() async {
    final response =
        await http.get(Uri.parse('http://192.168.1.17:8000/products/'));

    if (response.statusCode == 200) {
      // Si la requête est réussie (status code 200),
      // convertissez la réponse JSON en une liste de produits
      List<dynamic> data = jsonDecode(response.body);
      setState(() {
        products = data.map((item) => Product.fromJson(item)).toList();
      });
    } else {
      // Gérer les erreurs de requête
      throw Exception('Failed to load products');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProducts(); // Appeler la fonction pour récupérer les produits au chargement de la page
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des produits'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('${products[index].id}\n${products[index].name}'),
                  subtitle: Text(
                      '${products[index].description}\n\$${products[index].price}'),
                  trailing: MaterialButton(
                    onPressed: () async {
                      String url =
                          'http://192.168.1.17:8000/delete/${products[index].id}/'; // Remplacez par votre URL de suppression

                      try {
                        var response = await http.delete(
                          Uri.parse(url),
                          headers: {
                            'Content-Type':
                                'application/json', // Spécifie le type de contenu JSON
                          },
                        );

                        if (response.statusCode == 204) {
                          // Réussite : suppression réussie
                          print('Produit supprimé avec succès');
                          // Ajoutez ici des actions à effectuer en cas de réussite
                        } else {
                          // Échec : quelque chose s'est mal passé lors de la suppression
                          print('Échec de la suppression du produit');
                          // Ajoutez ici des actions à effectuer en cas d'échec
                        }
                      } catch (e) {
                        // Gestion des erreurs
                        print('Erreur lors de la suppression du produit : $e');
                        // Ajoutez ici des actions à effectuer en cas d'erreur
                      }
                      setState(() {
                        products.removeAt(index);
                      });
                    },
                    child: Icon(Icons.remove_circle),
                  ),
                );
              },
            ),
          ),
          MaterialButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed("update");
            },
            child: Text("Update"),
          ),
          MaterialButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed("create");
            },
            child: Text("Create"),
          ),
        ],
      ),
    );
  }
}
