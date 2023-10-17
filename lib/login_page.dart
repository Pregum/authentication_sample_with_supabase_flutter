import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'main.dart';
import 'my_text_field.dart';

typedef FutureCallback<T> = Future<T> Function();

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _redirecting = false;
  var _isLoading = false;
  late final StreamSubscription<AuthState> _authStateSubscription;

  final _emailController = TextEditingController(text: 'someone@example.com');
  final _passwordController =
      TextEditingController(text: 'rBTWSCWtdgbdaEuhisNF');
  final _userNameController = TextEditingController(text: 'example taro');

  @override
  void initState() {
    super.initState();

    _authStateSubscription = supabase.auth.onAuthStateChange.listen((event) {
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
    _authStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign in / Sign up Page')),
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
          children: [
            Text('Sign in with GitHub',
                style: Theme.of(context).textTheme.headlineSmall),
            const Gap(8.0),
            ElevatedButton(
              onPressed: _isLoading ? null : _signInGitHub,
              child: Text(_isLoading ? 'Loading' : 'Sign in with GitHub'),
            ),
            const Gap(8.0),
            const Divider(color: Colors.orange, thickness: 3.0),
            Text('Sign in with Email / Sign up with Email ',
                style: Theme.of(context).textTheme.headlineSmall),
            MyTextField(
              label: 'Email',
              controller: _emailController,
            ),
            const Gap(8.0),
            MyTextField(
              label: 'password',
              controller: _passwordController,
            ),
            const Gap(8.0),
            MyTextField(
              label: 'user_name',
              controller: _userNameController,
            ),
            const Gap(8.0),
            ElevatedButton(
              onPressed: _isLoading ? null : _signInEmail,
              child:
                  Text(_isLoading ? 'Loading' : 'Sign in Email and Password'),
            ),
            const Gap(8.0),
            ElevatedButton(
              onPressed: _isLoading ? null : _signUpEmail,
              child:
                  Text(_isLoading ? 'Loading' : 'Sign up Email and Password'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _signUpEmail() async {
    await _signInFlow(() async {
      final auth = await supabase.auth.signUp(
        email: _emailController.text,
        password: _passwordController.text,
        data: {'user_name': _userNameController.text},
      );
      debugPrint('auth: $auth');
    });
  }

  Future<void> _signInEmail() async {
    await _signInFlow(() async {
      final auth = await supabase.auth.signInWithPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      debugPrint('auth: $auth');
    });
  }

  Future<void> _signInGitHub() async {
    await _signInFlow(() async {
      await supabase.auth.signInWithOAuth(
        Provider.github,
        redirectTo: 'io.supabase.flutterquickstart://login-callback/',
      );
    });
  }

  Future<void> _signInFlow(FutureCallback<void> attemptFutureFunc) async {
    try {
      setState(() {
        _isLoading = true;
      });
      await attemptFutureFunc();
    } catch (error) {
      debugPrint('error: $error');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Unexpected Error. $error'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
