import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_todos/provider/todo_provider.dart';

part 'uncompleted_todos_count_provider.g.dart';

@riverpod
int uncompletedTodosCount(ref) {
  return ref
      .watch(todoListProvider)
      .where((todo) => todo.completed == false)
      .length;
}
