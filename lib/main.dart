import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/health_records/providers/health_provider.dart';
import 'features/health_records/screens/dashboard_screen.dart';

void main() {
  runApp(const HealthMateApp());
}

class HealthMateApp extends StatelessWidget {
  const HealthMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HealthProvider()..loadRecords(),
      child: MaterialApp(
        title: 'HealthMate',
        debugShowCheckedModeBanner: false,
        home: const DashboardScreen(),
      ),
    );
  }
}
