import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/task_provider.dart';

class FilterChipsRow extends ConsumerWidget {
  const FilterChipsRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(filterProvider);
    final allTasks = ref.watch(taskListProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Calculate counts for each filter
    final activeTasks = allTasks.where((task) => !task.done).length;
    final doneTasks = allTasks.where((task) => task.done).length;
    final totalTasks = allTasks.length;

    Widget buildChip(FilterType type, String label, IconData icon, int count) {
      final selected = filter == type;
      return AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => ref.read(filterProvider.notifier).state = type,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                gradient: selected
                    ? const LinearGradient(
                        colors: [
                          Color(0xFF4D55BB),
                          Color(0xFF6366F1),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: selected
                    ? null
                    : isDark
                        ? const Color(0xFF0F0F23).withOpacity(0.5)
                        : const Color(0xFFF8F9FF),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: selected
                      ? Colors.transparent
                      : const Color(0xFF4D55BB).withOpacity(0.2),
                  width: 1.5,
                ),
                boxShadow: selected
                    ? [
                        BoxShadow(
                          color: const Color(0xFF4D55BB).withOpacity(0.3),
                          offset: const Offset(0, 4),
                          blurRadius: 12,
                          spreadRadius: 0,
                        ),
                      ]
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: selected
                          ? Colors.white.withOpacity(0.2)
                          : const Color(0xFF4D55BB).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      icon,
                      size: 16,
                      color: selected
                          ? Colors.white
                          : const Color(0xFF4D55BB),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: TextStyle(
                      color: selected
                          ? Colors.white
                          : isDark
                              ? Colors.white
                              : const Color(0xFF1A1A2E),
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  if (count > 0) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: selected
                            ? Colors.white.withOpacity(0.2)
                            : const Color(0xFF4D55BB).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        count.toString(),
                        style: TextStyle(
                          color: selected
                              ? Colors.white
                              : const Color(0xFF4D55BB),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        buildChip(FilterType.all, 'All', Icons.view_list, totalTasks),
        buildChip(FilterType.active, 'Active', Icons.radio_button_unchecked, activeTasks),
        buildChip(FilterType.done, 'Complete', Icons.check_circle, doneTasks),
      ],
    );
  }
}