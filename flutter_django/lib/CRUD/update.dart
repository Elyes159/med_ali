import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Update extends StatefulWidget {
  @override
  _UpdateState createState() => _UpdateState();
}

class _UpdateState extends State<Update> {
  TextEditingController idController = TextEditingController();
  TextEditingController nomController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  Future<void> updateData() async {
    int id = int.parse(idController.text);
    String nom = nomController.text;
    String description = descriptionController.text;
    String price = priceController.text;

    String url =
        'http://192.168.1.17:8000/update/${id}/'; // Remplacez ceci par l'URL de votre endpoint de mise à jour sur le serveur

    try {
      var response = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type':
              'application/json', // Spécifie le type de contenu JSON
        },
        body: json.encode({
          'name': nom,
          'description': description,
          'price': price,
        }),
      );

      if (response.statusCode == 200) {
        // Réussite : les données ont été mises à jour
        print('Données mises à jour avec succès');
        // Ajoutez ici des actions à effectuer en cas de réussite (par exemple, afficher un message à l'utilisateur)
      } else {
        print(response.statusCode);
        print(json.encode({
          'id': id,
          'nom': nom,
          'description': description,
          'price': price,
        }));

        // Échec : quelque chose s'est mal passé lors de la mise à jour des données
        print('Échec de la mise à jour des données');
        // Ajoutez ici des actions à effectuer en cas d'échec (par exemple, afficher un message d'erreur à l'utilisateur)
      }
    } catch (e) {
      // Gestion des erreurs
      print('Erreur lors de la mise à jour des données : $e');
      // Ajoutez ici des actions à effectuer en cas d'erreur (par exemple, afficher un message d'erreur à l'utilisateur)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            height: 100,
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Text(
                "Entrer un ID existant dans la BDD pour changer ses données"),
          ),
          Container(
            height: 0,
          ),
          Container(
            padding: EdgeInsets.all(20),
            child: TextFormField(
              controller: idController,
              decoration: InputDecoration(
                labelText: 'ID',
                hintText: 'Entrer votre ID',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(20),
            child: TextFormField(
              controller: nomController,
              decoration: InputDecoration(
                labelText: 'Nom',
                hintText: 'Entrer votre nom',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(20),
            child: TextFormField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                hintText: 'Entrer une description',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(20),
            child: TextFormField(
              controller: priceController,
              decoration: InputDecoration(
                labelText: 'Price',
                hintText: 'Entrer votre Price',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),
          ),
          MaterialButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed("product");
            },
            child: Text("return to the list"),
          ),
          ElevatedButton(
            onPressed: () {
              if (idController.text.isEmpty) {
                // Afficher une boîte de dialogue si le champ ID est vide
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Champ ID vide'),
                      content:
                          Text('Veuillez entrer un ID avant de mettre à jour.'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Fermer'),
                        ),
                      ],
                    );
                  },
                );
              } else {
                // Convertir en entier seulement si le champ ID n'est pas vide
                int id = int.parse(idController.text);
                if (id == null) {
                  // Afficher une boîte de dialogue si la conversion échoue
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Erreur'),
                        content:
                            Text('L\'ID entré n\'est pas un nombre valide.'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Fermer'),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  // La conversion a réussi, vous pouvez utiliser la variable 'id' ici
                  updateData(); // Appel à la fonction pour mettre à jour les données
                }
              }
            },
            child: Text('Mettre à jour'),
          ),
        ],
      ),
    );
  }
}
