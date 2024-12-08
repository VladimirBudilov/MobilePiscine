import 'package:diary_app/pages/start_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'pages/diary_page.dart';
import 'services/auth_service.dart';
import 'services/diary_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(DiaryApp());
}

class DiaryApp extends StatelessWidget {
  final AuthService authService = AuthService();
  final DiaryService diaryService = DiaryService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Diary App',
      initialRoute: '/',
      routes: {
        '/': (context) => StartPage(),
        '/login': (context) => LoginPage(),
        '/diary': (context) => DiaryPage(
              authService: authService,
              diaryService: diaryService,
            ),
      },
    );
  }
}
