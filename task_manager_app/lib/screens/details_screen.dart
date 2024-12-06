import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'edit_task_screen.dart';

class TaskDetailsScreen extends StatelessWidget {
  final String taskId;

  const TaskDetailsScreen({super.key, required this.taskId});

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes da Tarefa'),
        centerTitle: true,
        backgroundColor: const Color(0xFFC4A7E7),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            tooltip: 'Editar Tarefa',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditTaskScreen(
                    taskId: taskId,
                    initialTitle: '', // Carregará os dados iniciais na tela
                    initialDescription: '',
                  ),
                ),
              );
            },
          ),
        ],
      ),
      backgroundColor: const Color(0xFFF8F9FA),
      body: FutureBuilder<DocumentSnapshot>(
        future: firestore.collection('tasks').doc(taskId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError ||
              !snapshot.hasData ||
              !snapshot.data!.exists) {
            return const Center(
              child: Text(
                'Erro ao carregar os detalhes da tarefa.',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          final taskData = snapshot.data!.data() as Map<String, dynamic>;
          final title = taskData['title'] ?? 'Sem título';
          final description = taskData['description'] ?? 'Sem descrição';
          final createdAt = taskData['created_at']?.toDate();
          final currentStatus = taskData['status'] ?? false;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2D2D2D),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  description,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: const Color(0xFF6C757D),
                  ),
                ),
                const SizedBox(height: 16),
                if (createdAt != null)
                  Text(
                    'Criada em: ${createdAt.day}/${createdAt.month}/${createdAt.year}',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF6C757D),
                    ),
                  ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () async {
                    await firestore.collection('tasks').doc(taskId).update({
                      'status': !currentStatus,
                    });
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/main', (route) => false);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                    backgroundColor: currentStatus
                        ? const Color(0xFFDC3545)
                        : const Color(0xFF28A745),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    currentStatus
                        ? 'Marcar como Pendente'
                        : 'Marcar como Concluída',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
