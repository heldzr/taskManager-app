import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'details_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Método para obter o stream das tarefas
  Stream<QuerySnapshot> _getTasksStream() {
    return _firestore
        .collection('tasks')
        .orderBy('created_at', descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true, // Centraliza o título
        title: const Text('Minhas Tarefas'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: const Color(0xFFC4A7E7), 
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'Bem-vindo!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Selecione uma opção:',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person, color: Color(0xFFC4A7E7)),
              title: const Text(
                'Perfil',
                style: TextStyle(color: Color(0xFF2D2D2D)),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.list, color: Color(0xFFC4A7E7)),
              title: const Text(
                'Minhas Tarefas',
                style: TextStyle(color: Color(0xFF2D2D2D)),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Color(0xFFC4A7E7)),
              title: const Text(
                'Configurações',
                style: TextStyle(color: Color(0xFF2D2D2D)),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SettingsScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Color(0xFFC4A7E7)),
              title: const Text(
                'Logout',
                style: TextStyle(color: Color(0xFF2D2D2D)),
              ),
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _getTasksStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError ||
              !snapshot.hasData ||
              snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Nenhuma tarefa encontrada.'));
          }

          final tasks = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              final taskId = task.id;
              final title = task['title'] ?? 'Sem título';
              final description = task['description'] ?? 'Sem descrição';
              final status = task['status'] ?? false;

              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: Checkbox(
                    value: status,
                    onChanged: (bool? newValue) {
                      _firestore.collection('tasks').doc(taskId).update({
                        'status': newValue,
                      });
                    },
                  ),
                  title: Text(
                    title,
                    style: TextStyle(
                      decoration: status
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  subtitle: Text(description),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _firestore.collection('tasks').doc(taskId).delete();
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TaskDetailsScreen(taskId: taskId),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add-task');
        },
        backgroundColor: const Color(0xFFC4A7E7),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
