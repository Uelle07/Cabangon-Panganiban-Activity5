import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'services/firestore_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase Core before running the application
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (_) {
    // Fallback if native platform config (google-services.json / GoogleService-Info.plist) is used
    try {
      await Firebase.initializeApp();
    } catch (e) {
      debugPrint('Firebase initialization warning: $e');
    }
  }

  runApp(const StudentAuthApp());
}

class StudentAuthApp extends StatelessWidget {
  final FirestoreService? firestoreService;

  const StudentAuthApp({super.key, this.firestoreService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Login and Registration System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2563EB),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF1F5F9),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(firestoreService: firestoreService),
        '/register': (context) =>
            RegisterScreen(firestoreService: firestoreService),
      },
    );
  }
}
