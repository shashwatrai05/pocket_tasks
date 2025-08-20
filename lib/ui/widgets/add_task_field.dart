import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/task_provider.dart';

class AddTaskField extends ConsumerStatefulWidget {
  const AddTaskField({super.key});

  @override
  ConsumerState<AddTaskField> createState() => _AddTaskFieldState();
}

class _AddTaskFieldState extends ConsumerState<AddTaskField>
    with TickerProviderStateMixin {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  String? _error;
  bool _isSubmitting = false;
  late AnimationController _submitAnimationController;
  late Animation<double> _submitAnimation;

  @override
  void initState() {
    super.initState();
    _submitAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _submitAnimation = Tween<double>(begin: 1.0, end: 0.8).animate(
      CurvedAnimation(
        parent: _submitAnimationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _submitAnimationController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_isSubmitting) return;

    final text = _controller.text.trim();
    if (text.isEmpty) {
      setState(() => _error = 'Please enter a task title');
      _focusNode.requestFocus();
      return;
    }

    if (text.length > 100) {
      setState(() => _error = 'Task title is too long (max 100 characters)');
      return;
    }

    setState(() {
      _isSubmitting = true;
      _error = null;
    });

    // Animation feedback
    await _submitAnimationController.forward();
    await _submitAnimationController.reverse();

    try {
      ref.read(taskListProvider.notifier).addTask(text);
      _controller.clear();
      
      // Show success feedback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              const Text('Task added successfully!'),
            ],
          ),
          backgroundColor: const Color(0xFF4D55BB),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      setState(() => _error = 'Failed to add task. Please try again.');
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: isDark 
                ? const Color(0xFF0F0F23).withOpacity(0.5)
                : const Color(0xFFF8F9FF),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _error != null
                  ? Colors.red.withOpacity(0.5)
                  : _focusNode.hasFocus
                      ? const Color(0xFF4D55BB).withOpacity(0.3)
                      : const Color(0xFF4D55BB).withOpacity(0.1),
              width: _focusNode.hasFocus ? 2 : 1,
            ),
          ),
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            textInputAction: TextInputAction.done,
            maxLength: 100,
            onSubmitted: (_) => _submit(),
            decoration: InputDecoration(
              hintText: 'What needs to be done?',
              hintStyle: TextStyle(
                color: (isDark ? Colors.white : Colors.black).withOpacity(0.5),
              ),
              prefixIcon: Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF4D55BB).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.edit,
                  color: Color(0xFF4D55BB),
                  size: 20,
                ),
              ),
              suffixIcon: AnimatedBuilder(
                animation: _submitAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _submitAnimation.value,
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      child: Material(
                        color: _isSubmitting
                            ? const Color(0xFF4D55BB).withOpacity(0.3)
                            : const Color(0xFF4D55BB),
                        borderRadius: BorderRadius.circular(12),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: _isSubmitting ? null : _submit,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            child: _isSubmitting
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              counterText: '', // Hide character counter
            ),
          ),
        ),
        if (_error != null)
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 16),
            child: Row(
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 16,
                  color: Colors.red,
                ),
                const SizedBox(width: 4),
                Text(
                  _error!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}