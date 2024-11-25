import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditTaskScreen extends StatefulWidget {
  final String taskId;
  final String initialTitle;
  final String initialDescription;

  const EditTaskScreen({
    super.key,
    required this.taskId,
    required this.initialTitle,
    required this.initialDescription,
  });

  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.initialTitle;
    _descriptionController.text = widget.initialDescription;
  }

  Future<void> _updateTask() async {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();

    if (title.isEmpty || description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos!')),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      await _firestore.collection('tasks').doc(widget.taskId).update({
        'title': title,
        'description': description,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tarefa atualizada com sucesso!')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao atualizar tarefa: $e')),
      );
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Tarefa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Título'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Descrição'),
              maxLines: 4,
            ),
            const SizedBox(height: 32),
            if (_isSaving)
              const CircularProgressIndicator()
            else
              ElevatedButton(
                onPressed: _updateTask,
                child: const Text('Salvar Alterações'),
              ),
          ],
        ),
      ),
    );
  }
}
