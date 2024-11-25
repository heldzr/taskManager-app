import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Método para pegar as tarefas do Firebase
  Stream<List<Map<String, dynamic>>> _getTasks() {
    return _firestore.collection('tasks').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Minhas Tarefas'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // Navegar para a tela de adicionar tarefa
              Navigator.pushNamed(context, '/add-task');
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _getTasks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar tarefas.'));
          }

          final tasks = snapshot.data;

          return ListView.builder(
            itemCount: tasks?.length ?? 0,
            itemBuilder: (context, index) {
              final task = tasks![index];
              return ListTile(
                title: Text(task['title'] ?? 'Sem título'),
                subtitle: Text(task['description'] ?? 'Sem descrição'),
                trailing: Icon(Icons.check_circle_outline),
                onTap: () {
                  // Ação para visualizar os detalhes da tarefa
                },
              );
            },
          );
        },
      ),
    );
  }
}
