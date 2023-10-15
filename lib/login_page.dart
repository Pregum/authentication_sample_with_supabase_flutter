import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _redirecting = false;
  var _isLoading = false;
  late final StreamSubscription<AuthState> _authStateSubscripion;

  @override
  void initState() {
    super.initState();

    _authStateSubscripion = supabase.auth.onAuthStateChange.listen((event) {
      if (_redirecting) {
        return;
      }
      final session = event.session;
      if (session != null) {
        _redirecting = true;
        Navigator.of(context).pushReplacementNamed('/login-after');
      }
    });
  }

  @override
  void dispose() {
    _authStateSubscripion.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign in')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        children: [
          const Text('Sign in with GitHub'),
          const SizedBox(
            height: 18,
          ),
          ElevatedButton(
            onPressed: _isLoading ? null : _signInGitHub,
            child: Text(_isLoading ? 'Loading' : 'Sign in with GitHub'),
          ),
          const SizedBox(
            height: 18,
          ),
        ],
      ),
    );
  }

  Future<void> _signInGitHub() async {
    try {
      setState(() {
        _isLoading = true;
      });
      await supabase.auth.signInWithOAuth(
        Provider.github,
        redirectTo: 'io.supabase.flutterquickstart://login-callback/',
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unexcepted Error. $error'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
