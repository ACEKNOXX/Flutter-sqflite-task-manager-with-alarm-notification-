import 'dart:ui';
import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_demo/task/models/taskModel.dart';
import 'widget.dart/taskTab.dart';
import 'constraints.dart';
import 'package:sqflite_demo/db_helper.dart';
import 'package:sqflite_demo/task/helpers/db_helper_tasks.dart';

class TaskList extends StatefulWidget {
  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  var searchTask = "";

  final dbHelperTask = DatabaseHelperTask.instance;
  var task;
  List<TaskModel> savedTasks = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _query();
  }

  @override
  Widget build(BuildContext context) {
    var currDt = new DateTime.now();
    var now = "${currDt.day}/${currDt.month}/${currDt.year}";
    var nowTask = DateFormat.yMMMMEEEEd().format(currDt);
    return Scaffold(
      appBar: AppBar(
        actions: [],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Add task"),
                  content: TextFormField(
                    decoration: InputDecoration(hintText: "Task title"),
                    onChanged: (val) {
                      setState(() {
                        task = val;
                      });
                    },
                  ),
                  actions: [
                    FlatButton(
                      onPressed: () {
                        _insert(nowTask);
                      },
                      child: Text("add task"),
                    ),
                    FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Cancel"))
                  ],
                );
              });
        },
        child: Icon(Icons.add),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 10.0,
          ),
          // child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 80.0,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: Text(
                          "Taskslist",
                          style: TextStyle(
                              fontFamily: "PTSans",
                              fontSize: 50.0,
                              fontWeight: FontWeight.bold),
                        ))
                      ],
                    ),
                  ],
                ),
              ),
              // TaskTab()
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
              // Text("Today:${now}"),
              Text("${nowTask}"),
              Expanded(
                child: SizedBox(
                  child: ListView.builder(
                      itemCount: savedTasks.length,
                      itemBuilder: (BuildContext context, index) {
                        var i = savedTasks.length - index;
                        var indx = i - 1;
                        // print(index);
                        // print(indx);
                        return TaskTab(
                          id: savedTasks[indx].id,
                          colour: Color(0xFF212121),
                          title: savedTasks[indx].title,
                          date: savedTasks[indx].created_at,
                          status: false,
                        );
                      }),
                ),
              )
            ],
          ),
        ),
        // )
      ),
    );
  }

  void _insert(nownow) async {
    if (task == null) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Address is not well formatted"),
      ));
      Navigator.pop(context);
    }

    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelperTask.columnTitle: task,
      DatabaseHelperTask.columnStatus: 0,
      DatabaseHelperTask.columnCreated_at:nownow
    };
    final id = await dbHelperTask.insert(row);
    // print('inserted row id: $id');
    setState(() {
      task = null;
    });
    await _query();
    Navigator.pop(context);
  }

  void _query() async {
    final allRows = await dbHelperTask.queryAllRows();
    setState(() {
      setState(() {
        savedTasks = [];
      });
    });
    print('query all rows:');
    allRows.forEach((row) {
      var tasksModel =
          TaskModel(
            id: row['_id'], 
            title: row['task'], 
            status: row['status'],
            created_at: row['created_at']
          );
      savedTasks.add(tasksModel);
    });
    if (savedTasks.length == 0) {
      var tasksModell = TaskModel(
        id: "0",
        title: "Welcome", 
        status: "0",
        created_at:""
      );
      savedTasks.add(tasksModell);
      print(savedTasks);
    }
    setState(() {});
    print(savedTasks);
  }

  void _update() async {
    // row to update
    Map<String, dynamic> row = {
      DatabaseHelper.columnId: 1,
      DatabaseHelper.columnName: 'Mary',
      DatabaseHelper.columnAge: 32
    };
    final rowsAffected = await dbHelperTask.update(row);
    print('updated $rowsAffected row(s)');
  }

  void _delete() async {
    // Assuming that the number of rows is the id for the last row.
    final id = await dbHelperTask.queryRowCount();
    final rowsDeleted = await dbHelperTask.delete(id);
    // print('deleted $rowsDeleted row(s): row $id');
  }
}
