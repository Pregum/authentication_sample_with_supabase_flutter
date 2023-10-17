import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'main.dart';

class LoginAfterPage extends StatefulWidget {
  const LoginAfterPage({super.key});

  @override
  State<LoginAfterPage> createState() => _LoginAfterPageState();
}

class _LoginAfterPageState extends State<LoginAfterPage> {
  @override
  Widget build(BuildContext context) {
    final user = supabase.auth.currentSession!.user;
    final userMetadata = user.userMetadata;
    final avatarUrl = userMetadata?['avatar_url'] as String?;
    final userName = userMetadata?['user_name'] as String? ?? 'unknown name';
    // final userMetadataKeys =['email', 'email_verified', 'iss', 'full_name', 'provider_id', 'sub' , 'user_name'];

    return Scaffold(
      appBar: AppBar(title: const Text('Login After')),
      body: ListView(
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
          Text('user: $user'),
          const Gap(18),
          ElevatedButton(onPressed: _signOut, child: const Text('Sign out')),
        ],
      ),
    );
  }

  Future<void> _signOut() async {
    // setState(() {
    //   _loading = true;
    // });

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
