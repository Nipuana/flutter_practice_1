import 'package:flutter/material.dart';

import '../../../../common/widgets/buttons/default_edge_round.dart';
import '../../../../core/navigation/nav.dart';
import '../../../dashboard/presentation/screens/dashboard_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  static const _pinterestRed = Color(0xFFE60023);
  final _pageController = PageController();
  int _currentPage = 0;

  void _openDashboard(BuildContext context) {
    Nav.pushReplacement(context, const DashboardScreen());
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  PageView(
                    controller: _pageController,
                    onPageChanged: (page) =>
                        setState(() => _currentPage = page),
                    children: [
                      _PlaceholderSlide(
                        title: 'Find your next idea',
                        subtitle:
                            'Explore inspiration for every part of your life.',
                        color: const Color(0xFFFFE4E8),
                      ),
                      _PlaceholderSlide(
                        title: 'Save what inspires you',
                        subtitle: 'Create boards and keep your favorite ideas together.',
                        color: const Color(0xFFE2F2F1),
                      ),
                      _WelcomeSlide(),
                    ],
                  ),
                  if (_currentPage < 2)
                    Positioned(
                      top: 2,
                      right: 2,
                      child: Material(
                        color: Colors.white.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(20),
                        elevation: 2,
                        child: TextButton(
                          onPressed: () => _pageController.animateToPage(
                            2,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          ),
                          style: TextButton.styleFrom(
                            foregroundColor: const Color(0xFF333333),
                            minimumSize: const Size(64, 40),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text(
                            'Skip',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            _BottomControls(
              currentPage: _currentPage,
              onNext: () => _pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              ),
              onSignUp: () => _openDashboard(context),
              onLogin: () => _openDashboard(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlaceholderSlide extends StatelessWidget {
  const _PlaceholderSlide({
    required this.title,
    required this.subtitle,
    required this.color,
  });

  final String title;
  final String subtitle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 6,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(28),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: Image.asset(
                  'assets/images/onboard_image_3.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1F1F1F),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              height: 1.4,
              color: Color(0xFF555555),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class _WelcomeSlide extends StatelessWidget {
  const _WelcomeSlide();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Expanded(
                flex: 6,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE4E8),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: Image.asset(
                      'assets/images/onboard_image_3.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Welcome to Pinterest',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1F1F1F),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _BottomControls extends StatelessWidget {
  const _BottomControls({
    required this.currentPage,
    required this.onNext,
    required this.onSignUp,
    required this.onLogin,
  });

  final int currentPage;
  final VoidCallback onNext;
  final VoidCallback onSignUp;
  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) {
    final isWelcome = currentPage == 2;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 36),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _PageIndicator(currentPage: currentPage),
          SizedBox(height: isWelcome ? 12 : 16),
          if (isWelcome)
            const Text(
              "By continuing, you agree to Pinterest's Terms of Service and "
              'acknowledge that you read our Privacy Policy',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 9,
                height: 1.35,
                color: Color(0xFF333333),
              ),
            ),
          if (isWelcome) const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: RoundedButton(
              text: isWelcome ? 'Sign up' : 'Next',
              onPressed: isWelcome ? onSignUp : onNext,
              backgroundColor: _OnboardingScreenState._pinterestRed,
              textColor: Colors.white,
              borderRadius: 28,
              padding: const EdgeInsets.symmetric(vertical: 14),
              fontSize: 14,
            ),
          ),
          if (isWelcome) ...[
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: RoundedButton(
                text: 'Log in',
                onPressed: onLogin,
                backgroundColor: const Color(0xFFF0F0F0),
                textColor: const Color(0xFF333333),
                borderRadius: 28,
                padding: const EdgeInsets.symmetric(vertical: 14),
                fontSize: 14,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _PageIndicator extends StatelessWidget {
  const _PageIndicator({required this.currentPage});

  final int currentPage;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        3,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: currentPage == index ? 20 : 7,
          height: 7,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          decoration: BoxDecoration(
            color: currentPage == index
                ? const Color(0xFFE60023)
                : const Color(0xFFD8D8D8),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
