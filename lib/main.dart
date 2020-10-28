import 'package:flutter/material.dart';
// change `flutter_database` to whatever your project name is
import 'package:sqflite_demo/db_helper.dart';
import 'package:sqflite_demo/task/helpers/db_helper_tasks.dart';
import 'package:sqflite_demo/task/taskList.dart';
import 'package:sqflite_demo/task/constraints.dart';
import 'package:sqflite_demo/tester.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var initializationSettingsAndriod = AndroidInitializationSettings('i_manage');



  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SQFlite Demo',
      theme: ThemeData(
        appBarTheme:
            AppBarTheme(centerTitle: true, elevation: 0.5, color: kWhite1Color),
        primarySwatch: Colors.pink,
        scaffoldBackgroundColor: kWhite1Color,
        // primarySwatch: Colors.blue,
        // visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // home: MyHomePage(),
      home: TaskList(),
      // home:DateTimePicker(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final dbHelper = DatabaseHelper.instance;
  final dbHelperTask = DatabaseHelperTask.instance;
  var task;

  // homepage layout
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('sqflite'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              onPressed: () async {
                final allRows = await dbHelperTask.queryAllRows();
                print('query all rows:');
                allRows.forEach((row) => print(row));
              },
              child: Text("get all tasks"),
            ),
            Container(
                padding: EdgeInsets.all(32),
                child: Column(
                  children: [
                    Text(
                      task == null ? "no data yet" : task,
                    ),
                    TextFormField(
                      onChanged: (val) {
                        setState(() {
                          task = val;
                        });
                      },
                    ),
                    RaisedButton(
                        child: Text("insert from form"),
                        onPressed: () async {
                          Map<String, dynamic> row = {
                            DatabaseHelperTask.columnTitle: task,
                            DatabaseHelperTask.columnStatus: 288
                          };
                          final id = await dbHelperTask.insert(row);
                          print('inserted row id: $id');
                        })
                  ],
                )),
            RaisedButton(
              child: Text(
                'insert',
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () {
                _insert();
              },
            ),
            RaisedButton(
              child: Text(
                'query',
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () {
                _query();
              },
            ),
            RaisedButton(
              child: Text(
                'update',
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () {
                _update();
              },
            ),
            RaisedButton(
              child: Text(
                'delete',
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () {
                _delete();
              },
            ),
          ],
        ),
      ),
    );
  }

  // Button onPressed methods

  void _insert() async {
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.columnName: 'Bob',
      DatabaseHelper.columnAge: 23
    };
    final id = await dbHelper.insert(row);
    print('inserted row id: $id');
  }

  void _query() async {
    final allRows = await dbHelper.queryAllRows();
    print('query all rows:');
    allRows.forEach((row) => print(row));
  }

  void _update() async {
    // row to update
    Map<String, dynamic> row = {
      DatabaseHelper.columnId: 1,
      DatabaseHelper.columnName: 'Mary',
      DatabaseHelper.columnAge: 32
    };
    final rowsAffected = await dbHelper.update(row);
    print('updated $rowsAffected row(s)');
  }

  void _delete() async {
    // Assuming that the number of rows is the id for the last row.
    final id = await dbHelper.queryRowCount();
    final rowsDeleted = await dbHelper.delete(id);
    print('deleted $rowsDeleted row(s): row $id');
  }
}
