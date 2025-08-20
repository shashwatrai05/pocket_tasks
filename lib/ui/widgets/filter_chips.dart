import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/task_provider.dart';

class FilterChipsRow extends ConsumerWidget {
  const FilterChipsRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(filterProvider);

    FilterChip buildChip(FilterType type, String label, IconData icon) {
      final selected = filter == type;
      return FilterChip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16),
            const SizedBox(width: 6),
            Text(label),
          ],
        ),
        selected: selected,
        onSelected: (_) => ref.read(filterProvider.notifier).state = type,
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: [
        buildChip(FilterType.all, 'All', Icons.all_inclusive),
        buildChip(FilterType.active, 'Active', Icons.radio_button_unchecked),
        buildChip(FilterType.done, 'Done', Icons.check_circle),
      ],
    );
  }
}
