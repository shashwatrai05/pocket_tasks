import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_tasks/ui/widgets/task_list.dart';
import '../../core/utils/debouncer.dart';
import '../../providers/task_provider.dart';
import '../widgets/add_task_field.dart';
import '../widgets/filter_chips.dart';
import '../widgets/progress_ring.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _searchController = TextEditingController();
  late final Debouncer _debouncer;

  @override
  void initState() {
    super.initState();
    _debouncer = Debouncer(milliseconds: 300);
    _searchController.addListener(() {
      _debouncer(() {
        ref.read(searchQueryProvider.notifier).state =
            _searchController.text.trim();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ratio = ref.watch(completionRatioProvider);
    final allTasks = ref.watch(taskListProvider);
    final filtered = ref.watch(filteredTasksProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('PocketTasks'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: ProgressRing(progress: ratio),
          ),
        ],
      ),
      body: Column(
        children: [
          // Add
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: const AddTaskField(),
          ),

          // Search
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search tasks...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),

          // Filters + counts
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 6),
            child: Row(
              children: [
                const Expanded(child: FilterChipsRow()),
                const SizedBox(width: 12),
                Text(
                  '${filtered.length}/${allTasks.length}',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // List
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: const _ListHolder(),
            ),
          ),
        ],
      ),
    );
  }
}

class _ListHolder extends StatelessWidget {
  const _ListHolder();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 4),
      child: _AnimatedListContainer(),
    );
  }
}

class _AnimatedListContainer extends ConsumerWidget {
  const _AnimatedListContainer();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // A simple AnimatedSwitcher for pleasant transitions
    final tasks = ref.watch(filteredTasksProvider);
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: tasks.isEmpty
          ? Center(
              key: const ValueKey('empty'),
              child: Text(
                'No tasks yet',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            )
          : const _ListContent(key: ValueKey('list')),
    );
  }
}

class _ListContent extends StatelessWidget {
  const _ListContent({super.key});

  @override
  Widget build(BuildContext context) {
    // Separated out to avoid re-building AnimatedSwitcher child
    return const Padding(
      padding: EdgeInsets.only(top: 4),
      child: _TaskListView(),
    );
  }
}

class _TaskListView extends ConsumerWidget {
  const _TaskListView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Uses ListView.builder for efficiency with 100+ items
    return const Expanded(child: TaskList());
  }
}
