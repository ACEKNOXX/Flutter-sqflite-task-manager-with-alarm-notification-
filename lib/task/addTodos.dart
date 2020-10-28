import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_demo/task/helpers/db_helper_todos.dart';
import 'package:sqflite_demo/task/helpers/db_helper_tasks.dart';
import 'package:sqflite_demo/task/models/todoModel.dart';
import 'package:sqflite_demo/task/taskList.dart';
import 'package:sqflite_demo/task/todolist.dart';
import 'package:sqflite_demo/task/widget.dart/todoTab.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'widget.dart/taskTab.dart';
import 'constraints.dart';

class AddTodos extends StatefulWidget {
  final taskId;
  final taskTitle;
  AddTodos({this.taskId,this.taskTitle});
  @override
  _AddTodosState createState() => _AddTodosState(taskId: taskId,taskTitle:taskTitle);
}

class _AddTodosState extends State<AddTodos> {
  final taskId;
  final taskTitle;
  _AddTodosState({this.taskId,this.taskTitle});
  DateTime _date = DateTime.now();
  TextEditingController _dateController = TextEditingController();
  final DateFormat _dateFormattter = DateFormat("MMM dd, yyyy");
  final List<String> _priorities = ['Low', 'Medium', 'High'];
  String _title;
  int _value = 1;
  String _priority;
  final _formkey = GlobalKey<FormState>();

  final dbHelperTask = DatabaseHelperTask.instance;
  final dbHelperTodo = DatabaseHelperTodos.instance;
  var todo;
  @override
  void initState() {
    super.initState();
    _dateController.text = _dateFormattter.format(_date);
  }

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
        ),
        body: SafeArea(
            child: Container(
                child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                padding: EdgeInsets.all(16.0),
                height: 80,
                child: Text(
                  "Add todos",
                  style: TextStyle(
                      fontFamily: "PTSans",
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold),
                )),
            Expanded(
                child: Row(
              children: [
                Expanded(
                  child: Container(
                     
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6.0),
                              color: kWhiteColor,
                              // border: Border.all()
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    decoration:
                                        InputDecoration(
                                          hintText: "Todor title")
                                        ,
                                    onChanged: (val) {
                                      setState(() {
                                         _title = val;
                                      });
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(height:20.0),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6.0),
                                    color: kWhiteColor,
                                    // border: Border.all()
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                        value: _value,
                                        items: [
                                          DropdownMenuItem(
                                            child: Text("Low "),
                                            value: 1,
                                          ),
                                          DropdownMenuItem(
                                            child: Text("Medium"),
                                            value: 2,
                                          ),
                                          DropdownMenuItem(
                                              child: Text("High"),
                                              value: 3),
                                       
                                        ],
                                        onChanged: (value) {
                                          setState(() {
                                            _value= value;
                                          });
                                        }),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height:30.0
                          ),
                          Align(
                            alignment:Alignment.bottomLeft,
                            child: RaisedButton(
                              color:Colors.redAccent,
                              onPressed:_submit,
                              child:Text("Add todo",style:TextStyle(color:Colors.white))
                            ),
                          )

                        ],
                      )),
                ),
              ],
            ))
          ],
        ))));
  }

  void _insert() async {
    if (todo == null) {}

    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelperTodos.columnTaskListId: taskId,
      DatabaseHelperTodos.columnTodoTitle: _title,
      DatabaseHelperTodos.columnPriority: _priorities[_value],
      DatabaseHelperTodos.columnStatus: 0
    };
    final id = await dbHelperTodo.insert(row);
    print('inserted row id: $id');
    setState(() {
      todo = null;
    });
  }

  _submit() async {
    // if (_formkey.currentState.validate()) {
      // _formkey.currentState.save();
      print("$_title $_date $_value");
      print("task list id =$taskId");

      // insert the todo to use db
      await _insert();
      // Update the task

      Navigator.push(
            context, MaterialPageRoute(builder: (context) => TodoList(taskListId:taskId,taskTitle:taskTitle)));
    // }
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
}
