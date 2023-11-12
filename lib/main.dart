import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'login_after_page.dart';
import './login_page.dart';
import './splash_page.dart';

Future<void> main() async {
  const environment = String.fromEnvironment('ENVIRONMENT');
  await dotenv.load(
      fileName: environment == 'development' ? '.env' : '.env.local');

  final supabaseUrl = dotenv.get('SUPABASE_URL', fallback: '');
  final anonKey = dotenv.get('SUPABASE_ANONKEY', fallback: '');
  debugPrint('SUPABASE_URL: $supabaseUrl');
  debugPrint('ANON_KEY: $anonKey');
  final googleClientId = dotenv.get('GOOGLE_CLIENT_ID', fallback: '');
  debugPrint('GOOGLE_CLIENT_ID: $googleClientId');
  final googleWebClientId = dotenv.get('GOOGLE_WEB_CLIENT_ID', fallback: '');
  debugPrint('GOOGLE_WEB_CLIENT_ID: $googleWebClientId');

  await Supabase.initialize(
      url: supabaseUrl, anonKey: anonKey, authFlowType: AuthFlowType.pkce);
  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Supabase Authentication Login Sample',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (_) => const SplashPage(),
        '/login': (_) => const LoginPage(),
        '/login-after': (_) => const LoginAfterPage(),
      },
    );
  }
}
