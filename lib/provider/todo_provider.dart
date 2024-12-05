import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_todos/model/todo.dart';
import 'package:uuid/uuid.dart';

part 'todo_provider.g.dart';

const _uuid = Uuid();

@riverpod
class TodoList extends _$TodoList {
  @override
  List<Todo> build() => [];

  void add(String description) {
    state = [
      ...state,
      Todo(id: _uuid.v4(), description: description),
    ];
  }

  void toggle(String id) {
    state = [
      for (final todo in state)
        if (todo.id == id)
          Todo(
              id: todo.id,
              description: todo.description,
              completed: !todo.completed)
        else
          todo
    ];
  }

  void remove(Todo target) {
    state = state.where((todo) => todo.id != target.id).toList();
  }
}
