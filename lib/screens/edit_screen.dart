import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../providers/auth_provider.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class EditScreen extends StatefulWidget {
  final Task? task;

  const EditScreen({Key? key, this.task}) : super(key: key);

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  String _selectedFont = 'Arial';
  double _fontSize = 16;
  String _tileColor = '0xFFFFFFFF';
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _contentController.text = widget.task!.content;
      _selectedFont = widget.task!.font;
      _fontSize = widget.task!.fontSize;
      _tileColor = widget.task!.color;
      _isCompleted = widget.task!.isCompleted == 1;
    }
  }

  // Function to validate and convert color
  String? _validateColor(String color) {
    try {
      // Remove 0x prefix before parsing
      String colorHex = color.startsWith('0x') ? color.substring(2) : color;
      Color(int.parse(colorHex, radix: 16)); // Try to parse hex color
      return null; // Valid color
    } catch (e) {
      return 'Nieprawidłowy format koloru';
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<AuthProvider>(context, listen: false).currentUser!.id;

    return Scaffold(
      appBar: AppBar(title: const Text('Edycja zadania'),backgroundColor: Colors.deepPurple,),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Tytuł'),
            ),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(labelText: 'Zawartość'),
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: _selectedFont,
              items: const [
                DropdownMenuItem(value: 'Arial', child: Text('Arial')),
                DropdownMenuItem(value: 'Times New Roman', child: Text('Times New Roman')),
                DropdownMenuItem(value: 'Roboto', child: Text('Roboto')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedFont = value!;
                });
              },
              isExpanded: true,
              hint: const Text('Wybierz czcionkę'),
            ),
            const Text(
              'Ustaw rozmiar czcionki',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            Slider(
              value: _fontSize,
              min: 12,
              max: 36,
              divisions: 24,
              label: _fontSize.toStringAsFixed(1),
              onChanged: (value) {
                setState(() {
                  _fontSize = value;
                });
              },
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Zadanie zostało ukończone'),
                Switch(
                  value: _isCompleted,
                  onChanged: (value) {
                    setState(() {
                      _isCompleted = value;
                    });
                  },
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () async {
                final color = await showDialog<int>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Kolor Zadania'),
                    content: SingleChildScrollView(
                      child: BlockPicker(
                        pickerColor: Color(int.parse(_tileColor)),
                        onColorChanged: (color) {
                          Navigator.pop(context, color.value);
                        },
                      ),
                    ),
                  ),
                );
                if (color != null) {
                  String colorHex = '0x${color.toRadixString(16)}';
                  final validationMessage = _validateColor(colorHex);
                  if (validationMessage == null) {
                    setState(() {
                      _tileColor = colorHex;  // Update color
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(validationMessage)),
                    );
                  }
                }
              },
              child: const Text('Kolor Zadania'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple, // Button background color
                foregroundColor: Colors.white, // Text color
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final task = Task(
                  id: widget.task?.id ?? 0,
                  title: _titleController.text.trim(),
                  content: _contentController.text.trim(),
                  font: _selectedFont,
                  fontSize: _fontSize,
                  color: _tileColor,
                  isCompleted: _isCompleted ? 1 : 0, // Convert to integer
                  userId: userId,
                );
                if (widget.task == null) {
                  Provider.of<TaskProvider>(context, listen: false).addTask(task);
                } else {
                  Provider.of<TaskProvider>(context, listen: false).updateTask(task);
                }
                Navigator.pop(context);
              },
              child: const Text('Zapisz zadanie'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple, // Button background color
                foregroundColor: Colors.white, // Text color
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
