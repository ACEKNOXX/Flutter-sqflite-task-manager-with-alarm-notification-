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
    return Scaffold(
      appBar: AppBar(
        actions: [
          Container(
            child: IconButton(
                color: kDangerColor,
                icon: Icon(Icons.add),
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
                              onPressed: _insert,
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
                }),
          )
        ],
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
                height: 150.0,
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
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              validator: (val) =>
                                  val.isEmpty ? 'required' : null,
                              onChanged: (val) {
                                setState(() => searchTask = val);
                              },
                              decoration: InputDecoration(
                                suffixIcon: Icon(
                                  Icons.search,
                                  color: kBlackColor,
                                ),
                                // hintText: "Location",
                                hintStyle: TextStyle(color: Colors.grey),
                                filled: true,
                                fillColor: kWhiteColor,
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: kWhite1Color),
                                    borderRadius: BorderRadius.circular(50.0)),
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xFF212121)),
                                    borderRadius: BorderRadius.circular(20.0)),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: kWhiteColor, width: 5.0),
                                    borderRadius: BorderRadius.circular(20.0)),
                              )),
                        )
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
              Text("Today:${now}"),
              Expanded(
                child: SizedBox(
                  child: ListView.builder(
                      itemCount: savedTasks.length,
                      itemBuilder: (BuildContext context, index) {
                        var i = savedTasks.length - index;
                        var indx = i - 1;
                        // print(index);
                        print(indx);
                        return TaskTab(
                          id: savedTasks[indx].id,
                          colour: Color(0xFF212121),
                          title: savedTasks[indx].title,
                          date: "20 Aug 2020",
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

  void _insert() async {
    if (task == null) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Address is not well formatted"),
      ));
      Navigator.pop(context);
    }

    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelperTask.columnTitle: task,
      DatabaseHelperTask.columnStatus: 23
    };
    final id = await dbHelperTask.insert(row);
    print('inserted row id: $id');
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
          TaskModel(id: row['_id'], title: row['task'], status: row['status']);
      savedTasks.add(tasksModel);
    });
    if (savedTasks.length == 0) {
      var tasksModell = TaskModel(id: "0", title: "Welcome", status: "0");
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
    print('deleted $rowsDeleted row(s): row $id');
  }
}