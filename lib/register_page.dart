import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final List<Skill> _skills = []; // Lista para armazenar as habilidades

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Minhas Habilidades'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _skills.length,
                itemBuilder: (context, index) {
                  return _buildSkillCard(_skills[index], index);
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Ação para navegar para a página de adicionar habilidades
                Navigator.pop(context);
              },
              child: Text('Adicionar Habilidade'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillCard(Skill skill, int index) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              skill.title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(skill.description),
            SizedBox(height: 8),
            Text('Dificuldade: ${skill.difficulty}'),
            SizedBox(height: 8),
            Text('Progresso: ${((skill.progress) * 100).toStringAsFixed(0)}%'),
            LinearProgressIndicator(value: skill.progress),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _editProgress(index);
                  },
                  child: Text('Editar Progresso'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _deleteSkill(index);
                  },
                  child: Text('Excluir'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _editProgress(int index) {
    // Mostra um diálogo para editar o progresso
    showDialog(
      context: context,
      builder: (context) {
        double newProgress = _skills[index].progress;
        return AlertDialog(
          title: Text('Editar Progresso'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Insira o novo progresso (0-100):'),
              TextField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  newProgress = double.tryParse(value)! / 100;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _skills[index].progress = newProgress;
                });
                Navigator.pop(context);
              },
              child: Text('Salvar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  void _deleteSkill(int index) {
    setState(() {
      _skills.removeAt(index); // Remove a habilidade da lista
    });
  }

  // Método para adicionar habilidades à lista
  void addSkill(Skill skill) {
    setState(() {
      _skills.add(skill);
    });
  }
}

// Classe para representar uma habilidade
class Skill {
  String title;
  String description;
  int difficulty;
  double progress;

  Skill({
    required this.title,
    required this.description,
    required this.difficulty,
    this.progress = 0.0,
  });
}
