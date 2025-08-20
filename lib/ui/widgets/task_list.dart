import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/task_provider.dart';
import '../../models/task.dart';

class TaskList extends ConsumerWidget {
  const TaskList({super.key});

  void _showUndoSnackBar(
    BuildContext context,
    WidgetRef ref, {
    required String message,
  }) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          action: SnackBarAction(
            label: 'UNDO',
            onPressed: () {
              ref.read(taskListProvider.notifier).undoLastAction();
            },
          ),
          duration: const Duration(seconds: 3),
        ),
      );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(filteredTasksProvider);

    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final t = tasks[index];
        return Dismissible(
          key: ValueKey(t.id),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            color: Theme.of(context).colorScheme.errorContainer,
            child: Icon(
              Icons.delete,
              color: Theme.of(context).colorScheme.onErrorContainer,
            ),
          ),
          onDismissed: (_) {
            ref.read(taskListProvider.notifier).deleteTask(t.id);
            _showUndoSnackBar(context, ref, message: 'Task deleted');
          },
          child: ListTile(
            leading: Icon(
              t.done ? Icons.check_circle : Icons.radio_button_unchecked,
              color: t.done
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.outline,
            ),
            title: Text(
              t.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: t.done
                  ? const TextStyle(
                      decoration: TextDecoration.lineThrough,
                      fontStyle: FontStyle.italic,
                    )
                  : null,
            ),
            subtitle: Text(
              _subtitleFromTask(t),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            onTap: () {
              ref.read(taskListProvider.notifier).toggleTask(t.id);
              _showUndoSnackBar(
                context,
                ref,
                message: t.done ? 'Marked as active' : 'Marked as done',
              );
            },
          ),
        );
      },
    );
  }

  String _subtitleFromTask(Task t) {
    final date = t.createdAt;
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    final hh = date.hour.toString().padLeft(2, '0');
    final mm = date.minute.toString().padLeft(2, '0');
    return 'Created $y-$m-$d $hh:$mm';
  }
}
