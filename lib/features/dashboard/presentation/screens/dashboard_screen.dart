import 'package:flutter/material.dart';

import '../../../../common/widgets/bottom_navigation_bar/bottom_navigation_bar_widget.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pinterest'),
        centerTitle: false,
        elevation: 0,
      ),
      body: Center(
        child: Text(
          _navigationLabels[_currentIndex],
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
        ),
      ),
      bottomNavigationBar: BottomNavBarWidget(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }

  static const _navigationLabels = [
    'Home',
    'Search',
    'Create',
    'Notifications',
    'Saved',
  ];
}
