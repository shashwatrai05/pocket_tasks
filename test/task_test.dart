import 'package:flutter_test/flutter_test.dart';
import 'package:pocket_tasks/models/task.dart';
import 'package:pocket_tasks/providers/task_provider.dart';

void main() {
  group('Search + Filter', () {
    final now = DateTime(2025, 1, 1, 12, 0);
    final tasks = <Task>[
      Task(id: '1', title: 'Buy milk', done: false, createdAt: now),
      Task(id: '2', title: 'Walk the dog', done: true, createdAt: now.add(const Duration(minutes: 1))),
      Task(id: '3', title: 'Make dinner', done: false, createdAt: now.add(const Duration(minutes: 2))),
      Task(id: '4', title: 'Email boss', done: true, createdAt: now.add(const Duration(minutes: 3))),
    ];

    test('All + empty query returns all, newest first', () {
      final result = applyFilters(tasks: tasks, filter: FilterType.all, query: '');
      expect(result.length, 4);
      expect(result.first.id, '4'); // newest first
    });

    test('Active filter returns only undone', () {
      final result = applyFilters(tasks: tasks, filter: FilterType.active, query: '');
      expect(result.map((t) => t.id), containsAll(['1', '3']));
      expect(result.length, 2);
    });

    test('Done filter returns only done', () {
      final result = applyFilters(tasks: tasks, filter: FilterType.done, query: '');
      expect(result.map((t) => t.id), containsAll(['2', '4']));
      expect(result.length, 2);
    });

    test('Text query filters by title (case-insensitive)', () {
      final result = applyFilters(tasks: tasks, filter: FilterType.all, query: 'dog');
      expect(result.length, 1);
      expect(result.first.title, 'Walk the dog');
    });

    test('Combined: Active + query', () {
      final result = applyFilters(tasks: tasks, filter: FilterType.active, query: 'make');
      expect(result.length, 1);
      expect(result.first.id, '3');
    });
  });
}
