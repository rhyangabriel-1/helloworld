import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Distância até Minha Casa',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String distanciaTexto =
      'Clique no botão para calcular a distância.';

  // Coordenadas da sua casa
  final double casaLatitude = -21.494160795071735;
  final double casaLongitude = -47.00363839739039;

  Future<void> calcularDistancia() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      setState(() {
        distanciaTexto = 'Ative a localização do dispositivo.';
      });
      return;
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        setState(() {
          distanciaTexto = 'Permissão negada.';
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        distanciaTexto = 'Permissão negada permanentemente.';
      });
      return;
    }

    Position posicaoAtual = await Geolocator.getCurrentPosition();

    double distancia = Geolocator.distanceBetween(
      posicaoAtual.latitude,
      posicaoAtual.longitude,
      casaLatitude,
      casaLongitude,
    );

    setState(() {
      distanciaTexto =
          'Distância: ${(distancia / 1000).toStringAsFixed(2)} km';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F0F7),
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Distância até Minha Casa'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.home,
                size: 100,
                color: Colors.blue,
              ),
              const SizedBox(height: 20),
              const Text(
                'Distância entre a escola e minha casa',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                distanciaTexto,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: calcularDistancia,
                child: const Text('Calcular distância'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}