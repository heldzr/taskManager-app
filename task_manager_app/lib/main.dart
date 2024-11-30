import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:task_manager_app/screens/login.dart';
import 'screens/main_screen.dart';
import 'screens/add_task_screen.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyAccVC5uUYhnWSViH2MsmnqA34SORUa1qg",
      authDomain: "taskmanager-fb12f.firebaseapp.com",
      projectId: "taskmanager-fb12f",
      storageBucket: "taskmanager-fb12f.appspot.com",
      messagingSenderId: "353936375102",
      appId: "1:353936375102:web:8d63110b072f56536c006f",
    ),
  );
  runApp(const TaskManagerApp());
}

class TaskManagerApp extends StatelessWidget {
  const TaskManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TaskManager',
      theme: _buildLightTheme(),
      darkTheme: _buildDarkTheme(),
      themeMode: ThemeMode.light,
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/main': (context) => MainScreen(),
        '/add-task': (context) => const AddTaskScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }

  ThemeData _buildLightTheme() {
    return ThemeData(
      primaryColor: const Color(0xFFC4A7E7), // Lilás Suave
      scaffoldBackgroundColor: const Color(0xFFF8F9FA), // Fundo Claro
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFFC4A7E7),
        foregroundColor: Colors.white,
        elevation: 2,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      textTheme: _buildTextTheme(ThemeData.light().textTheme),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFFC4A7E7),
        foregroundColor: Colors.white,
      ),
      cardTheme: const CardTheme(
        color: Colors.white,
        shadowColor: Color(0x1F000000),
        elevation: 4,
        margin: EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.all(const Color(0xFFC4A7E7)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          backgroundColor: const Color(0xFFC4A7E7),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          textStyle: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.normal,
          ),
          foregroundColor: const Color(0xFFC4A7E7),
        ),
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      primaryColor: const Color(0xFFC4A7E7),
      scaffoldBackgroundColor: const Color(0xFF2C2C2C), // Fundo Escuro
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFFC4A7E7),
        foregroundColor: Colors.white,
        elevation: 2,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      textTheme: _buildTextTheme(ThemeData.dark().textTheme),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFFC4A7E7),
        foregroundColor: Colors.white,
      ),
      cardTheme: const CardTheme(
        color: Color(0xFF424242),
        shadowColor: Color(0x1F000000),
        elevation: 4,
        margin: EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.all(const Color(0xFFC4A7E7)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          backgroundColor: const Color(0xFFC4A7E7),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          textStyle: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.normal,
          ),
          foregroundColor: const Color(0xFFC4A7E7),
        ),
      ),
    );
  }

  TextTheme _buildTextTheme(TextTheme base) {
    return base.copyWith(
      headlineSmall: GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF2D2D2D),
      ),
      bodyLarge: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: const Color(0xFF2D2D2D),
      ),
      bodySmall: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w300,
        color: const Color(0xFF6C757D),
      ),
    );
  }
}
