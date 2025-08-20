import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/task_provider.dart';

class AddTaskField extends ConsumerStatefulWidget {
  const AddTaskField({super.key});

  @override
  ConsumerState<AddTaskField> createState() => _AddTaskFieldState();
}

class _AddTaskFieldState extends ConsumerState<AddTaskField> {
  final _controller = TextEditingController();
  String? _error;

  void _submit() {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      setState(() => _error = 'Title cannot be empty');
      return;
    }
    ref.read(taskListProvider.notifier).addTask(text);
    _controller.clear();
    setState(() => _error = null);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      textInputAction: TextInputAction.done,
      onSubmitted: (_) => _submit(),
      decoration: InputDecoration(
        hintText: 'Add a task...',
        errorText: _error,
        prefixIcon: const Icon(Icons.add_task),
        suffixIcon: IconButton(
          icon: const Icon(Icons.send),
          onPressed: _submit,
          tooltip: 'Add',
        ),
        border: const OutlineInputBorder(),
      ),
    );
  }
}
