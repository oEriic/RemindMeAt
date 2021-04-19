// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:async';
// import 'dart:io';
// class CreateTask extends StatefulWidget{
//   @override
//   _CreateTaskState createState() => _CreateTaskState();
// }

// class _CreateTaskState extends State<CreateTask>{
//   final _subjectText = TextEditingController();
//   final _contentText = TextEditingController();
//   final _locationText = TextEditingController();

//   bool _validateSubject = true;
//   bool _validateLocation = true;
  
//   DateTime selectedDate;
//   String date;
//   TimeOfDay selectedTime;
//   String time;
//   String subject;
//   String content;
//   String location;
//   String error = '';

//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime picked = await showDatePicker(
//         context: context,
//         initialDate: selectedDate == null ? DateTime.now() : selectedDate,
//         firstDate: DateTime(2015, 8),
//         lastDate: DateTime(2101));
//     if (picked != null && picked != selectedDate)
//       setState(() {
//         selectedDate = picked;
//         //"${selectedDate.toLocal()}".split(' ')[0];
//         date = DateFormat.yMMMd().format(selectedDate).toString();
//       });
//   }

//   Future<void> _selectTime(BuildContext context) async {
//     final TimeOfDay pickedS = await showTimePicker(
//         context: context,
//         initialTime: selectedTime == null ? TimeOfDay.now() : selectedTime,
//         builder: (BuildContext context, Widget child) {
//           return MediaQuery(
//             data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
//             child: child,
//           );
//         });

//     if (pickedS != null && pickedS != selectedTime)
//       setState(() {
//         selectedTime = pickedS;
//         time = pickedS.format(context);
//       });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//               appBar: AppBar(
//                 title: Text('Create A Meeting'),
//               ),
//               body: SingleChildScrollView(
//                 child: Padding(
//                   padding:
//                       EdgeInsets.symmetric(vertical: 80.0, horizontal: 20.0),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: <Widget>[
//                       TextField(
//                         controller: _subjectText,
//                         decoration: InputDecoration(
//                           errorText: _validateSubject
//                               ? null
//                               : 'Subject cannot be empty',
//                           icon: Icon(
//                             Icons.topic_outlined,
//                             color: Colors.pink.shade100,
//                           ),
//                           labelText: 'Subject',
//                           labelStyle: TextStyle(
//                               //fontWeight: FontWeight.bold,
//                               fontFamily: 'Montserrat',
//                               color: Colors.grey),
//                           focusedBorder: UnderlineInputBorder(
//                             borderSide: BorderSide(color: Colors.pink.shade100),
//                           ),
//                         ),
//                       ),
//                       TextField(
//                         controller: _contentText,
//                         keyboardType: TextInputType.multiline,
//                         minLines: 1,
//                         maxLines: 3,
//                         decoration: InputDecoration(
//                           icon: Icon(
//                             Icons.content_paste_rounded,
//                             color: Colors.pink.shade100,
//                           ),
//                           labelText: 'Content',
//                           labelStyle: TextStyle(
//                               //fontWeight: FontWeight.bold,
//                               fontFamily: 'Montserrat',
//                               color: Colors.grey),
//                           focusedBorder: UnderlineInputBorder(
//                             borderSide: BorderSide(color: Colors.pink.shade100),
//                           ),
//                         ),
//                       ),
//                       // Text("${selectedDate.toLocal()}".split(' ')[0]),
//                       TextField(
//                         controller: _locationText,
//                         decoration: InputDecoration(
//                           errorText: _validateLocation
//                               ? null
//                               : 'Location cannot be empty',
//                           icon: Icon(
//                             Icons.location_pin,
//                             color: Colors.pink.shade100,
//                           ),
//                           labelText: 'Location',
//                           labelStyle: TextStyle(
//                               //fontWeight: FontWeight.bold,
//                               fontFamily: 'Montserrat',
//                               color: Colors.grey),
//                           focusedBorder: UnderlineInputBorder(
//                             borderSide: BorderSide(color: Colors.pink.shade100),
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 10.0,
//                       ),
//                       Row(
//                         children: <Widget>[
//                           Icon(
//                             Icons.calendar_today_rounded,
//                             color: Colors.pink.shade100,
//                           ),
//                           SizedBox(width: 15.0),
//                           ElevatedButton(
//                             style: ElevatedButton.styleFrom(
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(10.0),
//                               ),
//                               primary: Colors.pink.shade100,
//                             ),
//                             onPressed: () => _selectDate(context),
//                             // child: Text('Select date'),
//                             child: Text(
//                               selectedDate == null
//                                   ? 'Select a date'
//                                   : "${selectedDate.toLocal()}".split(' ')[0],
//                               style: TextStyle(
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       Row(
//                         children: <Widget>[
//                           Icon(
//                             Icons.av_timer_rounded,
//                             color: Colors.pink.shade100,
//                           ),
//                           SizedBox(width: 15.0),
//                           ElevatedButton(
//                             style: ElevatedButton.styleFrom(
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(10.0),
//                               ),
//                               primary: Colors.pink.shade100,
//                             ),
//                             onPressed: () => _selectTime(context),
//                             // child: Text('Select date'),
//                             child: Text(
//                               selectedTime == null
//                                   ? 'Select time'
//                                   : selectedTime.format(context),
//                               style: TextStyle(
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 10.0),
//                       ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10.0),
//                           ),
//                           primary: Colors.pink.shade100,
//                         ),
//                         onPressed: () {
//                           setState(
//                             () {
//                               bool subjectTextValid =
//                                   _subjectText.text.isNotEmpty;
//                               bool locationTextValid =
//                                   _locationText.text.isNotEmpty;
//                               if (subjectTextValid &&
//                                   locationTextValid &&
//                                   date != null &&
//                                   time != null) {
//                                 error = '';
//                                 _validateSubject = true;
//                                 _validateLocation = true;
//                                 subject = _subjectText.text.toString();
//                                 content = _contentText.text.toString();
//                                 location = _locationText.text.toString();
//                                 print(
//                                     "$subject $date $time $content");
//                               } else {
//                                 if (!subjectTextValid) {
//                                   _validateSubject = false;
//                                 }
                                
//                                 if (date == null || time == null) {
//                                   error = "You haven't chosen date or time";
//                                 }
//                               }
//                             },
//                           );
//                           // _save();
//                         },
//                         child: 
//                         Text(
//                           'Create',
//                           style: TextStyle(
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                       Text(
//                         error,
//                         style: TextStyle(color: Colors.red, fontSize: 14.0),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//   }
//   // Future<String> get _localPath async{
//   // final directory = await getApplicationDocumentsDirectory();
//   // return directory.path;
//   // }

//   // Future<File> get _localFile async{
//   //   final path = await _localPath;
//   //   return File('$path/data.txt');
//   // }

//   // Future<file writeContent(String task, String content, DateTime date, DateTime time) async{
//   //   final file = await _localFile;

//   //   return file.writeAsString(task + content);
    
//   // }
// }