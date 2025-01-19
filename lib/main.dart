// ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: TokenFormScreen() ,
    );
  }
}

class AuthRepository {
  final _secureStorage = FlutterSecureStorage();
  static const accessTokenKey = 'ACCESS_TOKEN';
  
  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: accessTokenKey, value: token);
  }
  
  Future<String?> getToken() async {
    return await _secureStorage.read(key: accessTokenKey);
  }
}

// Notre écran de formulaire
class TokenFormScreen extends StatefulWidget {
  @override
  _TokenFormScreenState createState() => _TokenFormScreenState();
}

class _TokenFormScreenState extends State<TokenFormScreen> {
  // Contrôleur pour gérer le texte saisi dans le champ
  final _tokenController = TextEditingController();
  
  // Instance de notre repository
  final _authRepository = AuthRepository();
  
  // Clé pour le formulaire (utile pour la validation)
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saisie du Token'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Champ de texte pour le token
              TextFormField(
                controller: _tokenController,
                decoration: InputDecoration(
                  labelText: 'Entrez votre token en entier',
                  border: OutlineInputBorder(),
                  // Aide visuelle pour l'utilisateur
                  helperText: 'Le token sera stocké de manière sécurisée',
                ),
                // Validation du champ
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un token';
                  }
                  return null;
                },
              ),
              
              SizedBox(height: 20), // Espacement
              
              // Bouton pour sauvegarder
              ElevatedButton(
                onPressed: () async {
                  // Vérifie si le formulaire est valide
                  if (_formKey.currentState!.validate()) {
                    try {
                      // Sauvegarde le token
                      await _authRepository.saveToken(_tokenController.text);
                      
                      // Affiche un message de succès
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Token sauvegardé avec succès !'),
                          backgroundColor: Colors.green,
                        ),
                      );
                      
                      // Vide le champ
                      _tokenController.clear();
                    } catch (e) {
                      // Gestion des erreurs
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Erreur lors de la sauvegarde'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
                child: Text('Sauvegarder le Token'),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  // Nettoyage du contrôleur quand l'écran est détruit
  @override
  void dispose() {
    _tokenController.dispose();
    super.dispose();
  }
}
