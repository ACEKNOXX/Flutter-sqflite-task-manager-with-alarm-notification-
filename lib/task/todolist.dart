import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_demo/task/helpers/db_helper_todos.dart';
import 'package:sqflite_demo/task/helpers/db_helper_tasks.dart';
import 'package:sqflite_demo/task/models/todoModel.dart';
import 'package:sqflite_demo/task/taskList.dart';
import 'package:sqflite_demo/task/widget.dart/todoTab.dart';
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
  String _title;
  String _priority;
  final _formkey = GlobalKey<FormState>();
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
                  showModalBottomSheet<void>(
                      isScrollControlled: true,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
                      )),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      context: context,
                      builder: (context) {
                        return Container(
                          height: 500.0,
                          child: Form(
                            key: _formkey,
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 8.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10.0),
                                          topRight: Radius.circular(10.0))),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Text("Add Task Board",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20.0)),
                                        Container(
                                          padding: EdgeInsets.all(16.0),
                                          child: Column(
                                            children: [
                                              TextFormField(
                                                onChanged: (value) {
                                                  setState(() {
                                                    _title = value;
                                                  });
                                                },
                                                validator: (input) =>
                                                    _title == null
                                                        ? 'required'
                                                        : null,
                                                decoration: InputDecoration(
                                                    hintText: "Task title"),
                                              ),
                                              TextFormField(
                                                onTap: _handleDatPicker,
                                                controller: _dateController,
                                                validator: (input) =>
                                                    _date == null
                                                        ? 'required'
                                                        : null,
                                                decoration: InputDecoration(
                                                    hintText: "Date"),
                                              ),
                                              DropdownButtonFormField(
                                                icon: Icon(Icons
                                                    .arrow_drop_down_circle),
                                                items:
                                                    _priorities.map((priority) {
                                                  return DropdownMenuItem(
                                                    value: priority,
                                                    child: Text(
                                                      priority,
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 18.0),
                                                    ),
                                                  );
                                                }).toList(),
                                                decoration: InputDecoration(
                                                    hintText: "Priority Level"),
                                                validator: (input) => _priority ==
                                                        null
                                                    ? 'Please select a priority level'
                                                    : null,
                                                onSaved: (input) =>
                                                    _priority = input,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _priority = value;
                                                  });
                                                },
                                              ),
                                              SizedBox(
                                                height: 10.0,
                                              ),
                                              Align(
                                                alignment: Alignment.topLeft,
                                                child: Container(
                                                    height: 40.0,
                                                    color: Colors.redAccent,
                                                    child: RaisedButton.icon(
                                                        color: Colors.redAccent,
                                                        onPressed: _submit,
                                                        icon: Icon(
                                                          Icons.check,
                                                          color: Colors.white,
                                                        ),
                                                        label: Text("Submit",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white)))),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      });
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
                      );
                    }),
              ),
            ),
          ],
        ),
      )),
    );
  }

  void _insert() async {
    if (todo == null) {
      // Scaffold.of(context).showSnackBar(SnackBar(
      //   content: Text("Address is not well formatted"),
      // ));
    }

    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelperTodos.columnTaskListId: taskId,
      DatabaseHelperTodos.columnTodoTitle: _title,
      DatabaseHelperTodos.columnPriority: _priority,
      DatabaseHelperTodos.columnStatus: 0
    };
    final id = await dbHelperTodo.insert(row);
    print('inserted row id: $id');
    setState(() {
      todo = null;
    });
    await _query();
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
    // final id = await dbHelperTask.queryRowCount();
    final id = _id;
    final rowsDeleted = await dbHelperTask.delete(id);
    print('deleted $rowsDeleted row(s): row $id');
    // Navigator.pop(context);
  }

  _handleDatPicker() async {
    final DateTime date = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime(200),
        lastDate: DateTime(2100));
    if (date != null && date != _date) {
      setState(() {
        _date = date;
      });
      _dateController.text = _dateFormattter.format(date);
    }
  }

  _submit() async {
    if (_formkey.currentState.validate()) {
      _formkey.currentState.save();
      print("$_title $_date $_priority");
      print("task list id =$taskId");

      // insert the todo to use db
      await _insert();
      // Update the task

      Navigator.pop(context);
    }
  }
}
