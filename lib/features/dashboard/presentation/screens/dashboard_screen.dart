import 'package:flutter/material.dart';

import '../../../../common/design_tokens.dart';
import '../../../../common/widgets/bottom_navigation_bar/bottom_navigation_bar_widget.dart';
import '../../../auth/presentation/screens/profile_screen.dart';

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
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _DashboardPlaceholder(label: _navigationLabels[0]),
          _DashboardPlaceholder(label: _navigationLabels[1]),
          _DashboardPlaceholder(label: _navigationLabels[2]),
          _DashboardPlaceholder(label: _navigationLabels[3]),
          const ProfileScreen(embedded: true),
        ],
      ),
      bottomNavigationBar: BottomNavBarWidget(
        currentIndex: _currentIndex,
        onTap: _onNavigationTap,
      ),
    );
  }

  void _onNavigationTap(int index) {
    setState(() => _currentIndex = index);
  }

  static const _navigationLabels = [
    'Home',
    'Search',
    'Create',
    'Notifications',
    'Profile',
  ];
}

class _DashboardPlaceholder extends StatelessWidget {
  const _DashboardPlaceholder({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: AppColors.text,
        ),
      ),
    );
  }
}
