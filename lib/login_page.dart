import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  int _difficultyLevel = 1;
  double _progress = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar e Visualizar Habilidades'),
        iconTheme: IconThemeData(color: Colors.white), // Define a cor do ícone como branca
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSkillForm(isEditing: false),
            SizedBox(height: 16),
            Text(
              'Histórico de Habilidades',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            _buildSkillList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillForm({required bool isEditing}) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(blurRadius: 3, color: Colors.grey.shade300)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: 'Título da Habilidade',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(
              labelText: 'Descrição Breve',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          SizedBox(height: 16),
          Text('Nível de Dificuldade:'),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: List<Widget>.generate(4, (index) {
              return Row(
                children: [
                  Radio(
                    value: index + 1,
                    groupValue: _difficultyLevel,
                    onChanged: (value) {
                      setState(() {
                        _difficultyLevel = value as int;
                      });
                    },
                    activeColor: _getDifficultyColor(index + 1),
                  ),
                  Text('${index + 1}'),
                ],
              );
            }),
          ),
          SizedBox(height: 16),
          Text('Progresso: ${(_progress * 100).toStringAsFixed(0)}%'),
          Slider(
            value: _progress,
            min: 0.0,
            max: 1.0,
            divisions: 10,
            label: '${(_progress * 100).toStringAsFixed(0)}%',
            onChanged: (value) {
              setState(() {
                _progress = value;
              });
            },
          ),
          SizedBox(height: 16),
          if (!isEditing)
            Center( // Centraliza o botão
              child: ElevatedButton(
                onPressed: _saveSkill,
                child: Text('Salvar Habilidade'),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSkillList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('habilidades').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

        final skills = snapshot.data!.docs;

        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: skills.length,
          itemBuilder: (context, index) {
            final skill = skills[index];
            final skillId = skill.id;
            final skillData = skill.data() as Map<String, dynamic>;

            return Card(
              margin: EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                contentPadding: EdgeInsets.all(8.0),
                title: Text(skillData['titulo']),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Dificuldade: ${skillData['nivel']} - ${skillData['descricao']}'),
                    Text('Progresso: ${(skillData['progresso'] * 100).toStringAsFixed(0)}%'),
                    LinearProgressIndicator(
                      value: skillData['progresso'],
                      color: skillData['progresso'] == 1.0 ? Colors.green : Colors.blue,
                      backgroundColor: Colors.grey[300],
                    ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {
                        _editSkill(skillId, skillData);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        _deleteSkill(skillId);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _saveSkill() async {
    final String title = _titleController.text;
    final String description = _descriptionController.text;

    await FirebaseFirestore.instance.collection('habilidades').add({
      'titulo': title,
      'descricao': description,
      'nivel': _difficultyLevel,
      'progresso': _progress,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Habilidade salva com sucesso!')),
    );
  }

  void _editSkill(String skillId, Map<String, dynamic> skillData) async {
    _titleController.text = skillData['titulo'];
    _descriptionController.text = skillData['descricao'];
    _difficultyLevel = skillData['nivel'];
    _progress = skillData['progresso'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Editar Habilidade'),
        content: SingleChildScrollView(
          child: StatefulBuilder(
            builder: (context, setState) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(labelText: 'Título da Habilidade'),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: 'Descrição Breve'),
                  maxLines: 3,
                ),
                SizedBox(height: 16),
                Text('Nível de Dificuldade:'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: List<Widget>.generate(4, (index) {
                    return Row(
                      children: [
                        Radio(
                          value: index + 1,
                          groupValue: _difficultyLevel,
                          onChanged: (value) {
                            setState(() {
                              _difficultyLevel = value as int;
                            });
                          },
                          activeColor: _getDifficultyColor(index + 1),
                        ),
                        Text('${index + 1}'),
                      ],
                    );
                  }),
                ),
                SizedBox(height: 16),
                Text('Progresso: ${(_progress * 100).toStringAsFixed(0)}%'),
                Slider(
                  value: _progress,
                  min: 0.0,
                  max: 1.0,
                  divisions: 10,
                  label: '${(_progress * 100).toStringAsFixed(0)}%',
                  onChanged: (value) {
                    setState(() {
                      _progress = value;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await FirebaseFirestore.instance.collection('habilidades').doc(skillId).update({
                'titulo': _titleController.text,
                'descricao': _descriptionController.text,
                'nivel': _difficultyLevel,
                'progresso': _progress,
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Habilidade atualizada com sucesso!')),
              );
            },
            child: Text('Salvar'),
          ),
        ],
      ),
    );
  }

  void _deleteSkill(String skillId) async {
    await FirebaseFirestore.instance.collection('habilidades').doc(skillId).delete();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Habilidade excluída com sucesso!')),
    );
  }

  Color _getDifficultyColor(int level) {
    switch (level) {
      case 1:
      case 2:
        return Colors.green;
      case 3:
        return Colors.amber;
      case 4:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
