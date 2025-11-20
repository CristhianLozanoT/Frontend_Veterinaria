import 'package:flutter/material.dart';
import 'package:frontend_veterinaria/services/api_service.dart'; 
import 'package:frontend_veterinaria/pages/admin/admin_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'widgets/navbar.dart';
import 'widgets/hero_section.dart';
import 'widgets/footer.dart';
import 'pages/assistant/assistant_router.dart';
import 'pages/vet/vet_router.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await ApiService.init();

  runApp(const VetConnectApp());
}

class VetConnectApp extends StatelessWidget {
  const VetConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VetConnect',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00A39A),
        ),
        textTheme: GoogleFonts.interTextTheme(),
      ),

      // Si no hay token → entrar al login
      initialRoute: ApiService.token == null ? '/' : '/dashboard',

      routes: {
        '/': (context) => const LandingPage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/admin': (context) => const AdminRouter(),
        '/vet': (context) => const VetRouter(),
        '/assistant': (context) => const AssistantRouter(),
      },
    );
  }
}

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FDFD),
      body: SingleChildScrollView(
        child: Column(
          children: const [
            Navbar(),
            HeroSection(),
            Footer(),
          ],
        ),
      ),
    );
  }
}
