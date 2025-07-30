import 'package:finance_project/screens/currency_converter_screen.dart';
import 'package:finance_project/screens/goals_screen.dart';
import 'package:finance_project/screens/home_screen.dart';
import 'package:finance_project/screens/news_screen.dart';
import 'package:finance_project/screens/tasas_credito_screen.dart';
import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

Future<void> _loadEnvVars() async {
  try {
    // Try loading from root .env first
    await dotenv.load(fileName: ".env");
    return;
  } catch (e) {
    // If not found in root, try assets/.env
    try {
      await dotenv.load(fileName: "assets/.env");
      return;
    } catch (e) {
      // If running in web, try to get from window.env
      if (kIsWeb) {
        // This is a fallback for web - you'll need to set up window.env in your web/index.html
        debugPrint(
          'Running on web - make sure to set up window.env in index.html',
        );
      }
      // Only throw in debug mode to prevent crashes in production
      assert(
        false,
        'Could not load .env file. Make sure it exists in the root or assets folder.',
      );
    }
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await _loadEnvVars();

  // Initialize date formatting
  await initializeDateFormatting('es_ES', null);

  runApp(const FinanceApp());
}

class FinanceApp extends StatelessWidget {
  const FinanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FinanceApp RD',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Roboto', // Optional: use your preferred font
      ),
      routes: {
        '/': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/converter': (context) => const CurrencyConverterScreen(),
        '/goals': (context) => const GoalsScreen(),
        '/news': (context) => const NewsScreen(),
        '/tasas': (context) => const TasasCreditoScreen(),
      },
    );
  }
}
