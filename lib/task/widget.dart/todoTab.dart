import 'package:flutter/material.dart';
import '../todolist.dart';
import '../constraints.dart';

class Todo extends StatefulWidget {
  final id;
  final colour;
  final title;
  final date;
  final status;
  Todo({this.id,this.colour, this.title, this.status, this.date});
  @override
  _TodoState createState() => _TodoState();
}

class _TodoState extends State<Todo> {

  @override
  Widget build(BuildContext context) {
     return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => TodoList(taskListId:widget.id,taskTitle:widget.title)));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 7.0),
        padding: EdgeInsets.symmetric(horizontal:8.0,),
        height: 50.0,
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
                    // Text(
                    //   widget.date,
                    //   style: ktodoTabTitleStyle,
                    // ),
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
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  child: Row(
                    children: [
                      Switch(
                          value: widget.status,
                          onChanged: (val) {
                            setState(() {
                              // widget.status =
                            });
                          })
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
