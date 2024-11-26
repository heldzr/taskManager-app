import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'details_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Método get
  Stream<QuerySnapshot> _getTasksStream() {
    return _firestore
        .collection('tasks')
        .orderBy('created_at', descending: true)
        .snapshots();
  }

  // Método delete
  Future<void> _deleteTask(String taskId) async {
    try {
      await _firestore.collection('tasks').doc(taskId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tarefa excluída com sucesso!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao excluir tarefa: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Tarefas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/add-task');
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _getTasksStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar tarefas.'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Nenhuma tarefa encontrada.'));
          }

          final tasks = snapshot.data!.docs;

          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              final taskId = task.id;
              final title = task['title'] ?? 'Sem título';
              final description = task['description'] ?? 'Sem descrição';

              return ListTile(
                leading: Checkbox(
                  value: task['status'] ?? false, // Mostra se está concluída
                  onChanged: (bool? newValue) {
                    _firestore.collection('tasks').doc(task.id).update({
                      'status': newValue, // Atualiza o status no Firestore
                    });
                  },
                ),
                title: Text(
                  title,
                  style: TextStyle(
                    decoration: (task['status'] ?? false)
                        ? TextDecoration.lineThrough // Risca a tarefa concluída
                        : TextDecoration.none,
                  ),
                ),
                subtitle: Text(description),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteTask(task.id),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TaskDetailsScreen(taskId: task.id),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
