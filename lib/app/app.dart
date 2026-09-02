import 'package:flutter/material.dart';
import 'router.dart';

class FitnessPulseApp extends StatelessWidget{
  const FitnessPulseApp({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Fitness Pulse',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true
      ),
      routerConfig: appRouter,
    );
  }
}