import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/design_tokens.dart';
import '../../../../common/widgets/feedback/app_toast.dart';
import '../../../../core/navigation/nav.dart';
import '../../../dashboard/presentation/screens/dashboard_screen.dart';

import '../cubit/auth_cubit.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({required this.register, super.key});

  final bool register;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late bool _isRegister;
  bool _registrationPending = false;
  bool _loginPending = false;

  @override
  void initState() {
    super.initState();
    _isRegister = widget.register;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final cubit = context.read<AuthCubit>();
    if (_isRegister) {
      _registrationPending = true;
      cubit.register(
        _nameController.text,
        _emailController.text,
        _passwordController.text,
      );
    } else {
      _loginPending = true;
      cubit.signIn(_emailController.text, _passwordController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (previous, current) =>
          previous.errorMessage != current.errorMessage ||
          previous.status != current.status,
      listener: (context, state) {
        if (state.errorMessage != null) {
          _registrationPending = false;
          _loginPending = false;
          AppToast.show(context, state.errorMessage!);
        } else if (_registrationPending &&
            state.status == AuthStatus.authenticated) {
          _registrationPending = false;
          context.read<AuthCubit>().signOut();
          AppToast.show(context, 'Account created. Please log in.');
          Nav.pushReplacement(context, const AuthScreen(register: false));
        } else if (_loginPending && state.status == AuthStatus.authenticated) {
          _loginPending = false;
          AppToast.show(context, 'Welcome back!');
          Nav.pushAndRemoveAll(context, const DashboardScreen());
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: AppSpacing.screen,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: 72,
                        height: 72,
                        fit: BoxFit.contain,
                        semanticLabel: 'Pinterest logo',
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Text(
                      _isRegister ? 'Create your account' : 'Welcome back',
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      _isRegister
                          ? 'Save ideas and make Pinterest yours.'
                          : 'Log in to continue to your account.',
                      style: const TextStyle(color: AppColors.textMuted),
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    if (_isRegister) ...[
                      _field(_nameController, 'Name', Icons.person_outline),
                      const SizedBox(height: AppSpacing.md),
                    ],
                    _field(
                      _emailController,
                      'Email',
                      Icons.email_outlined,
                      email: true,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _field(
                      _passwordController,
                      'Password',
                      Icons.lock_outline,
                      password: true,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, state) => FilledButton(
                        onPressed: state.status == AuthStatus.loading
                            ? null
                            : _submit,
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.surface,
                          disabledBackgroundColor: AppColors.primary.withValues(
                            alpha: 0.5,
                          ),
                          disabledForegroundColor: AppColors.surface,
                        ),
                        child: Text(_isRegister ? 'Sign up' : 'Log in'),
                      ),
                    ),
                    TextButton(
                      onPressed: () =>
                          setState(() => _isRegister = !_isRegister),
                      child: Text(
                        _isRegister
                            ? 'Already have an account? Log in'
                            : 'New to Pinterest? Sign up',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool password = false,
    bool email = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: password,
      keyboardType: email ? TextInputType.emailAddress : null,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) return 'Enter your $label';
        if (email && !value.contains('@')) return 'Enter a valid email';
        if (password && value.length < 6) return 'Use at least 6 characters';
        return null;
      },
    );
  }
}
