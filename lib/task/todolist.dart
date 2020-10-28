import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_demo/task/helpers/db_helper_todos.dart';
import 'package:sqflite_demo/task/helpers/db_helper_tasks.dart';
import 'package:sqflite_demo/task/models/todoModel.dart';
import 'package:sqflite_demo/task/taskList.dart';
import 'package:sqflite_demo/task/widget.dart/todoTab.dart';
import 'package:sqflite_demo/task/addTodos.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'widget.dart/taskTab.dart';
import 'constraints.dart';

class TodoList extends StatefulWidget {
  final taskListId;
  final taskTitle;
  TodoList({this.taskListId, this.taskTitle});
  @override
  _TodoListState createState() => _TodoListState(taskId: taskListId);
}

class _TodoListState extends State<TodoList> {
  _TodoListState({this.taskId});
  final taskId;

  DateTime _date = DateTime.now();
  TextEditingController _dateController = TextEditingController();
  final DateFormat _dateFormattter = DateFormat("MMM dd, yyyy");
  final List<String> _priorities = ['Low', 'Medium', 'High'];

  final dbHelperTask = DatabaseHelperTask.instance;
  final dbHelperTodo = DatabaseHelperTodos.instance;
  var todo;
  List<TodoModel> savedTasks = [
    TodoModel(
        id: 0,
        taskListId: 0,
        todoTitle: "Welcome first todo",
        priority: "High",
        status: 0)
  ];

  @override
  void initState() {
    super.initState();
    _dateController.text = _dateFormattter.format(_date);
    _query();
  }

  // @override
  // void dispose() {
  //   _dateController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          width: 100.0,
          child: FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.chevron_left, size: 25.0, color: kBlackColor),
          ),
        ),
        actions: [
          Container(
            child: IconButton(
                color: kDangerColor,
                icon: Icon(Icons.add),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddTodos(
                              taskId: taskId, taskTitle: widget.taskTitle)));
                }),
          )
        ],
      ),
      body: SafeArea(
          child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 10.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 150.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                            child: Text(
                          "My Todos",
                          style: TextStyle(
                              fontFamily: "PTSans",
                              fontSize: 40.0,
                              fontWeight: FontWeight.bold),
                        )),
                        IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () async {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(
                                          "Are you sure you wnat to delete task list"),
                                      actions: [
                                        FlatButton(
                                            onPressed: () async {
                                              await _delete(widget.taskListId);
                                              print(widget.taskListId);
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (contex) =>
                                                          TaskList()));
                                            },
                                            child: Text("Yes")),
                                        FlatButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text("No"))
                                      ],
                                    );
                                  });
                            })
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Task Title :${widget.taskTitle}"),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FlatButton.icon(
                  onPressed: _query,
                  icon: Icon(Icons.refresh),
                  label: Text("refresh"),
                )
              ],
            ),
            Expanded(
              child: Container(
                // color: Colors.red,
                child: ListView.builder(
                    itemCount: savedTasks.length,
                    itemBuilder: (BuildContext context, index) {
                      var i = savedTasks.length - index;
                      var indx = i - 1;
                      print(indx);
                      print(savedTasks[indx].todoTitle);
                      return Todo(
                          id: savedTasks[indx].id,
                          colour: Color(0xFF212121),
                          title: savedTasks[indx].todoTitle,
                          date: "",
                          status: false,
                          onpressed: () async{
                            int id = savedTasks[indx].id;
                            print("Index ${savedTasks[indx].id}");
                            await _deleteIdOne(id);
                            Navigator.push(
                            context, MaterialPageRoute(builder: (context) =>TaskList()  ));
                          });
                    }),
              ),
            ),
          ],
        ),
      )),
    );
  }

  void _query() async {
    // final allRows = await dbHelperTodo.queryAllRows();
    final allRows = await dbHelperTodo.queryAll(taskId);

    setState(() {
      setState(() {
        savedTasks = [];
      });
    });
    print('query all rows:');
    allRows.forEach((row) {
      var tasksModel = TodoModel(
          id: row['_id'],
          taskListId: row['_taskListId'],
          todoTitle: row['todoTitle'],
          priority: row['priority'],
          status: row['status']);
      savedTasks.add(tasksModel);
    });
    print(savedTasks.length);
  }

  void _update() async {
    // row to update
    Map<String, dynamic> row = {
      DatabaseHelperTask.columnId: 1,
      DatabaseHelperTask.columnTitle: 'Mary',
      DatabaseHelperTask.columnStatus: 32
    };
    final rowsAffected = await dbHelperTask.update(row);
    print('updated $rowsAffected row(s)');
  }

  void _delete(_id) async {
    // Assuming that the number of rows is the id for the last row.
    final id = _id;
    final rowsDeleted = await dbHelperTask.delete(id);
    print('deleted $rowsDeleted row(s): row $id');
    // Navigator.pop(context);
  }

  void _deleteIdOne(_id) async {
    final id = _id;
    final rowsDeleted = await dbHelperTodo.delete(id);
    print('deleted $rowsDeleted row(s): row $id');
  }
}
