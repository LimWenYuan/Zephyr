import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'features/home/home_screen.dart';
import 'features/dashboard/dashboard_screen.dart';
import 'features/forecast/forecast_screen.dart';
import 'features/trend/trends_screen.dart';
import 'features/health/health_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://vrdamvurihydlguadhjy.supabase.co',
    anonKey: 'sb_publishable_7F-_lrJd6dU1OJyiPEbkyg_-GQXyahh',
  );

  runApp(const ZephyrApp());
}

class ZephyrApp extends StatelessWidget {
  const ZephyrApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Zephyr',
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/forecast': (context) => const ForecastScreen(),
        '/trends': (context) => const TrendsScreen(),
        '/health': (context) => const HealthScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/dashboard') {
          final selectedLocation = settings.arguments as String?;
          return MaterialPageRoute(
            builder: (context) => DashboardScreen(
              selectedLocation: selectedLocation,
            ),
          );
        }
        return null;
      },
    );
  }
}