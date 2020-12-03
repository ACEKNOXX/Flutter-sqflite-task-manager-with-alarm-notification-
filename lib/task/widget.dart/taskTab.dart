import 'package:flutter/material.dart';
import '../todolist.dart';
import '../constraints.dart';

class TaskTab extends StatefulWidget {
  final id;
  final colour;
  final title;
  final date;
  final status;
  TaskTab({this.id,this.colour, this.title, this.status, this.date});
  @override
  _TaskTabState createState() => _TaskTabState();
}

class _TaskTabState extends State<TaskTab> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => TodoList(taskListId:widget.id,taskTitle:widget.title)));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 7.0),
        padding: EdgeInsets.all(8.0),
        height: 150.0,
        decoration: BoxDecoration(
          color: widget.colour,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Created on ${widget.date}",
                      style: ktaskTabDateStyle,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    
                    Flexible(
                      child: RichText(
                        overflow: TextOverflow.ellipsis,
                        strutStyle: StrutStyle(fontSize: 12.0),
                        text: TextSpan(
                            style: ktaskTabTitleStyle, text: widget.title),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}
