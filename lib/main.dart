import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;


void main() async {
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
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
// 
Future selectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
    await Navigator.push( 
      context,
      MaterialPageRoute<void>(builder: (context) => MyHomePage()),
    );
}  
@override
    void initState() {
      super.initState();
      var androidInitilize = new AndroidInitializationSettings('mainlogo');
      var iOSinitilize = new IOSInitializationSettings();
      var initilizationsSettings =
          new InitializationSettings(android: androidInitilize, iOS: iOSinitilize);
      flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
      flutterLocalNotificationsPlugin.initialize(initilizationsSettings,
          onSelectNotification: selectNotification);
    }

  List<String> _reminderList = [];
  final _subjectText = TextEditingController();
  final _contentText = TextEditingController();
  final _locationText = TextEditingController();

  bool _validateSubject = true;
  bool _validateLocation = true;

  DateTime selectedDate;
  String date;
  int selectedTime;
  String timeParam;
  String subject;
  String content;
  String location;
  String error = '';
  
  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate == null ? DateTime.now() : selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        //"${selectedDate.toLocal()}".split(' ')[0];
        date = DateFormat.yMMMd().format(selectedDate).toString();
      });
  }

  // Future<void> _selectTime(BuildContext context) async {
  //   final TimeOfDay pickedS = await showTimePicker(
  //       context: context,
  //       initialTime: selectedTime == null ? TimeOfDay.now() : selectedTime,
  //       builder: (BuildContext context, Widget child) {
  //         return MediaQuery(
  //           data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
  //           child: child,
  //         );
  //       });

  //   if (pickedS != null && pickedS != selectedTime)
  //     setState(() {
  //       selectedTime = pickedS;
  //       time = pickedS.format(context);
  //     });
  // }
  // 
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
        // => CreateTask(),
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Add Task')
            ),
            body: SingleChildScrollView(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 80.0, horizontal: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      TextField(
                        controller: _subjectText,
                        decoration: InputDecoration(
                          errorText: _validateSubject
                              ? null
                              : 'Subject cannot be empty',
                          icon: Icon(
                            Icons.topic_outlined,
                            color: Colors.pink.shade100,
                          ),
                          labelText: 'Subject',
                          labelStyle: TextStyle(
                              //fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat',
                              color: Colors.grey),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.pink.shade100),
                          ),
                        ),
                      ),
                      TextField(
                        controller: _contentText,
                        keyboardType: TextInputType.multiline,
                        minLines: 1,
                        maxLines: 3,
                        decoration: InputDecoration(
                          icon: Icon(
                            Icons.content_paste_rounded,
                            color: Colors.pink.shade100,
                          ),
                          labelText: 'Content',
                          labelStyle: TextStyle(
                              //fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat',
                              color: Colors.grey),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.pink.shade100),
                          ),
                        ),
                      ),
                      // Text("${selectedDate.toLocal()}".split(' ')[0]),
                      TextField(
                        controller: _locationText,
                        decoration: InputDecoration(
                          errorText: _validateLocation
                              ? null
                              : 'Location cannot be empty',
                          icon: Icon(
                            Icons.location_pin,
                            color: Colors.pink.shade100,
                          ),
                          labelText: 'Location',
                          labelStyle: TextStyle(
                              //fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat',
                              color: Colors.grey),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.pink.shade100),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.calendar_today_rounded,
                            color: Colors.pink.shade100,
                          ),
                          SizedBox(width: 15.0),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              primary: Colors.pink.shade100,
                            ),
                            onPressed: () => _selectDate(context),
                            // child: Text('Select date'),
                            child: Text(
                              selectedDate == null
                                  ? 'Select a date'
                                  : "${selectedDate.toLocal()}".split(' ')[0],
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.av_timer_rounded,
                            color: Colors.pink.shade100,
                          ),
                          SizedBox(width: 15.0),
                          DropdownButton(
                            value: timeParam,
                            items: [
                              DropdownMenuItem(
                                child: Text("Hour"),
                                value: "Hour",
                              ),
                              DropdownMenuItem(
                                child: Text("Minutes"),
                                value: "Minutes",
                              ),
                              DropdownMenuItem(
                                child: Text("Second"),
                                value: "Second",
                              ),
                            ],
                            hint: Text("Set Time Parameter"),
                            onChanged: (_val){
                              setState((){
                                timeParam = _val;
                              });
                            },
                          ),
                          DropdownButton<int>(
                            value: selectedTime,
                            items: [
                              DropdownMenuItem<int>(
                                child: Text("1"),
                                value:1,
                                ),
                              DropdownMenuItem<int>(
                                child: Text("2"),
                                value:2,
                                ),
                              DropdownMenuItem<int>(
                                child: Text("3"),
                                value:3,
                                ),
                              DropdownMenuItem<int>(
                                child: Text("4"),
                                value:4,
                                ),
                              DropdownMenuItem<int>(
                                child: Text("5"),
                                value:5,
                                ),
                              DropdownMenuItem<int>(
                                child: Text("6"),
                                value:6,
                                ),
                              DropdownMenuItem<int>(
                                child: Text("7"),
                                value:7,
                                ),
                              DropdownMenuItem<int>(
                                child: Text("8"),
                                value:8,
                                ),
                              DropdownMenuItem<int>(
                                child: Text("9"),
                                value:9,
                                ),
                              DropdownMenuItem<int>(
                                child: Text("10"),
                                value:10,
                                ),
                            ],
                            hint: Text('Select Time Value'),
                            onChanged: (_val){
                              setState((){
                                selectedTime = _val;
                              });
                            },
                          )
                        ],
                      ),
                      RaisedButton(onPressed: showNotification,
                      child: Text('Set Time')),
                      SizedBox(height: 10.0),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          primary: Colors.pink.shade100,
                        ),
                        onPressed: () {
                          setState(
                            () {
                              bool subjectTextValid =
                                  _subjectText.text.isNotEmpty;
                              bool locationTextValid =
                                  _locationText.text.isNotEmpty;
                              if (subjectTextValid &&
                                  locationTextValid &&
                                  date != null) {
                                error = '';
                                _validateSubject = true;
                                _validateLocation = true;
                                subject = _subjectText.text.toString();
                                content = _contentText.text.toString();
                                location = _locationText.text.toString();
                                _addTaskItem(
                                    "$subject $date $content");
                                  Navigator.pop(context);
                              } else {
                                if (!subjectTextValid) {
                                  _validateSubject = false;
                                }
                                
                                if (date == null) {
                                  error = "You haven't chosen date or time";
                                }
                              }
                            },
                          );
                          // _save();
                        },
                        child: 
                        Text(
                          'Create',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Text(
                        error,
                        style: TextStyle(color: Colors.red, fontSize: 14.0),
                      ),
                    ],
                  ),
                ),
              ), 
            );
        }
      )
    );
  }

Future showNotification() async{
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('America/New_York'));
    var androidDets = new AndroidNotificationDetails(
      'channel id', 'channel NAME', 'CHANNEL DESCRIPTION',
      priority: Priority.high,importance: Importance.max
    );
    var iOSDetails = new IOSNotificationDetails();
    var platform = new NotificationDetails(android: androidDets, iOS: iOSDetails);
    var timeSet;
    if (timeParam == "Hour") {
      timeSet = tz.TZDateTime.now(tz.local).add(Duration(hours: selectedTime));
    } else if (timeParam == "Minute") {
      timeSet = tz.TZDateTime.now(tz.local).add(Duration(minutes: selectedTime));
    } else {
      timeSet = tz.TZDateTime.now(tz.local).add(Duration(seconds: selectedTime));
    }
    
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0, "You Have a Task!", "Click on me to view Task", timeSet, platform, androidAllowWhileIdle: true, uiLocalNotificationDateInterpretation: null);

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
