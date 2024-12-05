import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_todos/provider/filter_provider.dart';
import 'package:riverpod_todos/provider/todo_provider.dart';
import 'package:riverpod_todos/provider/uncompleted_todos_count_provider.dart';

class TodoScreen extends ConsumerStatefulWidget {
  const TodoScreen({super.key});

  @override
  ConsumerState<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends ConsumerState<TodoScreen> {
  final TextEditingController todoController = TextEditingController();

  @override
  void dispose() {
    todoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final todos = ref.watch(filteredTodosProvider);
    final filter = ref.watch(todoListFilter);
    Color? textColorFor(TodoListFilter value) {
      return filter == value ? Colors.blue : Colors.black;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        children: [
          const Title(),
          TextFormField(
            controller: todoController,
            decoration: const InputDecoration(
              labelText: 'What needs to be done?',
            ),
            onFieldSubmitted: (value) {
              ref.read(todoListProvider.notifier).add(value);
              todoController.clear();
            },
          ),
          const SizedBox(height: 42),
          Row(
            children: [
              Expanded(
                child: Text(
                  '${ref.watch(uncompletedTodosCountProvider)} items left',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Tooltip(
                message: 'All todos',
                child: TextButton(
                  onPressed: () => ref.read(todoListFilter.notifier).state =
                      TodoListFilter.all,
                  style: TextButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                      foregroundColor: textColorFor(TodoListFilter.all)),
                  child: const Text('All'),
                ),
              ),
              Tooltip(
                message: 'Active todos',
                child: TextButton(
                  onPressed: () => ref.read(todoListFilter.notifier).state =
                      TodoListFilter.active,
                  style: TextButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                      foregroundColor: textColorFor(TodoListFilter.active)),
                  child: const Text('Active'),
                ),
              ),
              Tooltip(
                message: 'Completed todos',
                child: TextButton(
                  onPressed: () => ref.read(todoListFilter.notifier).state =
                      TodoListFilter.completed,
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    foregroundColor: textColorFor(TodoListFilter.completed),
                  ),
                  child: const Text('Completed'),
                ),
              ),
            ],
          ),
          if (todos.isNotEmpty) const Divider(height: 0),
          for (final todo in todos) ...[
            const Divider(height: 0),
            Dismissible(
              key: ValueKey(todo.id),
              onDismissed: (direction) =>
                  ref.read(todoListProvider.notifier).remove(todo),
              child: Material(
                color: Colors.white,
                child: ListTile(
                  leading: Checkbox(
                    value: todo.completed,
                    onChanged: (value) {
                      ref.read(todoListProvider.notifier).toggle(todo.id);
                    },
                  ),
                  title: Text(todo.description),
                ),
              ),
            )
          ]
        ],
      ),
    );
  }
}

class Title extends StatelessWidget {
  const Title({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'todos',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Color.fromARGB(38, 47, 47, 247),
        fontSize: 100,
        fontWeight: FontWeight.w700,
        fontFamily: 'Helvetica Neue',
      ),
    );
  }
}
