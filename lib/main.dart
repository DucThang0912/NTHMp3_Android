import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'services/auth_service.dart';
import 'providers/auth_provider.dart';
import 'providers/spotify_provider.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Kiểm tra thiết bị thật hay ảo
  const isPhysicalDevice = bool.fromEnvironment('PHYSICAL_DEVICE');
  print('Running on ${isPhysicalDevice ? 'physical' : 'emulator'} device');
  
  final prefs = await SharedPreferences.getInstance();
  final authService = AuthService(prefs);

  runApp(MyApp(authService: authService));
}

class MyApp extends StatelessWidget {
  final AuthService authService;

  const MyApp({Key? key, required this.authService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(authService),
        ),
        ChangeNotifierProvider(
          create: (_) => SpotifyProvider(
            clientId: "24dfc57421d5444ab08ca1c434f30935",
            clientSecret: "03f0ecd3b5c2412a893e3fdfbb4da647",
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Music App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomeScreen(),
      ),
    );
  }
}
