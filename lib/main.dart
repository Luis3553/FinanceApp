import 'package:finance_project/screens/currency_converter_screen.dart';
import 'package:finance_project/screens/goals_screen.dart';
import 'package:finance_project/screens/home_screen.dart';
import 'package:finance_project/screens/news_screen.dart';
import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
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
        '/': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
        '/converter': (context) => CurrencyConverterScreen(),
        '/goals': (context) => GoalsScreen(),
        '/news': (context) => NewsScreen(),
      },
    );
  }
}
