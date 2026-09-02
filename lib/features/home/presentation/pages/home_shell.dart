import 'package:fitness_pulse/app/dependencies.dart';
import 'package:flutter/material.dart';
import '../../../dashboard/presentation/pages/dashboard_page.dart';
import '../../../progress/presentation/pages/progress_page.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    DashboardPage(),
    Center(child: Text('AI help')),
    ProgressPage()
  ];

  Future<void> _logout() async {
    await AppDependencies.authController.logout();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.fitness_center, color: Colors.blue),
            SizedBox(width: 10),
            Text('Fitness Pulse'),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout_outlined),
            tooltip: 'logout',
            onPressed: _logout,
          )
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index){
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.fitness_center_outlined), 
            selectedIcon: Icon(Icons.fitness_center),
            label: 'Main'
          ),
          NavigationDestination(
            icon: Icon(Icons.psychology_outlined), 
            selectedIcon: Icon(Icons.psychology),
            label: 'AI help'
          ),
          NavigationDestination(
            icon: Icon(Icons.show_chart_outlined), 
            selectedIcon: Icon(Icons.show_chart),
            label: 'Progress'
          )
        ]
      )
    );
  }
}