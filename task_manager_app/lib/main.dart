import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:task_manager_app/screens/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyAccVC5uUYhnWSViH2MsmnqA34SORUa1qg",
          authDomain: "taskmanager-fb12f.firebaseapp.com",
          projectId: "taskmanager-fb12f",
          storageBucket: "taskmanager-fb12f.firebasestorage.app",
          messagingSenderId: "353936375102",
          appId: "1:353936375102:web:8d63110b072f56536c006f"));
  runApp(const TaskManagerApp());
}

class TaskManagerApp extends StatelessWidget {
  const TaskManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TaskManager',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
