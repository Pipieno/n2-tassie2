import 'package:flutter/material.dart';
import 'login_page.dart'; // Certifique-se de que LoginPage está definido corretamente nesse arquivo
import 'register_page.dart'; // Certifique-se de que RegisterPage está definido corretamente nesse arquivo
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Necessário para inicializações assíncronas na função main.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); // Inicializando o Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gerenciamento de Habilidades',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF1c3166),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF031927),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFBA1200),
            foregroundColor: Colors.white,
            textStyle: TextStyle(fontSize: 18),
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
        textTheme: TextTheme(
          bodyMedium: TextStyle(
            color: Color(0xFF031927),
          ),
          titleLarge: TextStyle(
            color: Color(0xFF9DD1F1),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: HomePage(),
      routes: {
        '/login': (context) => LoginPage(), // Corrigido para LoginPage
        '/register': (context) => RegisterPage(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gerenciamento de Habilidades'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/imagen.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Minhas Habilidades',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFBA1200),
                ),
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login'); // Navega para a página de login
                },
                child: Text('Adicionar Habilidade'),
              ),
              // O botão "Ver Habilidades" foi removido
            ],
          ),
        ),
      ),
    );
  }
}
