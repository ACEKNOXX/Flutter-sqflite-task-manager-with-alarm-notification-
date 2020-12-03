import 'package:flutter/material.dart';
import '../todolist.dart';
import '../constraints.dart';
import 'package:sqflite_demo/task/helpers/db_helper_todos.dart';
import 'package:sqflite_demo/task/helpers/db_helper_tasks.dart';

class Todo extends StatefulWidget {
  final id;
  final colour;
  final title;
  final date;
  final status;
  final onpressed;
  final checkBoxPress;
  Todo(
      {this.id,
      this.colour,
      this.title,
      this.status,
      this.date,
      this.onpressed,
      this.checkBoxPress
      });
  @override
  _TodoState createState() => _TodoState();
}

class _TodoState extends State<Todo> {
  final dbHelperTodo = DatabaseHelperTodos.instance;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    TodoList(taskListId: widget.id, taskTitle: widget.title)));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 7.0),
        padding: EdgeInsets.symmetric(
          horizontal: 8.0,
        ),
        height: 50.0,
        decoration: BoxDecoration(
          color: widget.colour,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text(
                    //   widget.date,
                    //   style: ktodoTabTitleStyle,
                    // ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Expanded(
                      child: Text(
                        widget.title,
                        style: ktodoTabTitleStyle,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FlatButton(
                    onPressed:widget.checkBoxPress,
                    child: Checkbox(
                      focusColor: Colors.red,
                      value: true,
                      onChanged: (val) {
                        print("djc");
                      },
                    ),
                  ),
                  IconButton(
                      onPressed: widget.onpressed,
                      icon: Icon(Icons.delete, color: Colors.grey, size: 15.0))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  
}
