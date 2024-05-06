import 'dart:async';
import 'dart:io';

import 'package:authentication_sample_with_supabase_flutter/components/google_signin_container.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'main.dart';
import './components/my_text_field.dart';

typedef FutureCallback<T> = Future<T> Function();

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _redirecting = false;
  var _isLoading = false;
  var _shouldCreateUser = true;
  late final StreamSubscription<AuthState> _authStateSubscription;

  final _emailController = TextEditingController(text: 'someone@example.com');
  final _passwordController =
      TextEditingController(text: 'rBTWSCWtdgbdaEuhisNF');
  final _userNameController = TextEditingController(text: 'example taro');
  final _magicLinkEmailController =
      TextEditingController(text: 'wizardeveryone@example.com');
  final _phoneNumberController = TextEditingController(text: '+81');
  final _otpController = TextEditingController(text: '');
  late final String _googleClientId;
  late final String _googleWebClientId;
  late final String _googleClientIdIos;
  final List<String> _selectedScopeUrls = [];

  @override
  void initState() {
    super.initState();

    _googleClientId = dotenv.get('GOOGLE_CLIENT_ID', fallback: 'unknown...');
    _googleWebClientId = dotenv.get('GOOGLE_WEB_CLIENT_ID', fallback: '');
    _googleClientIdIos =
        dotenv.get('GOOGLE_CLIENT_ID_IOS', fallback: 'unknown...');

    _authStateSubscription = supabase.auth.onAuthStateChange.listen((event) {
      debugPrint('event: ${event.event.toString()}');
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
            const Gap(8.0),
            const Divider(color: Colors.orange, thickness: 3.0),
            Text('Sign in with magic link',
                style: Theme.of(context).textTheme.headlineSmall),
            TextFormField(
              decoration: const InputDecoration(
                label: Text('email for magic link'),
                hintText: 'foobar@example.com',
              ),
              controller: _magicLinkEmailController,
            ),
            CheckboxListTile.adaptive(
              title: const Text('shouldCreateUser(default: true)'),
              value: _shouldCreateUser,
              onChanged: (value) {
                if (value != null) {
                  setState(() => _shouldCreateUser = value);
                }
              },
            ),
            ElevatedButton(
              onPressed: _isLoading ? null : _signInMagicLink,
              child: Text(_isLoading ? 'Loading' : 'Sign in with magic link'),
            ),
            const Gap(8.0),
            const Divider(color: Colors.orange, thickness: 3.0),
            Text('Phone Auth with Twilio',
                style: Theme.of(context).textTheme.headlineSmall),
            MyTextField(
              controller: _phoneNumberController,
              hintText: '+81123456',
              label: 'Phone Number',
            ),
            ElevatedButton(
              onPressed: _isLoading ? null : _signInSms,
              child: Text(_isLoading ? 'Loading' : 'Send Phone Number'),
            ),
            const Gap(8.0),
            const Text('OTP Number'),
            MyTextField(
              controller: _otpController,
              hintText: '123456',
              label: 'One Time Password',
            ),
            ElevatedButton(
              onPressed: _isLoading ? null : _singInVerifyOtp,
              child: Text(_isLoading ? 'Loading' : 'Verify OTP'),
            ),
            const Gap(8.0),
            const Divider(color: Colors.orange, thickness: 3.0),
            Text(
              'Social Login(Google)',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            GoogleSigninContainer(
              onChangedScopeUrl: (nextCheckValue, url) {
                if (nextCheckValue == true) {
                  setState(
                    () {
                      _selectedScopeUrls.add(url);
                    },
                  );
                } else {
                  setState(
                    () {
                      _selectedScopeUrls.remove(url);
                    },
                  );
                }
              },
              selectedScopes: _selectedScopeUrls,
              isLoading: _isLoading,
              onPressed: _isLoading ? null : _signInWithGoogle,
            ),
            const Gap(8.0),
            const Divider(color: Colors.orange, thickness: 3.0),
            Text(
              'Social Login(Facebook)',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            ElevatedButton(
              onPressed: _isLoading ? null : _signInWithFacebook,
              child: Text(_isLoading ? 'Loading' : 'Sign in with Facebook'),
            ),
            const Gap(64)
          ],
        ),
      ),
    );
  }

  Future<void> _singInVerifyOtp() async {
    await _signInFlow(() async {
      await supabase.auth.verifyOTP(
        phone: _phoneNumberController.text,
        token: _otpController.text,
        type: OtpType.sms,
      );
    });
  }

  Future<void> _signInSms() async {
    await _signInFlow(() async {
      await supabase.auth.signInWithOtp(
        phone: _phoneNumberController.text,
      );
    });
  }

  Future<void> _signInMagicLink() async {
    await _signInFlow(() async {
      await supabase.auth.signInWithOtp(
        email: _magicLinkEmailController.text,
        shouldCreateUser: _shouldCreateUser,
        // 下記URLがsupabase projectのRedirect URLsと一致していないと、リダイレクト後サインインできない(仕様)
        // ref: https://github.com/supabase/supabase/issues/11995#issuecomment-1647874100
        emailRedirectTo: 'io.supabase.flutterquickstart://login-callback/',
      );
    });
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
        OAuthProvider.github,
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

  Future<void> _signInWithGoogle() async {
    await _signInFlow(() async {
      final scopes = ['email', ..._selectedScopeUrls];
      debugPrint('scopes: $scopes');
      final googleSignIn = GoogleSignIn(
        clientId: Platform.isAndroid ? _googleClientId : _googleClientIdIos,
        serverClientId: _googleWebClientId,
        scopes: scopes,
      );
      final googleUser = await googleSignIn.signIn();
      final googleAuth = await googleUser!.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (accessToken == null) {
        throw 'No Access Token found.';
      }

      if (idToken == null) {
        throw 'No ID Token found.';
      }

      final result = await supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );
      debugPrint('result: $result ');
    });
  }

  Future<void> _signInWithFacebook() async {
    await _signInFlow(() async {
      await supabase.auth.signInWithOAuth(
        OAuthProvider.facebook,
        redirectTo: 'io.supabase.flutterquickstart://login-callback/',
      );
    });
  }
}
