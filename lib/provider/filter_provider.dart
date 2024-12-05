import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_todos/model/todo.dart';
import 'package:riverpod_todos/provider/todo_provider.dart';

part 'filter_provider.g.dart';

enum TodoListFilter {
  all,
  active,
  completed,
}

final todoListFilter =
    StateProvider<TodoListFilter>((ref) => TodoListFilter.all);

@riverpod
List<Todo> filteredTodos(ref) {
  final filter = ref.watch(todoListFilter);
  final todos = ref.watch(todoListProvider);

  switch (filter) {
    case TodoListFilter.completed:
      return todos.where((todo) => todo.completed == true).toList();
    case TodoListFilter.active:
      return todos.where((todo) => todo.completed == false).toList();
    default:
      return todos;
  }
}
