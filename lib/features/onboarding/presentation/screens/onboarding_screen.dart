import 'package:flutter/material.dart';

import '../../../../common/design_tokens.dart';
import '../../../../common/widgets/buttons/default_edge_round.dart';
import '../../../../core/navigation/nav.dart';
import '../../../auth/presentation/screens/auth_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  void _openDashboard(BuildContext context) {
    Nav.pushReplacement(context, const AuthScreen(register: true));
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
                        color: AppColors.onboardingPink,
                      ),
                      _PlaceholderSlide(
                        title: 'Save what inspires you',
                        subtitle: 'Create boards and keep your favorite ideas together.',
                        color: AppColors.onboardingTeal,
                      ),
                      _WelcomeSlide(),
                    ],
                  ),
                  if (_currentPage < 2)
                    Positioned(
                      top: 2,
                      right: 2,
                      child: Material(
                        color: AppColors.surface.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(AppRadii.pill),
                        elevation: 2,
                        child: TextButton(
                          onPressed: () => _pageController.animateToPage(
                            2,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          ),
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.text,
                            minimumSize: const Size(64, 40),
                            padding: AppSpacing.buttonWithHorizontal,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppRadii.pill,
                              ),
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
              onLogin: () => Nav.pushReplacement(
                context,
                const AuthScreen(register: false),
              ),
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
      padding: AppSpacing.screen,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 6,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(AppRadii.card),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadii.card),
                child: Image.asset(
                  'assets/images/onboard_image_3.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              height: 1.4,
              color: AppColors.textSecondary,
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
          padding: AppSpacing.screen,
          child: Column(
            children: [
              Expanded(
                flex: 6,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.onboardingPink,
                    borderRadius: BorderRadius.circular(AppRadii.card),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadii.card),
                    child: Image.asset(
                      'assets/images/onboard_image_3.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              const Text(
                'Welcome to Pinterest',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: AppColors.text,
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
      padding: AppSpacing.screenBottom,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _PageIndicator(currentPage: currentPage),
          SizedBox(height: isWelcome ? AppSpacing.md : AppSpacing.lg),
          if (isWelcome)
            const Text(
              "By continuing, you agree to Pinterest's Terms of Service and "
              'acknowledge that you read our Privacy Policy',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 9,
                height: 1.35,
                color: AppColors.text,
              ),
            ),
          if (isWelcome) const SizedBox(height: AppSpacing.md),
          SizedBox(
            width: double.infinity,
            child: RoundedButton(
              text: isWelcome ? 'Sign up' : 'Next',
              onPressed: isWelcome ? onSignUp : onNext,
              backgroundColor: AppColors.primary,
              textColor: AppColors.surface,
              borderRadius: AppRadii.button,
              padding: AppSpacing.button,
              fontSize: 14,
            ),
          ),
          if (isWelcome) ...[
            const SizedBox(height: AppSpacing.sm),
            SizedBox(
              width: double.infinity,
              child: RoundedButton(
                text: 'Log in',
                onPressed: onLogin,
                backgroundColor: AppColors.surfaceMuted,
                textColor: AppColors.text,
                borderRadius: AppRadii.button,
                padding: AppSpacing.button,
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
          margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xs / 2),
          decoration: BoxDecoration(
            color: currentPage == index
                ? AppColors.primary
                : AppColors.inactive,
            borderRadius: BorderRadius.circular(AppRadii.indicator),
          ),
        ),
      ),
    );
  }
}
