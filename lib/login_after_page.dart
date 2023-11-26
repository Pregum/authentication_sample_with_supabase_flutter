import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'main.dart';

class LoginAfterPage extends StatefulWidget {
  const LoginAfterPage({super.key});

  @override
  State<LoginAfterPage> createState() => _LoginAfterPageState();
}

class _LoginAfterPageState extends State<LoginAfterPage> {
  var isCheckedShouldForgetGoogleSignIn = false;
  @override
  Widget build(BuildContext context) {
    final user = supabase.auth.currentSession!.user;
    const encoder = JsonEncoder.withIndent('  ');
    final prettyUserJson = encoder.convert(user);
    final userMetadata = user.userMetadata;
    final appMetaData = encoder.convert(user.appMetadata);
    final avatarUrl = userMetadata?['avatar_url'] as String?;
    final userName = userMetadata?['user_name'] as String? ?? 'unknown name';
    // final userMetadataKeys =['email', 'email_verified', 'iss', 'full_name', 'provider_id', 'sub' , 'user_name'];

    return Scaffold(
      appBar: AppBar(title: const Text('Login After')),
      body: ListView(
      padding: const EdgeInsets.all(8.0),
        children: [
          SizedBox(
            height: 64,
            width: 64,
            child: avatarUrl != null
                ? Image.network(avatarUrl)
                : const Icon(Icons.no_photography),
          ),
          Text('user.name: $userName'),
          const Gap(18),
          Text('user: $prettyUserJson'),
          const Gap(18),
          CheckboxListTile(
            title: const Text('Google SignIn の再ログイン時、アカウントを選択できるようにする'),
            value: isCheckedShouldForgetGoogleSignIn,
            onChanged: (bool? value) {
              if (value == null) {
                return;
              }

              setState(() => isCheckedShouldForgetGoogleSignIn = value);
            },
          ),
          const Gap(18),
          ElevatedButton(
              onPressed: () => _signOut(
                    shouldForgetGoogleSignin: isCheckedShouldForgetGoogleSignIn,
                  ),
              child: const Text('Sign out')),
        ],
      ),
    );
  }

  Future<void> _signOut({bool shouldForgetGoogleSignin = false}) async {
    // setState(() {
    //   _loading = true;
    // });

    if (shouldForgetGoogleSignin) {
      try {
        // google sign in only.
        // 再ログイン時、アカウントを選択できるようにする方法
        final googleSignIn = GoogleSignIn();
        await googleSignIn.disconnect();
      } catch (e) {
        // no op
      }
    }

    try {
      await supabase.auth.signOut();
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Unexpected Error. $error'),
          ),
        );
      }
    } finally {
      if (mounted) {
        // setState(() {
        //   _loading = false;
        // });
        Navigator.of(context).pushReplacementNamed('/login');
      }
    }
  }
}
