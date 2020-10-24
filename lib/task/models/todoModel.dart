import 'package:flutter/scheduler.dart';

class TodoModel {
  TodoModel({
    this.id,
    this.taskListId,
    this.todoTitle,
    this.priority,
    this.status
  });
  final id,
  taskListId,
  todoTitle,
  priority,
  status;

}