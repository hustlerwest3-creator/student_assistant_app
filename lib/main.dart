import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'views/login_screen.dart';
import 'views/student_home.dart';
import 'views/admin_dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://oxuzivxoejiilerwyevk.supabase.co',
    anonKey: 'sb_publishable_7GBZjdO6ykrnWIqA_iQsRw_5gkbL1Wf',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Assistant Hub',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/student': (context) => const StudentHomeScreen(),
        '/admin': (context) => const AdminDashboardScreen(),
      },
    );
  }
}
