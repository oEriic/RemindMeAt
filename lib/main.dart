import 'package:flutter/material.dart';
import 'create_task.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Remind Me At',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primaryColor: Colors.pink.shade100,
      ),
      home: new MyHomePage()
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  createState() => TaskList();
}

class TaskList extends State<MyHomePage> {
  List<String> _reminderList = [];

  void _addTaskItem(String task){
    if(task.length > 0){
      setState(() {
        _reminderList.add(task);
      });
    }
  }

  Widget _buildList(){
    return new ListView.builder(
      itemBuilder: (context, index){
        if(index < _reminderList.length){
          return _buildReminderItem(_reminderList[index], index);
        }
      },
    );
  }

  Widget _buildReminderItem(String task, int index){
    return new ListTile(
      title: new Text(task),
      onTap:() => _askRemoveTask(index)
    );
  }

  @override
  Widget build(BuildContext context){
    return new Scaffold(appBar: new AppBar(
      title: Text('Reminders')
    ),
    body: _buildList(),
    floatingActionButton: new FloatingActionButton(
      onPressed: _pushAddTaskScreen,
      tooltip: 'Add Tasks',
      child: new Icon(Icons.add),
    ),
    );
  }

  void _pushAddTaskScreen(){
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CreateTask(),
      )
    );
  }

  void _removeTaskItem(int index){
    setState(() => _reminderList.removeAt(index));
  }

  void _askRemoveTask(int index){
    showDialog(
      context: context, 
      builder: (BuildContext context){
        return AlertDialog(
          title: Text('Remove "${_reminderList[index]}"?'),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop()
              ),
            FlatButton( 
              child: Text('Mark as Complete'),
              onPressed: (){
                _removeTaskItem(index);
                Navigator.of(context).pop();
              }
              )
          ]
        );
      }
      );
  }
}
