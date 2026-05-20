// Student Assistant Application - TPG316C Assignment
// Group Members:
// 221021198 - AM MATONA
// 221021493 - M MAKHASANE
// 222072446 - PN MONGWE
// 222071364 - N TLALI
// 222071216 - IKF NDLOVU
// 224079833 - PP BOTMAN
// Date: May 2026

import 'package:flutter/material.dart';
import 'views/splash_screen.dart';
import 'views/login_screen.dart';
import 'views/register_screen.dart';
import 'views/student_home.dart';
import 'views/admin_dashboard.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String studentHome = '/student';
  static const String adminDashboard = '/admin';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case studentHome:
        return MaterialPageRoute(builder: (_) => const StudentHomeScreen());
      case adminDashboard:
        return MaterialPageRoute(builder: (_) => const AdminDashboardScreen());
      default:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
    }
  }
}
