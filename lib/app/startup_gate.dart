import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/dependencies/auth_dependencies.dart';

class StartupGate extends StatefulWidget {
  const StartupGate({required this.child, super.key});

  final Widget child;

  @override
  State<StartupGate> createState() => _StartupGateState();
}

class _StartupGateState extends State<StartupGate> {
  late final Future<SharedPreferences> _preferencesFuture;

  @override
  void initState() {
    super.initState();
    _preferencesFuture = SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: _preferencesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Directionality(
            textDirection: TextDirection.ltr,
            child: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return const Directionality(
            textDirection: TextDirection.ltr,
            child: Scaffold(
              body: Center(child: Text('Unable to start the application.')),
            ),
          );
        }

        return BlocProvider(
          create: (_) => AuthDependencies.createCubit(snapshot.data!),
          child: widget.child,
        );
      },
    );
  }
}
