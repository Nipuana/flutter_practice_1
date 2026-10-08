import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/design_tokens.dart';
import '../../../../core/navigation/nav.dart';
import '../cubit/auth_cubit.dart';
import 'auth_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({this.embedded = false, super.key});

  final bool embedded;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _email;
  final _currentPassword = TextEditingController();
  final _newPassword = TextEditingController();
  late final String _handle;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthCubit>().state.user;
    _name = TextEditingController(text: user?.displayName ?? '');
    _email = TextEditingController(text: user?.email ?? '');
    _handle = _createHandle(user?.displayName, user?.email);
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _currentPassword.dispose();
    _newPassword.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthCubit>().updateProfile(
      name: _name.text,
      email: _email.text,
      currentPassword: _currentPassword.text,
      newPassword: _newPassword.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (previous, current) =>
          previous.errorMessage != current.errorMessage ||
          previous.user != current.user,
      listener: (context, state) {
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.errorMessage!)));
        } else if (state.status == AuthStatus.authenticated) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Profile updated')));
        }
      },
      child: widget.embedded ? _profileForm() : Scaffold(body: _profileForm()),
    );
  }

  Widget _profileForm() {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.xl,
          AppSpacing.xxl,
          AppSpacing.xl,
          AppSpacing.xl,
        ),
        children: [
          _ProfileHeader(handle: _handle, name: _name.text),
          const SizedBox(height: AppSpacing.xxl),
          _field(_name, 'Name'),
          const SizedBox(height: AppSpacing.md),
          _field(_email, 'Email'),
          const SizedBox(height: AppSpacing.xl),
          const Text(
            'Security',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppSpacing.sm),
          const Text(
            'Your current password is required to change email or password.',
          ),
          const SizedBox(height: AppSpacing.md),
          _field(
            _currentPassword,
            'Current password',
            password: true,
            required: false,
          ),
          const SizedBox(height: AppSpacing.md),
          _field(_newPassword, 'New password', password: true, required: false),
          const SizedBox(height: AppSpacing.xl),
          BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) => FilledButton(
              onPressed: state.status == AuthStatus.loading ? null : _save,
              child: const Text('Save changes'),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          OutlinedButton(
            onPressed: () async {
              final cubit = context.read<AuthCubit>();
              await cubit.signOut();
              if (!mounted) return;
              Nav.pushAndRemoveAll(context, const AuthScreen(register: false));
            },
            child: const Text('Log out'),
          ),
        ],
      ),
    );
  }

  String _createHandle(String? name, String? email) {
    final source = name?.trim().isNotEmpty == true
        ? name!.trim()
        : (email?.split('@').first ?? 'user');
    final handle = source.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '');
    return handle.isEmpty ? 'user' : handle;
  }

  Widget _field(
    TextEditingController controller,
    String label, {
    bool password = false,
    bool required = true,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: password,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      validator: (value) => required && (value == null || value.trim().isEmpty)
          ? 'Enter your $label'
          : null,
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.handle, required this.name});

  final String handle;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 44,
          backgroundColor: AppColors.onboardingPink,
          child: Icon(Icons.person_rounded, size: 46, color: AppColors.primary),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          name.trim().isEmpty ? 'Your profile' : name,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.text,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          '@$handle',
          style: const TextStyle(color: AppColors.textMuted, fontSize: 14),
        ),
      ],
    );
  }
}
