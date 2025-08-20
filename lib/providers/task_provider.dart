import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/task_repository.dart';
import '../models/task.dart';

enum FilterType { all, active, done }

/// Exposed for testing.
List<Task> applyFilters({
  required List<Task> tasks,
  required FilterType filter,
  required String query,
}) {
  Iterable<Task> list = tasks;
  switch (filter) {
    case FilterType.active:
      list = list.where((t) => !t.done);
      break;
    case FilterType.done:
      list = list.where((t) => t.done);
      break;
    case FilterType.all:
      break;
  }
  if (query.trim().isNotEmpty) {
    final q = query.toLowerCase();
    list = list.where((t) => t.title.toLowerCase().contains(q));
  }
  // Stable order: newest first for better UX
  final res = list.toList()
    ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  return res;
}

// Providers
final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return TaskRepository();
});

final taskListProvider =
    StateNotifierProvider<TaskNotifier, List<Task>>((ref) {
  return TaskNotifier(ref);
});

final filterProvider = StateProvider<FilterType>((_) => FilterType.all);
final searchQueryProvider = StateProvider<String>((_) => '');

final filteredTasksProvider = Provider<List<Task>>((ref) {
  final tasks = ref.watch(taskListProvider);
  final filter = ref.watch(filterProvider);
  final query = ref.watch(searchQueryProvider);
  return applyFilters(tasks: tasks, filter: filter, query: query);
});

final completionRatioProvider = Provider<double>((ref) {
  final tasks = ref.watch(taskListProvider);
  if (tasks.isEmpty) return 0.0;
  final done = tasks.where((t) => t.done).length;
  return done / max(tasks.length, 1);
});

/// Undo support
enum _LastActionType { none, delete, toggle }

class _LastAction {
  final _LastActionType type;
  final Task? taskSnapshot; // for delete
  final int? insertIndex; // for delete
  final String? toggledId; // for toggle
  final bool? previousDone; // for toggle

  const _LastAction.none()
      : type = _LastActionType.none,
        taskSnapshot = null,
        insertIndex = null,
        toggledId = null,
        previousDone = null;

  const _LastAction.delete(this.taskSnapshot, this.insertIndex)
      : type = _LastActionType.delete,
        toggledId = null,
        previousDone = null;

  const _LastAction.toggle(this.toggledId, this.previousDone)
      : type = _LastActionType.toggle,
        taskSnapshot = null,
        insertIndex = null;
}

class TaskNotifier extends StateNotifier<List<Task>> {
  final Ref ref;
  _LastAction _lastAction = const _LastAction.none();

  TaskNotifier(this.ref) : super([]) {
    _load();
  }

  Future<void> _load() async {
    state = await ref.read(taskRepositoryProvider).load();
  }

  Future<void> _persist() async {
    await ref.read(taskRepositoryProvider).save(state);
  }

  String _generateId() =>
      '${DateTime.now().microsecondsSinceEpoch}-${Random().nextInt(1 << 32)}';

  void addTask(String title) {
    final trimmed = title.trim();
    if (trimmed.isEmpty) return;
    final task = Task(
      id: _generateId(),
      title: trimmed,
      createdAt: DateTime.now(),
      done: false,
    );
    state = [...state, task];
    _lastAction = const _LastAction.none();
    _persist();
  }

  /// Toggle with undo support
  void toggleTask(String id) {
    final idx = state.indexWhere((t) => t.id == id);
    if (idx == -1) return;
    final prev = state[idx];
    state = [
      for (final t in state)
        t.id == id ? t.copyWith(done: !t.done) : t,
    ];
    _lastAction = _LastAction.toggle(id, prev.done);
    _persist();
  }

  /// Delete with undo support
  void deleteTask(String id) {
    final idx = state.indexWhere((t) => t.id == id);
    if (idx == -1) return;
    final snapshot = state[idx];
    final newList = [...state]..removeAt(idx);
    state = newList;
    _lastAction = _LastAction.delete(snapshot, idx);
    _persist();
  }

  /// Undo last toggle/delete
  void undoLastAction() {
    switch (_lastAction.type) {
      case _LastActionType.toggle:
        final id = _lastAction.toggledId!;
        final prevDone = _lastAction.previousDone!;
        state = [
          for (final t in state)
            t.id == id ? t.copyWith(done: prevDone) : t,
        ];
        break;
      case _LastActionType.delete:
        final t = _lastAction.taskSnapshot!;
        final idx = _lastAction.insertIndex!;
        final newList = [...state];
        if (idx <= newList.length) {
          newList.insert(idx, t);
        } else {
          newList.add(t);
        }
        state = newList;
        break;
      case _LastActionType.none:
        break;
    }
    _lastAction = const _LastAction.none();
    _persist();
  }
}
