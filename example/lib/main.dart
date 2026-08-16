import 'package:curved_bottom_nav_bar_animated/curved_bottom_nav_bar_animated.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Curved Bottom Nav Bar Demo',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0;

  static const _titles = ['Calls', 'Home', 'Chat'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_titles[_index])),
      body: Center(
        child: Text(
          _titles[_index],
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      bottomNavigationBar: CurvedBottomNavBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        items: const [
          CurvedBottomNavItem(icon: Icons.call, label: 'Calls'),
          CurvedBottomNavItem(icon: Icons.home_outlined, label: 'Home'),
          CurvedBottomNavItem(icon: Icons.chat_outlined, label: 'Chat'),
        ],
      ),
    );
  }
}
